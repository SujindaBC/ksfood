import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/auth/auth_bloc/auth_bloc.dart';
import 'package:ksfood/blocs/auth/signin_cubit/signin_cubit.dart';
import 'package:ksfood/loading/loading_screen.dart';
import 'package:ksfood/screens/main/main_screen.dart';

class OTPScreen extends StatefulWidget {
  static const routeName = '/otp';
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late final TextEditingController _otpController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String verificationId = arguments['verificationId'] as String;
    final Duration duration = arguments['duration'] as Duration;

    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state.status == SigninStatus.success) {
          log("${state.status}");
        }
      },
      builder: (context, state) {
        LoadingScreen.instance().hide();
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState.status == AuthStatus.authenticated) {
              Navigator.pushNamed(context, MainScreen.routeName);
            }
          },
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async => false,
              child: SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      leading: BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: const Text('OTP Verification'),
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Title
                              const Text(
                                'Enter OTP',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              // Subtitle
                              const Text(
                                "We have sent a One-Time Password (OTP) to your registered phone number.",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // OTP
                              TextFormField(
                                controller: _otpController,
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty
                                    ? 'Please enter the OTP sent to your phone number'
                                    : null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.black12,
                                        style: BorderStyle.solid),
                                  ),
                                  counter: SizedBox.shrink(),
                                  isDense: true,
                                  labelText: "OTP",
                                  hintText: "XXXXXX",
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // Submit Button
                              FilledButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF5DB329),
                                  ),
                                ),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  LoadingScreen.instance()
                                      .show(context: context);
                                  final PhoneAuthCredential
                                      phoneAuthCredential =
                                      PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: _otpController.value.text.trim(),
                                  );
                                  final UserCredential credential =
                                      await FirebaseAuth.instance
                                          .signInWithCredential(
                                    phoneAuthCredential,
                                  );
                                  log("User credential: ${credential.user?.uid}");
                                },
                                child: const SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text('Submit'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              // Countdown Timer
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Didn\'t receive OTP? ',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  CountdownTimer(
                                    durationInSeconds: duration.inSeconds - 1,
                                  ),
                                ],
                              ),

                              // Resend OTP Button
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: Color(0xFF5DB329),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            );
          },
        );
      },
    );
  }
}

class HomeScreen {}

class CountdownTimer extends StatefulWidget {
  final int durationInSeconds;

  const CountdownTimer({super.key, required this.durationInSeconds});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _remainingSeconds = widget.durationInSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(_remainingSeconds),
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
