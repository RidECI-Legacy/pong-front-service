import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme.dart';

/// Consistent page heading used across every passenger section: an icon
/// chip, title, optional subtitle and an optional trailing widget. Reused
/// instead of a bare `Text(title)` so every screen reads as part of the
/// same system (Nielsen: consistency & standards) and animates in on
/// first paint instead of appearing instantly.
class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? accent;
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.accent,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ?? LandingColors.accent;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: LandingType.cardTitle(size: 18)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: LandingType.body(size: 12, color: LandingColors.textTertiary)),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic);
  }
}
