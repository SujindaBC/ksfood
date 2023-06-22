import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class PromptPayScreen extends StatelessWidget {
  static const routeName = "/promptpay";
  const PromptPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PromptPay Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Download SVG Image'),
          onPressed: () {
            _downloadSvgImage();
          },
        ),
      ),
    );
  }

  void _downloadSvgImage() async {
    String downloadUrl =
        "https://api.omise.co/charges/chrg_test_5sqhgjedme2u2atfhuc/documents/docu_test_5sqhgjg71l2hm8dxra4/downloads/167C00410B655C0D";

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    log(appDocPath);

    try {
      Directory directory = Directory(appDocPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final taskId = await FlutterDownloader.enqueue(
        url: downloadUrl,
        savedDir: appDocPath,
        fileName: "qrcode_test.svg",
        showNotification: true,
        openFileFromNotification: true,
      );
      log('Download task id: $taskId');
    } catch (error) {
      log('Error while downloading SVG image: $error');
    }
  }
}
