import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileTransferService {
  ServerSocket? _serverSocket;
  Socket? _clientSocket;

  Future<void> startServer(Function(File, int) onProgressUpdate) async {
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 55555);
    _serverSocket!.listen((Socket socket) {
      _handleConnection(socket, onProgressUpdate);
    });
  }

  Future<void> _handleConnection(
      Socket socket, Function(File, int) onProgressUpdate) async {
    int bytesRead = 0;
    bool received = false;

    String fileName = '';
    int fileSize = 0;
    late File file;
    Directory? externalDir = (Platform.isAndroid || Platform.isIOS)
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    late IOSink sink;
    String externalPath = externalDir!.path;
    socket.listen((List<int> data) async {
      if (!received) {
        var str = String.fromCharCodes(data);
        var split = str.split('!@@#');
        fileName = split[0];
        fileSize = int.parse(split[1]);
        received = true;

        // 检查并创建目录
        final dir = Directory(path.join(externalPath, "buqi"));
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        fileName = await checkFile(externalPath, fileName);
        String filePath = path.join(externalPath, "buqi", fileName);
        file = File(filePath);
        sink = file.openWrite(mode: FileMode.append);
      } else {
        print(data.length);
        if (String.fromCharCodes(data) == "EOF" && bytesRead >= fileSize) {
          // 文件接收完成
          await sink.flush();
          await sink.close();
          onProgressUpdate(file, 100);
          socket.destroy();
        } else {
          sink.add(data);
          bytesRead += data.length;
          print(data.length);
          // 更新进度
          int progress = ((bytesRead / fileSize) * 100).toInt();
          onProgressUpdate(file, progress);
        }
      }
    });
  }

  Future<String> checkFile(String externalPath, String fileName) async {
    String filePath = path.join(externalPath, "buqi", fileName);
    File file = File(filePath);
    bool fileExists = await file.exists();

    if (fileExists) {
      // 文件存在，生成新的文件名并递归调用
      final RegExp regex = RegExp(r'(.+?)(\(\d+\))?(\.\w+)$');
      final RegExpMatch? match = regex.firstMatch(fileName);

      if (match == null) {
        throw ArgumentError('Invalid file name format');
      }

      // 获取文件名前缀、数字部分和扩展名
      final String? prefix = match.group(1);
      final String? numberPart = match.group(2);
      final String? extension = match.group(3);

      // 提取数字部分并加 1
      int number = 0;
      if (numberPart != null) {
        number = int.parse(numberPart.replaceAll(RegExp(r'[^\d]'), ''));
      }
      number += 1;
      fileName = '$prefix($number)$extension';

      // 递归调用
      return await checkFile(externalPath, fileName);
    } else {
      return fileName;
    }
  }

  Future<void> sendFile(String ip, File file) async {
    Socket? clientSocket;
    try {
      clientSocket = await Socket.connect(ip, 55555);
      String fileName = path.basename(file.path);
      final fileSize = await file.length();
      final Uint8List fileNameBytes =
          Uint8List.fromList("$fileName!@@#$fileSize!@@#".codeUnits);

      // 发送文件名
      clientSocket.add(fileNameBytes);
      await clientSocket.flush();

      await Future.delayed(const Duration(seconds: 1));

      final fileStream = file.openRead();
      await clientSocket.addStream(fileStream); // 发送完所有数据后再次flush
      await clientSocket.flush();
      await Future.delayed(const Duration(seconds: 1));
      // 结束标志
      clientSocket.add(Uint8List.fromList("EOF".codeUnits));
      await clientSocket.flush();
    } catch (e) {
      // 处理异常，例如打印错误日志
      print('Error sending file: $e');
    } finally {
      // 确保Socket被关闭
      clientSocket?.close();
    }
  }

  void dispose() {
    _serverSocket?.close();
    _clientSocket?.close();
  }
}
