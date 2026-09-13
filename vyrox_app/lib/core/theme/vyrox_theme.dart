import 'package:flutter/material.dart';

class VyroxColors {
  static const bg = Color(0xFF090A0F);
  static const surface = Color(0xFF11131A);
  static const card = Color(0xFF161822);
  static const line = Color(0xFF2A2D3A);
  static const accent = Color(0xFF9B6CFF);
  static const text = Color(0xFFFFFFFF);
  static const muted = Color(0xA6FFFFFF);
}

class VyroxTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: VyroxColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: VyroxColors.accent,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: VyroxColors.bg,
        foregroundColor: VyroxColors.text,
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: VyroxColors.surface,
        indicatorColor: Color(0x409B6CFF),
      ),
    );
  }
}
