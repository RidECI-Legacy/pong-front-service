import 'package:flutter/material.dart';

import '../theme.dart';
import 'glass_card.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const QuickAction({required this.icon, required this.label, required this.onTap, this.accent = LandingColors.primaryLight});
}

/// Animated grid of quick-action cards (search, map, favorites, emergency,
/// contact driver, report incident) — lift + glow on hover.
class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;
  const QuickActionsGrid({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      int columns = 6;
      if (width < 1100) columns = 3;
      if (width < 620) columns = 2;
      final gap = 14.0;
      final cardWidth = (width - (columns - 1) * gap) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final action in actions)
            SizedBox(
              width: cardWidth,
              child: GlassCard(
                radius: 16,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                onTap: action.onTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: action.accent.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                      child: Icon(action.icon, size: 18, color: action.accent),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      action.label,
                      textAlign: TextAlign.center,
                      style: LandingType.cardTitle(size: 11.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}
