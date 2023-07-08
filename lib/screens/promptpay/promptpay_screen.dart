import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:ksfood/screens/promptpay/widgets/countdown_timer.dart';

class PromptPayScreen extends StatelessWidget {
  static const routeName = "/promptpay";
  const PromptPayScreen({
    super.key,
  });

  // Future<Map<String, dynamic>> fetchChargeData({
  //   required String amount,
  //   required String type,
  // }) async {
  //   try {
  //     final url = Uri.parse("https://api.omise.co/charges");
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Authorization": "Basic c2tleV90ZXN0XzVueGR2cGM4N3Z3c3JwdTZ6Z286",
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body: {
  //         'amount': amount,
  //         'currency': 'THB',
  //         "source[type]": type,
  //         "mobile_number": FirebaseAuth.instance.currentUser?.phoneNumber,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       return json.decode(response.body);
  //     } else {
  //       throw Exception(response.statusCode);
  //     }
  //   } on http.BaseResponse catch (error) {
  //     log(error.toString());
  //     throw Exception(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
    final String downloadUri = arguments["downloadUri"].toString();
    final String expiresAt = arguments["expiresAt"].toString();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PromptPay Screen'),
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
