import 'package:flutter/material.dart';

/// Premium dark palette used exclusively by the new RidECI marketing
/// landing page. Unlike `AppColors` (used by the operational app screens),
/// this palette is intentionally fixed/dark — the landing page always
/// renders in the same "startup" aesthetic regardless of the app-wide
/// light/dark toggle.
class LandingColors {
  LandingColors._();

  // Background layers (deepest to lightest), used to build subtle depth
  // between stacked sections.
  static const Color bgDeepest = Color(0xFF050816);
  static const Color bgMid = Color(0xFF081321);
  static const Color bgSurface = Color(0xFF0D1B2A);

  // Primary (blue) ramp.
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryMid = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);

  // Accent (cyan) and success (green).
  static const Color accent = Color(0xFF22D3EE);
  static const Color success = Color(0xFF10B981);

  // Text.
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white54;

  // Cards / glass surfaces.
  static const Color card = Color(0xFF101827);
  static const Color cardBorder = Color(0x1FFFFFFF);
  static const Color glassFill = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);

  /// Full-bleed background gradient shared by the page shell.
  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgDeepest, bgMid, bgDeepest],
    stops: [0.0, 0.5, 1.0],
  );

  /// Signature blue → cyan gradient used on CTAs, headline accents and glows.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryMid, accent],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, primaryMid],
  );
}
