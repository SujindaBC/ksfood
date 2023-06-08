import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/app_bloc/app_bloc.dart';
import 'package:ksfood/auth/auth_error.dart';
import 'package:ksfood/helpers/format_phonenumber.dart';
import 'package:ksfood/loading/loading_screen.dart';
import 'package:ksfood/screens/auth/otp_screean.dart';
import 'package:ksfood/widgets/request_otp_button.dart';

import '../../helpers/phonenumber_formatter.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const routeName = '/phone_auth';

  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  late final TextEditingController _phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Duration _timeOut = const Duration(seconds: 120);

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  verificationCompleted(AuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      developer.log("message");
      debugPrint(e.toString());
    }
  }

  verificationFailed(BuildContext context, FirebaseAuthException exception) {
    final error = AuthError.from(exception);
    LoadingScreen.instance().hide();
    developer
        .log("logging from line 46, on phone auth screen ${exception.code}");
    debugPrint(exception.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error.dialogTitle),
          content: Text(error.dialogContent),
        );
      },
    );
  }

  codeSent(String verificationId, int? forceResendingToken) {
    Navigator.pushNamed(
      context,
      OTPScreen.routeName,
      arguments: {
        'verificationId': verificationId,
        'duration': _timeOut,
      },
    );
  }

  codeAutoRetrievalTimeout(String codeAutoRetrievalTimeout) {
    debugPrint(codeAutoRetrievalTimeout);
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Time out"),
          content: Text("Time out"),
        );
      },
    );
  }

  bool isButtonEnable = false;

  void toggleButtonAvailability() {
    setState(() {
      isButtonEnable != isButtonEnable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        LoadingScreen.instance().hide();
        switch (state.appStatus) {
          case AppStatus.completed || AppStatus.initial:
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text('Phone Authentication'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Title
                          const Text(
                            'Enter your phone number',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Subtitle before OTP request
                          const Text(
                            "We will send you a One-Time Password (OTP) to your phone number.",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Phone Number
                          TextFormField(
                            maxLength: 12,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            keyboardAppearance: Brightness.dark,
                            inputFormatters: [
                              PhoneNumberFormatter(),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              counter: SizedBox.shrink(),
                              isDense: true,
                              labelText: "Phone Number",
                              hintText: "0XX-XXX-XXXX",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                borderSide: BorderSide(
                                    color: Colors.black12,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Request OTP Button
                          RequestOTPButton(
                            phoneNumberController: _phoneController,
                            onRequestOTPTapped: (String phoneNumber) {
                              if (_formKey.currentState!.validate()) {
                                FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: formatPhoneNumber(
                                      _phoneController.text.trim()),
                                  verificationCompleted: verificationCompleted,
                                  verificationFailed:
                                      (FirebaseAuthException exception) {
                                    verificationFailed(context, exception);
                                  },
                                  codeSent: codeSent,
                                  timeout: _timeOut,
                                  codeAutoRetrievalTimeout:
                                      codeAutoRetrievalTimeout,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
