import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A "highlighted" light card (mint-tinted border + glow) used to mark the
/// featured/live content on a screen (active trip, stats, impact) — visually
/// distinct from a plain [LiftedCard] while staying on the light palette.
class DepthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final List<Color>? gradientColors;

  const DepthCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ?? [AppColors.surface, AppColors.surface],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: AppColors.mint.withValues(alpha: 0.35), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: AppColors.mint.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Light surface card with a soft shadow (used for lists/forms on the light
/// content area next to the dark hero cards).
class LiftedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const LiftedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
