import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:ksfood/core/data/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/core/presentation/loading/loading_screen.dart';
import 'package:ksfood/core/presentation/screens/main/main_screen.dart';
import 'package:ksfood/core/presentation/screens/promptpay/widgets/countdown_timer.dart';

class PromptPayScreen extends StatelessWidget {
  static const routeName = "/promptpay";

  const PromptPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responseBody =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;

    // Extract the relevant data from the response
    final String downloadUri = responseBody["source"]["scannable_code"]["image"]
            ["download_uri"]
        .toString();
    final String amount = (responseBody["amount"] / 100).toStringAsFixed(2);
    final String chargeId = responseBody["id"].toString();

    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("charges")
            .doc(chargeId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final chargeData = snapshot.data!.data() as Map<String, dynamic>;
            final String status = chargeData["status"];
            final String expiresAtTimestamp = chargeData['expires_at'];
            final DateTime expiresAtDateTime =
                DateTime.parse(expiresAtTimestamp);
            final DateTime now = DateTime.now();

            // Use addPostFrameCallback to defer the navigation action
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (now.isAfter(expiresAtDateTime)) {
                Navigator.of(context).pop();
              } else if (status == "successful") {
                context.read<CartBloc>().add(const ClearCart());
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainScreen.routeName, (route) => false);
              } else if (status != "pending") {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Payment failed, Please try again.")));
              }
            });

            return Scaffold(
              appBar: AppBar(
                title: const Text("PromptPay Screen"),
              ),
              body: FutureBuilder<File>(
                future: DefaultCacheManager().getSingleFile(downloadUri),
                builder: (context, fileSnapshot) {
                  if (fileSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (fileSnapshot.hasError) {
                    return Center(
                      child: Text('FileSnapshot error: ${fileSnapshot.error}'),
                    );
                  } else if (fileSnapshot.hasData) {
                    LoadingScreen.instance().hide();
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
                              width: MediaQuery.of(context).size.width * 0.7,
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
                              .format(expiresAtDateTime.toLocal())),
                          CountdownTimer(
                            expiresAt: expiresAtDateTime.toLocal(),
                            chargeId: chargeId,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Center(
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
                          ),
                          const SizedBox(height: 16),
                          Text("Amount: ฿$amount"),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
