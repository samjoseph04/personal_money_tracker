import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const primary = Color(0xFF1F6F5F);
    const secondary = Color(0xFFE8DCC3);
    const background = Color(0xFFF6F5F0);
    const surface = Colors.white;
    const text = Color(0xFF16211D);

    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          secondary: secondary,
          surface: surface,
          error: const Color(0xFFB3261E),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: text,
          letterSpacing: -0.9,
        ),
        headlineSmall: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: text,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.35,
          color: Color(0xFF51605B),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.35,
          color: Color(0xFF51605B),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        hintStyle: const TextStyle(color: Color(0xFF95A19D), fontSize: 18),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: text,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerColor: const Color(0xFFEAE7DE),
    );
  }
}
