import 'package:flutter/material.dart';

class VyroxColors {
  static const Color bg = Color(0xFF090A0F);
  static const Color surface = Color(0xFF11131A);
  static const Color card = Color(0xFF161822);
  static const Color line = Color(0xFF2A2D3A);
  static const Color accent = Color(0xFF9B6CFF);
  static const Color text = Color(0xFFFFFFFF);
  static const Color muted = Color(0xA6FFFFFF);
  static const Color accentSoft = Color(0x409B6CFF);
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
        indicatorColor: VyroxColors.accentSoft,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: VyroxColors.surface,
        indicatorColor: VyroxColors.accentSoft,
        selectedIconTheme: IconThemeData(color: VyroxColors.accent),
      ),
    );
  }
}
