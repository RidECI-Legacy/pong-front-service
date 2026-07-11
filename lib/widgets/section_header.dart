import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Color? eyebrowColor;
  final Color? titleColor;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.eyebrowColor,
    this.titleColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedEyebrowColor = eyebrowColor ?? AppColors.mintDeep;
    final resolvedTitleColor = titleColor ?? AppColors.textDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: resolvedEyebrowColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 19, color: resolvedEyebrowColor),
          ),
          const SizedBox(height: 14),
        ],
        Text(
          eyebrow.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: resolvedEyebrowColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: resolvedTitleColor,
          ),
        ),
      ],
    );
  }
}
