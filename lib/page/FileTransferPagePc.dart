import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../service/FileTransferService.dart';
import '../style/backgroundColor.dart';
import '../utils/SocketUtil.dart';
import 'package:path/path.dart' as path;

class FileTransferPagePc extends StatefulWidget {
  final String url;

  const FileTransferPagePc({Key? key, required this.url}) : super(key: key);

  @override
  _FileTransferPageState createState() => _FileTransferPageState();
}

class _FileTransferPageState extends State<FileTransferPagePc> {
  String get _remoteIp => widget.url;
  bool _isConnected = false;
  final List<File> _selectedFiles = [];
  final List<File> _receivedFiles = [];
  final List<int> _receiveProgress = [];
  late FileTransferService _fileTransferService;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _fileTransferService = FileTransferService();
    _fileTransferService.startServer((file, progress) {
      setState(() {
        int index = _receivedFiles.indexWhere((element) =>
            path.basename(element.path) ==
            path.basename(file.path)); // 假设用文件名作为唯一标识
        if (index == -1) {
          // 文件不在列表中，添加新文件及其进度
          _receivedFiles.add(file);
          _receiveProgress.add(progress);
        } else {
          // 文件已在列表中，更新其进度
          _receiveProgress[index] = progress;
        }
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _fileTransferService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String ip = _remoteIp;
    return SharedGradientContainer(
      childBuilder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('文件传输 $ip'),
          backgroundColor: Colors.transparent,
        ),
        body: Row(
          children: [
            const SizedBox(width: 3),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '  连接状态 :  ',
                            style: TextStyle(fontSize: 17),
                          ),
                          Icon(
                            FontAwesomeIcons.solidCircle,
                            size: 15,
                            color: _isConnected ? Colors.green : Colors.red,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              _selectedFiles.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _selectedFiles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 30,
                              child: ListTile(
                                title: Text(
                                  path.basename(_selectedFiles[index].path),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 16,
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _selectedFiles.removeAt(index);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 3),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                List<File>? files = await _pickFiles();
                                if (files != null) {
                                  _selectedFiles.addAll(files);
                                  setState(() {});
                                }
                              },
                              child: const Text(
                                'Select Files',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _sendFiles(_selectedFiles);
                              },
                              child: const Text(
                                'Send',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      ' Received Files',
                      style: TextStyle(fontSize: 15),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _receivedFiles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                                _receivedFiles[index].path.split('/').last),
                            trailing: Text('${_receiveProgress[index]}%'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 3),
          ],
        ),
      ),
    );
  }

  Future<List<File>?> _pickFiles() async {
    try {
      // 提示用户选择文件
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      // 如果用户选择了文件，处理文件路径
      if (result != null && result.paths.isNotEmpty) {
        List<File> files =
            result.paths.map((filePath) => File(filePath!)).toList();
        return files;
      }
    } catch (e) {
      // 捕获并输出任何异常
      print("文件选择失败：$e");
    }

    // 如果未选择文件或发生错误，返回null
    return null;
  }

  void _sendFiles(List<File> files) async {
    for (File file in files) {
      await _fileTransferService.sendFile(_remoteIp, file);
    }
  }
}
