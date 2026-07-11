import 'package:flutter/material.dart';

import '../theme.dart';
import 'buttons.dart';

/// A friendly empty state: icon illustration, title, description and an
/// optional primary action — used whenever a list/table has no data.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [LandingColors.primary.withValues(alpha: 0.18), Colors.transparent]),
              border: Border.all(color: LandingColors.glassBorder),
            ),
            child: Icon(icon, size: 30, color: LandingColors.primaryLight),
          ),
          const SizedBox(height: 18),
          Text(title, style: LandingType.cardTitle(size: 16), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(description, style: LandingType.body(size: 12.5), textAlign: TextAlign.center),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            PrimaryButton(label: actionLabel!, onTap: onAction),
          ],
        ],
      ),
    );
  }
}
