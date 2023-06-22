import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ksfood/app_bloc/app_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/repositories/auth_repository.dart';
import 'package:ksfood/screens/auth/otp_screean.dart';
import 'package:ksfood/screens/auth/phone_auth_screen.dart';
import 'package:ksfood/screens/cart/cart_screen.dart';
import 'package:ksfood/screens/main/main_screen.dart';
import 'package:ksfood/screens/merchant/merchant_screen.dart';
import 'package:ksfood/screens/product/product_screen.dart';
import 'package:ksfood/screens/promptpay/promptpay_screen.dart';
import 'auth/auth_bloc/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure initialization is complete before running app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Using FlutterDownloader for Promptpay QR download
  await FlutterDownloader.initialize(
    debug: true,
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
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) => PaymentBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'KS Food',
          theme: ThemeData(
            fontFamily: "Noto Sans Thai",
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
            MerchantScreen.routeName: (BuildContext context) =>
                const MerchantScreen(),
            ProductScreen.routeName: (context) => const ProductScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            PromptPayScreen.routeName: (context) => const PromptPayScreen()
          },
        ),
      ),
    );
  }
}
