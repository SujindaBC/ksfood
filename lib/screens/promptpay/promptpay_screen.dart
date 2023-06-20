import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PromptPayScreen extends StatelessWidget {
  static const routeName = "/promptpay";
  const PromptPayScreen({
    super.key,
    required this.qrCodeImageDownloadUri,
  });

  final String qrCodeImageDownloadUri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: qrCodeImageDownloadUri,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            const Text(
              'Scan the QR code to make the payment',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
