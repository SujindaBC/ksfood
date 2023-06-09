import 'package:flutter/material.dart';
import 'package:ksfood/loading/loading_screen.dart';

typedef RequestOTPTapped = void Function(
  String phoneNumber,
);

class RequestOTPButton extends StatelessWidget {
  const RequestOTPButton({
    required this.phoneNumberController,
    required this.onRequestOTPTapped,
    super.key,
  });

  final TextEditingController phoneNumberController;
  final RequestOTPTapped onRequestOTPTapped;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        LoadingScreen.instance().show(context: context, text: "Sending...");
        onRequestOTPTapped(
          phoneNumberController.text,
        );
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF5DB329),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            'Request OTP',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
