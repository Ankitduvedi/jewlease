import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadScreen extends StatefulWidget {
  const FileDownloadScreen({super.key});

  @override
  _FileDownloadScreenState createState() => _FileDownloadScreenState();
}

class _FileDownloadScreenState extends State<FileDownloadScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _filePath = '';

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      // Get the directory to save the downloaded file
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/ItemConfiguration.xlsx';

      setState(() {
        _isDownloading = true;
      });

      // Download the file
      await dio.download(
        'http://13.239.113.142:3000/ItemConfiguration/download',
        filePath,
        onReceiveProgress: (received, total) {
          setState(() {
            _downloadProgress = (received / total);
          });
        },
      );

      setState(() {
        _isDownloading = false;
        _filePath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File downloaded to $_filePath')),
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Download Example'),
      ),
      body: Center(
        child: _isDownloading
            ? CircularProgressIndicator(value: _downloadProgress)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: downloadFile,
                    child: Text('Download File'),
                  ),
                  if (_filePath.isNotEmpty)
                    Text('Downloaded file saved at: $_filePath'),
                ],
              ),
      ),
    );
  }
}
