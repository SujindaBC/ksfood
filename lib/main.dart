import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/app_bloc/app_bloc.dart';
import 'package:ksfood/repositories/auth_repository.dart';
import 'package:ksfood/screens/auth/otp_screean.dart';
import 'package:ksfood/screens/auth/phone_auth_screen.dart';
import 'package:ksfood/screens/main/main_screen.dart';
import 'auth/auth_bloc/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure initialization is complete before running app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (BuildContext context) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (BuildContext context) => AppBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'KS Food',
          theme: ThemeData(
            primaryColor: const Color(
              0xFF5DB329,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Theme.of(context).primaryColor,
            ),
            useMaterial3: true,
          ),
          initialRoute: MainScreen.routeName,
          routes: {
            PhoneAuthScreen.routeName: (BuildContext context) =>
                const PhoneAuthScreen(),
            OTPScreen.routeName: (BuildContext context) => const OTPScreen(),
            MainScreen.routeName: (BuildContext context) => const MainScreen(),
          },
        ),
      ),
    );
  }
}
