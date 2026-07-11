import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Centralized text styles for the landing page.
/// Primary display font: Space Grotesk. Body/UI font: Inter.
class LandingType {
  LandingType._();

  static TextStyle _display({
    required double size,
    required FontWeight weight,
    double? height,
    double? letterSpacing,
    Color color = LandingColors.textPrimary,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle _body({
    required double size,
    required FontWeight weight,
    double? height,
    double? letterSpacing,
    Color color = LandingColors.textSecondary,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  /// Hero headline, huge and bold.
  static TextStyle heroHeadline({double size = 56}) =>
      _display(size: size, weight: FontWeight.w700, height: 1.08, letterSpacing: -1.2);

  /// Section titles (H2).
  static TextStyle sectionTitle({double size = 38}) =>
      _display(size: size, weight: FontWeight.w700, height: 1.15, letterSpacing: -0.6);

  /// Card / small section titles (H3).
  static TextStyle cardTitle({double size = 20, Color color = LandingColors.textPrimary}) =>
      _display(size: size, weight: FontWeight.w600, height: 1.3, color: color);

  /// Small uppercase eyebrow / kicker label.
  static TextStyle eyebrow({Color color = LandingColors.accent}) => _body(
        size: 12.5,
        weight: FontWeight.w700,
        letterSpacing: 2.2,
        color: color,
      );

  /// Regular paragraph copy.
  static TextStyle body({double size = 15.5, Color color = LandingColors.textSecondary}) =>
      _body(size: size, weight: FontWeight.w400, height: 1.65, color: color);

  /// Button label.
  static TextStyle button({Color color = Colors.white}) =>
      _body(size: 15, weight: FontWeight.w600, color: color, letterSpacing: 0.1);

  /// Big animated counter numbers.
  static TextStyle statValue({double size = 46}) =>
      _display(size: size, weight: FontWeight.w700, color: LandingColors.textPrimary);

  static TextStyle statLabel() => _body(
        size: 13.5,
        weight: FontWeight.w500,
        color: LandingColors.textTertiary,
        letterSpacing: 0.2,
      );

  static TextStyle navLink() => _body(size: 14, weight: FontWeight.w500, color: LandingColors.textSecondary);
}
