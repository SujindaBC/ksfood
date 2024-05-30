import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ksfood/blocs/auth/auth_bloc/auth_bloc.dart';
import 'package:ksfood/blocs/auth/signin_cubit/signin_cubit.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/blocs/location_bloc/location_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/firebase_options.dart';
import 'package:ksfood/repositories/auth_repository.dart';
import 'package:ksfood/screens/auth/auth_gate.dart';
import 'package:ksfood/screens/auth/otp_screen.dart';
import 'package:ksfood/screens/auth/phone_auth_screen.dart';
import 'package:ksfood/screens/cart/cart_screen.dart';
import 'package:ksfood/screens/checkout/checkout_screen.dart';
import 'package:ksfood/screens/main/main_screen.dart';
import 'package:ksfood/screens/merchant/merchant_screen.dart';
import 'package:ksfood/screens/product/product_screen.dart';
import 'package:ksfood/screens/promptpay/promptpay_screen.dart';

void main() async {
  // Ensure initialization is complete before running app.
  // For more details https://docs.flutter.dev/resources/architectural-overview#architectural-layers
  WidgetsFlutterBinding.ensureInitialized();

  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  await dotenv.load(fileName: ".env");

  // Firebase.initializeApp() needs to call native code to initialize Firebase,
  // and since the plugin needs to use platform channels to call the native code,
  // which is done asynchronously therefore you have to call ensureInitialized()
  // to make sure that you have an instance of the WidgetsBinding.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request user device location permission.
  LocationPermission locationPermission = await Geolocator.requestPermission();

  switch (locationPermission) {
    case LocationPermission.denied:
      await Geolocator.requestPermission();
      break;
    case LocationPermission.deniedForever:
      await Geolocator.requestPermission();
      break;
    case LocationPermission.whileInUse:
      runApp(const MyApp());
      break;
    case LocationPermission.unableToDetermine:
      await Geolocator.requestPermission();
      break;
    case LocationPermission.always:
      runApp(const MyApp());
      break;
  }
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
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) => PaymentBloc(),
          ),
          BlocProvider<LocationBloc>(
            create: (context) => LocationBloc()..add(GetCurrentLocation()),
          ),
        ],
        child: MaterialApp(
          title: 'KS Food',
          theme: ThemeData(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white.withAlpha(175),
              elevation: 0,
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white.withAlpha(175),
              surfaceTintColor: Colors.transparent,
            ),
            appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent,
            ),
            fontFamily: "Noto Sans Thai",
            primaryColor: const Color(
              0xFF5DB329,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Theme.of(context).primaryColor,
            ),
            useMaterial3: true,
          ),
          initialRoute: AuthGateScreen.routeName,
          routes: {
            AuthGateScreen.routeName: (context) => const AuthGateScreen(),
            PhoneAuthScreen.routeName: (BuildContext context) =>
                const PhoneAuthScreen(),
            OTPScreen.routeName: (BuildContext context) => const OTPScreen(),
            MainScreen.routeName: (BuildContext context) => const MainScreen(),
            MerchantScreen.routeName: (BuildContext context) =>
                const MerchantScreen(),
            ProductScreen.routeName: (context) => const ProductScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            CheckoutScreen.routeName: (context) => const CheckoutScreen(),
            PromptPayScreen.routeName: (context) => const PromptPayScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
