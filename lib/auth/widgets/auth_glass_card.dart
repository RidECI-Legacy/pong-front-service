import 'package:flutter/material.dart';

import '../../landing/theme/effects.dart';
import '../theme/auth_colors.dart';

/// The frosted glass card shell that hosts the stepper + step content on
/// every auth screen. Reuses [LandingEffects]' blur/glass helpers with the
/// same tint recipe as the landing page's login dialog, so the card reads
/// as the same surface across screens.
class AuthGlassCard extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AuthGlassCard({super.key, required this.child, this.maxWidth = 460});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: LandingEffects.glassChild(
        radius: 24,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: LandingEffects.glassDecoration(
            radius: 24,
            tint: AuthColors.surface.withValues(alpha: 0.92),
            borderColor: AuthColors.glassBorder,
          ),
          child: child,
        ),
      ),
    );
  }
}
