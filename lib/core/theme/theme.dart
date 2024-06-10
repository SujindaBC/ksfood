import 'package:flutter/material.dart';
import 'package:ksfood/core/theme/app_pallete.dart';

class AppTheme {
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
  );
  static final darkThemeMode = ThemeData.dark();
}
