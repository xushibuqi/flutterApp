import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class FileTransferPage extends StatefulWidget {
  @override
  _FileTransferPageState createState() => _FileTransferPageState();
}

class _FileTransferPageState extends State<FileTransferPage> {
  Socket? _socket;
  bool _connected = true;
  double _progress = 0.0;

  // 连接到目标设备
  Future<void> _connectToDevice() async {
    try {
      // 目标设备的 IP 地址和端口号
      String ipAddress = '127.0.0.1';
      int port = 4444;

      // 创建一个 Socket
      Duration timeoutDuration = Duration(seconds: 3);
      _socket = await Socket.connect(ipAddress, port,timeout: timeoutDuration);
      setState(() {
        _connected = true;
      });
      print('Connected to $ipAddress:$port');
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  // 选择要发送的文件
  Future<void> _pickAndSendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      int fileSize = await file.length();
      print('Selected file: $fileName, size: $fileSize bytes');

      // 发送文件名和大小给服务器
      _socket?.write('$fileName:$fileSize');

      // 打开文件并发送数据
      Stream<List<int>> fileStream = file.openRead();
      await fileStream.forEach((data) {
        _socket?.add(data);
        setState(() {
          _progress += data.length / fileSize;
        });
      });

      print('File sent successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Transfer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _connected ? null : _connectToDevice,
              child: Text(_connected ? 'Connected' : 'Connect'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connected ? _pickAndSendFile : null,
              child: Text('Pick and Send File'),
            ),
            SizedBox(height: 20),
            _connected
                ? LinearProgressIndicator(value: _progress)
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FileTransferPage(),
  ));
}