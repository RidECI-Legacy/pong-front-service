import 'package:flutter/material.dart';

import '../../landing/theme/colors.dart';

/// Palette for the authentication flow (registration + password recovery).
///
/// Deliberately aliased 1:1 to [LandingColors] — the blue/cyan "startup"
/// palette used by the landing page and its login dialog — so these screens
/// read as the same product rather than switching to the mint-green
/// dashboard palette from `DesignSystem.md`. Fixed dark palette — these
/// screens don't follow the app-wide light/dark toggle.
class AuthColors {
  AuthColors._();

  static const Color bgDeepest = LandingColors.bgDeepest;
  static const Color bgMid = LandingColors.bgMid;
  static const Color surface = LandingColors.bgSurface;
  static const Color elevated = Color(0xFF16223A);
  static const Color modal = LandingColors.card;
  static const Color border = Color(0xFF1E2A41);

  static const Color primary = LandingColors.primary;
  static const Color primaryHover = LandingColors.primaryMid;
  static const Color primaryPressed = Color(0xFF1D4ED8);
  static const Color secondaryAccent = LandingColors.accent;

  static const Color success = LandingColors.success;
  static const Color warning = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFF87171);
  static const Color info = LandingColors.primaryLight;

  static const Color textPrimary = LandingColors.textPrimary;
  static const Color textSecondary = LandingColors.textSecondary;
  static const Color textMuted = LandingColors.textTertiary;
  static const Color textDisabled = Colors.white30;

  static const Color glassFill = LandingColors.glassFill;
  static const Color glassBorder = LandingColors.glassBorder;

  /// Full-bleed background — identical to the landing page's, so scrolling
  /// from the landing hero into `/registro` never feels like a new app.
  static const LinearGradient pageGradient = LandingColors.pageGradient;

  /// Same blue → cyan gradient the landing hero headline uses.
  static const LinearGradient heroGradient = LandingColors.heroGradient;

  /// Same gradient as the navbar/login-dialog primary button.
  static const LinearGradient buttonGradient = LandingColors.buttonGradient;
}
