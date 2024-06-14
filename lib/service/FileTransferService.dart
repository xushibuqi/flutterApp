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
    List<int> fileNameBytes = [];

    int bytesRead = 0;
    bool Received = false;

    String fileName = '';
    int fileSize = 0;

    socket.listen((List<int> data) async {
      if (!Received) {
        fileNameBytes.addAll(data);
        if (utf8.decode(fileNameBytes).contains('!@@#')) {
          var split = utf8.decode(fileNameBytes).split('!@@#');
          fileName = split[0];
          fileSize = int.parse(split[1]);
          Received = true;
          fileNameBytes.clear();
        }
      } else {
        final directory = await getApplicationDocumentsDirectory();

        // 检查并创建目录
        final dir = Directory(path.join(directory.path, "buqi"));
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        final filePath = path.join(directory.path,"buqi", fileName);

        final file = File(filePath);
        final IOSink sink = file.openWrite(mode: FileMode.append);






        sink.add(data);
        bytesRead += data.length;

        // 更新进度
        int progress = ((bytesRead / fileSize) * 100).toInt();
        onProgressUpdate(file, progress);

        if (bytesRead >= fileSize) {
          print('===============');
          // 文件接收完成
          await sink.flush();
          await sink.close();
          onProgressUpdate(file, 100);
          socket.destroy();
        }
      }
    });
  }

  Future<void> sendFile(String ip, File file) async {
    Socket? clientSocket;
    try {
      clientSocket = await Socket.connect(ip, 55555);
      String fileName = path.basename(file.path);
      final fileSize = await file.length();
      final Uint8List fileNameBytes = Uint8List.fromList(utf8.encode("$fileName!@@#$fileSize!@@#"));

      // 发送文件名
      clientSocket.add(fileNameBytes);
      await clientSocket.flush(); // 只在这里调用一次flush
      await Future.delayed(const Duration(seconds: 1));
      final fileStream = file.openRead();
      await for (var chunk in fileStream) {
        clientSocket.add(chunk);
      }
      await clientSocket.flush(); // 发送完所有数据后再次flush
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
