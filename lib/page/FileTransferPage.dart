import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../style/backgroundColor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Transfer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FileTransferPage(url: '192.168.0.100'),
    );
  }
}

class FileTransferPage extends StatefulWidget {
  final String url;

  const FileTransferPage({Key? key, required this.url}) : super(key: key);

  @override
  _FileTransferPageState createState() => _FileTransferPageState();
}

class _FileTransferPageState extends State<FileTransferPage> {
  String get _remoteIp => widget.url;
  bool _isConnected = false;
  List<File> _selectedFiles = [];
  List<File> _receivedFiles = [];
  List<double> _sendProgress = [];
  List<double> _receiveProgress = [];

  @override
  Widget build(BuildContext context) {
    return SharedGradientContainer(
      childBuilder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('文件传输'),
          backgroundColor: Colors.transparent,
        ),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '  $_remoteIp   ',
                        style: TextStyle(fontSize: 13),
                      ),
                      Icon(
                        FontAwesomeIcons.solidCircle,
                        size: 10,
                        color: _isConnected? Colors.green:Colors.red,
                      ),
                    ],
                  ),


                  Expanded(
                    child: ListView.builder(
                      itemCount: _selectedFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title:
                              Text(_selectedFiles[index].path.split('/').last),
                          trailing: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _selectedFiles.removeAt(index);
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List<File>? files = await _pickFiles();
                      if (files != null) {
                        _selectedFiles.addAll(files);
                        setState(() {});
                      }
                    },
                    child: Text('Select Files'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _sendFiles(_selectedFiles);
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Received Files:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _receivedFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title:
                              Text(_receivedFiles[index].path.split('/').last),
                          trailing: Text('${_receiveProgress[index]}%'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<File>?> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        return files;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void _sendFiles(List<File> files) {
    files.forEach((file) {
      _sendFile(file);
    });
  }

  void _sendFile(File file) {
    // Send file to remote IP
    double progress = 0;
    _sendProgress.add(progress);
    setState(() {});

    // Simulating sending progress
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      progress += 10;
      _sendProgress[_sendProgress.length - 1] = progress;
      setState(() {});
      if (progress >= 100) {
        timer.cancel();
      }
    });
  }

  void _receiveFile(File file) {
    double progress = 0;
    _receiveProgress.add(progress);
    setState(() {});

    // Simulating receiving progress
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      progress += 10;
      _receiveProgress[_receiveProgress.length - 1] = progress;
      setState(() {});
      if (progress >= 100) {
        timer.cancel();
      }
    });
  }
}
