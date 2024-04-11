import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:ksfood/screens/promptpay/widgets/countdown_timer.dart';

class PromptPayScreen extends StatelessWidget {
  static const routeName = "/promptpay";

  const PromptPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responseBody = ModalRoute.of(context)!.settings.arguments! as String;

    // Parse the JSON response
    final responseData = json.decode(responseBody);

    // Extract the relevant data from the response
    final String downloadUri = responseData["source"]["scannable_code"]["image"]
            ["download_uri"]
        .toString();
    final String expiresAt = responseData["expires_at"].toString();
    final String amount = (responseData["amount"] / 100).toStringAsFixed(2);
    final String status = responseData["status"].toString();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("PromptPay Screen"),
        ),
        body: FutureBuilder<File>(
          future: DefaultCacheManager().getSingleFile(downloadUri),
          builder: (context, fileSnapshot) {
            if (fileSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (fileSnapshot.hasError) {
              return Center(
                child: Text('FileSnapshot error: ${fileSnapshot.error}'),
              );
            } else if (fileSnapshot.hasData) {
              log("Snapshot from cache manager: ${fileSnapshot.data!.toString()}");
              final svgFile = fileSnapshot.data!;
              log(svgFile.path);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: AspectRatio(
                          aspectRatio: 4 / 6,
                          child: InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: Uri.file(
                                svgFile.path,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(DateFormat('MMM d, yyyy - HH:mm:ss')
                        .format(DateTime.parse(expiresAt))),
                    CountdownTimer(expiresAt: DateTime.parse(expiresAt)),
                    Center(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.file_download,
                            ),
                          ),
                          const Text("Download QR")
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text("Amount: $amount THB"),
                    const SizedBox(height: 8),
                    Text("Status: $status"),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
