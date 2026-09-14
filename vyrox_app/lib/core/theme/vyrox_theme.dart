import 'package:flutter/material.dart';

class VyroxColors {
  VyroxColors._();

  static const Color background = Color(0xFF07080C);
  static const Color surface = Color(0xFF0F1117);
  static const Color surfaceRaised = Color(0xFF161925);
  static const Color border = Color(0xFF232838);

  static const Color accent = Color(0xFF9B6CFF);
  static const Color accentDeep = Color(0xFF6A3FE0);
  static const Color accentSoft = Color(0x339B6CFF);
  static const Color gold = Color(0xFFF5C451);
  static const Color goldSoft = Color(0x33F5C451);

  static const Color textPrimary = Color(0xFFF2F3F7);
  static const Color textSecondary = Color(0xFF9AA0B4);
  static const Color textMuted = Color(0xFF5F6578);

  static const Color success = Color(0xFF4ADE80);
  static const Color danger = Color(0xFFF87171);
}

class VyroxSpace {
  VyroxSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class VyroxRadius {
  VyroxRadius._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
}

class VyroxBreakpoints {
  VyroxBreakpoints._();

  static const double tablet = 700;
  static const double desktop = 1100;
}

class VyroxType {
  const VyroxType._(this.scale);

  final double scale;

  factory VyroxType.of(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double scale = (width / 390).clamp(0.92, 1.22).toDouble();
    return VyroxType._(scale);
  }

  TextStyle get display => TextStyle(
        fontSize: 30 * scale,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
        color: VyroxColors.textPrimary,
      );

  TextStyle get title => TextStyle(
        fontSize: 24 * scale,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: VyroxColors.textPrimary,
      );

  TextStyle get heading => TextStyle(
        fontSize: 17 * scale,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: VyroxColors.textPrimary,
      );

  TextStyle get body => TextStyle(
        fontSize: 15 * scale,
        height: 1.45,
        color: VyroxColors.textPrimary,
      );

  TextStyle get bodyMuted => TextStyle(
        fontSize: 14 * scale,
        height: 1.4,
        color: VyroxColors.textSecondary,
      );

  TextStyle get label => TextStyle(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: VyroxColors.textMuted,
      );

  TextStyle get caption => TextStyle(
        fontSize: 12 * scale,
        color: VyroxColors.textSecondary,
      );
}

class VyroxTheme {
  VyroxTheme._();

  static ThemeData dark() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: VyroxColors.accent,
      brightness: Brightness.dark,
    ).copyWith(primary: VyroxColors.accent, surface: VyroxColors.surface);

    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(VyroxRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: VyroxColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: VyroxColors.background,
        foregroundColor: VyroxColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(
        color: VyroxColors.border,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: VyroxColors.surface,
        indicatorColor: VyroxColors.accentSoft,
        height: 68,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: VyroxColors.surface,
        indicatorColor: VyroxColors.accentSoft,
        selectedIconTheme: IconThemeData(color: VyroxColors.accent),
        unselectedIconTheme: IconThemeData(color: VyroxColors.textSecondary),
        selectedLabelTextStyle: TextStyle(
          color: VyroxColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(color: VyroxColors.textSecondary),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: VyroxColors.surface),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: VyroxColors.surfaceRaised,
        contentTextStyle: TextStyle(color: VyroxColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VyroxColors.surface,
        hintStyle: const TextStyle(color: VyroxColors.textMuted),
        border: border(VyroxColors.border),
        enabledBorder: border(VyroxColors.border),
        focusedBorder: border(VyroxColors.accent, 1.5),
      ),
    );
  }
}

void showVyroxToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
