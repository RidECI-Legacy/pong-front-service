import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global light/dark switch. AppColors reads this to decide which palette to
/// serve, and main.dart listens to it to rebuild the app when it changes.
class AppThemeController extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void setDark(bool value) {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();
  }
}

final appThemeController = AppThemeController();

class AppColors {
  AppColors._();

  static const Color mint = Color(0xFF2ED9A8);
  static const Color mintDark = Color(0xFF1FAE87);
  static const Color blueAccent = Color(0xFF4F7CFF);
  static const Color blueAccentDark = Color(0xFF3661E0);

  // Navy dark palette used for fixed-contrast UI elements (e.g. text on a
  // mint button) — intentionally NOT theme-aware, these don't flip with
  // light/dark mode.
  static const Color deepGreen = Color(0xFF111A30);
  static const Color deepGreenDarker = Color(0xFF090D1A);
  static const Color panelDark = Color(0xFF141D38);
  static const Color panelDarkAlt = Color(0xFF1B2647);
  static const Color panelDarkBorder = Color(0x1AFFFFFF);

  static const Color amber = Color(0xFFF3A73F);
  static const Color coral = Color(0xFFF06B54);
  static const Color violet = Color(0xFF8C86E0);

  // --- Theme-aware colors ---
  // Darker variants reach WCAG AA (~4.5:1+) as TEXT on the light background;
  // on dark backgrounds we instead brighten them for contrast. Reading
  // `appThemeController.isDark` directly (rather than Theme.of(context)) so
  // any widget can use these as plain values, including inside const-free
  // contexts, without needing a BuildContext.
  static bool get _dark => appThemeController.isDark;

  static Color get bg => _dark ? const Color(0xFF0D1117) : const Color(0xFFF4F5F3);
  static Color get surface => _dark ? const Color(0xFF161B22) : const Color(0xFFFFFFFF);
  static Color get border => _dark ? const Color(0xFF2B3341) : const Color(0xFFE3E7E3);
  static Color get textDark => _dark ? const Color(0xFFECEFF1) : const Color(0xFF10231D);
  static Color get textMuted => _dark ? const Color(0xFF93A0AB) : const Color(0xFF5B6B65);

  static Color get mintDeep => _dark ? const Color(0xFF4CE6BC) : const Color(0xFF0B7A5C);
  static Color get amberDeep => _dark ? const Color(0xFFFFC876) : const Color(0xFF8A5A00);
  static Color get coralDeep => _dark ? const Color(0xFFFF9A82) : const Color(0xFFB33A22);
  static Color get violetDeep => _dark ? const Color(0xFFB8B3F5) : const Color(0xFF5850B0);
}

class AppTheme {
  AppTheme._();

  static ThemeData themeFor(bool isDark) {
    final textTheme = isDark ? GoogleFonts.interTextTheme(ThemeData.dark().textTheme) : GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.mint,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.mint,
        surface: AppColors.surface,
      ),
      textTheme: textTheme.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      dividerColor: AppColors.border,
      splashFactory: NoSplash.splashFactory,
    );
  }

  static ThemeData get light => themeFor(false);
}
