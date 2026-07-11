import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

/// Shared visual helpers: glassmorphism, glows and gradient text, so every
/// section builds the same premium surface language.
class LandingEffects {
  LandingEffects._();

  /// Frosted glass card decoration (blur is applied separately via
  /// [glassChild] because [BoxDecoration] alone can't blur its background).
  static BoxDecoration glassDecoration({
    double radius = 24,
    Color? tint,
    Color? borderColor,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: tint ?? LandingColors.glassFill,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? LandingColors.glassBorder),
      boxShadow: shadows ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
    );
  }

  /// Wraps [child] with a backdrop blur clipped to [radius], producing the
  /// frosted-glass look. Use together with [glassDecoration] on the child.
  static Widget glassChild({
    required Widget child,
    double radius = 24,
    double blur = 18,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    );
  }

  /// A soft radial glow blob — the floating luminous shapes used across the
  /// hero, CTA and background of most sections.
  static Widget glow({
    required double size,
    required Color color,
    double opacity = 0.35,
  }) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }

  static Widget gradientText(String text, {required TextStyle style, Gradient? gradient}) {
    return ShaderMask(
      shaderCallback: (rect) => (gradient ?? LandingColors.heroGradient).createShader(rect),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
