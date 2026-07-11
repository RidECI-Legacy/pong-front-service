import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  final Color? background;
  final Color? labelColor;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
    this.background,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: valueColor ?? AppColors.mintDeep,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12.5, color: labelColor ?? AppColors.textMuted),
        ),
      ],
    );

    if (background == null) return content;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: content,
    );
  }
}
