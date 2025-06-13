import 'package:flutter/material.dart';
import 'color_theme.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    useMaterial3: true,
  );
}