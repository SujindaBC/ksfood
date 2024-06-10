import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/core/presentation/loading/loading_screen.dart';
import 'package:ksfood/core/presentation/screens/main/main_screen.dart';
import 'package:ksfood/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ksfood/features/auth/presentation/blocs/signin_bloc/signin_bloc.dart';

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

    return BlocConsumer<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state.status == SigninStateStatus.success) {
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
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    LoadingScreen.instance()
                                        .show(context: context);
                                    final PhoneAuthCredential
                                        phoneAuthCredential =
                                        PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _otpController.value.text.trim(),
                                    );
                                    try {
                                      final UserCredential credential =
                                          await FirebaseAuth.instance
                                              .signInWithCredential(
                                        phoneAuthCredential,
                                      );
                                      log("User credential: ${credential.user?.uid}");
                                    } on FirebaseAuthException catch (error) {
                                      log(error.toString());
                                    }
                                  }
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
                                    "Time remaining: ",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  CountdownTimer(
                                    durationInSeconds: duration.inSeconds - 1,
                                  ),
                                ],
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
