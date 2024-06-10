import 'dart:developer' as developer;
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/core/helpers/phonenumber_formatter.dart';
import 'package:ksfood/features/auth/data/repositories/authentication_repository_impl.dart';
import 'package:ksfood/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ksfood/features/auth/presentation/blocs/signin_bloc/signin_bloc.dart';
import 'package:ksfood/core/presentation/loading/loading_screen.dart';
import 'package:ksfood/core/presentation/screens/main/main_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const routeName = '/phone-auth';

  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final AuthenticationRepositoryImplementation authRepository =
      AuthenticationRepositoryImplementation();
  late final TextEditingController _phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Duration _timeOut = const Duration(seconds: 60);

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        log("${state.status}");
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamed(context, MainScreen.routeName);
          log("${state.status}");
        } else if (state.status == AuthStatus.unauthenticated) {
          log("${state.status}");
          Navigator.pushNamed(context, PhoneAuthScreen.routeName);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          "Enter your phone number",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Subtitle before OTP request
                        Text(
                          "We will send you a One-Time Password (OTP)\nto your phone number.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8.0),

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
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            counter: SizedBox.shrink(),
                            isDense: true,
                            focusColor: Color(0xFF5DB329),
                            floatingLabelStyle:
                                TextStyle(color: Color(0xFF5DB329)),
                            hintText: "0XX-XXX-XXXX",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                              borderSide: BorderSide(
                                  color: Colors.black12,
                                  style: BorderStyle.solid),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                              borderSide: BorderSide(
                                  color: Color(0xFF5DB329),
                                  width: 2.0), // Active border color
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Request OTP Button
                        BlocBuilder<SigninBloc, SigninState>(
                          builder: (_, state) {
                            if (state.status == SigninStateStatus.submitting) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }
                            return FilledButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  LoadingScreen.instance()
                                      .show(context: context);
                                  String phoneNumber =
                                      _phoneController.value.text.trim();
                                  phoneNumber = phoneNumber.replaceAll("-", "");
                                  phoneNumber =
                                      "+66${phoneNumber.substring(1)}";
                                  developer.log(phoneNumber);
                                  context.read<SigninBloc>().add(
                                        VerifyPhoneNumber(
                                          phoneNumber: phoneNumber,
                                          verificationFailed:
                                              (FirebaseAuthException
                                                  exception) {
                                            context.read<SigninBloc>().add(
                                                  VerificationFailed(
                                                    context: context,
                                                    exception: exception,
                                                  ),
                                                );
                                          },
                                          codeSent: (String verificationId,
                                              int? forceResendingToken) {
                                            context.read<SigninBloc>().add(
                                                  CodeSent(
                                                    context: context,
                                                    verificationId:
                                                        verificationId,
                                                    timeout: _timeOut,
                                                    phoneNumberTextEdittingController:
                                                        _phoneController,
                                                  ),
                                                );
                                          },
                                          timeout: _timeOut,
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {
                                            context.read<SigninBloc>().add(
                                                  CodeAutoRetrievalTimeout(
                                                    context: context,
                                                    verificationId:
                                                        verificationId,
                                                  ),
                                                );
                                          },
                                        ),
                                      );
                                }
                              },
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
                              child: SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: BlocBuilder<SigninBloc, SigninState>(
                                      builder: (context, state) {
                                    if (state.status ==
                                        SigninStateStatus.submitting) {
                                      return const CupertinoActivityIndicator();
                                    } else {
                                      return const Text("Request OTP");
                                    }
                                  }),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
