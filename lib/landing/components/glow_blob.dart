import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A large, blurred, glowing circle that gently drifts and pulses forever.
/// Used to build the floating luminous backgrounds across the landing page.
class GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final Duration duration;
  final double driftX;
  final double driftY;

  const GlowBlob({
    super.key,
    required this.size,
    required this.color,
    this.opacity = 0.35,
    this.duration = const Duration(seconds: 6),
    this.driftX = 18,
    this.driftY = 24,
  });

  @override
  Widget build(BuildContext context) {
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
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveX(begin: -driftX, end: driftX, duration: duration, curve: Curves.easeInOut)
          .moveY(begin: -driftY, end: driftY, duration: duration, curve: Curves.easeInOut)
          .scaleXY(begin: 0.94, end: 1.06, duration: duration, curve: Curves.easeInOut),
    );
  }
}
