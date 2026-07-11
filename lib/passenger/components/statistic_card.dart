import 'package:flutter/material.dart';

import '../theme.dart';
import 'glass_card.dart';

class StatEntry {
  final IconData icon;
  final int value;
  final String suffix;
  final String label;
  final Color color;

  const StatEntry({required this.icon, required this.value, this.suffix = '', required this.label, this.color = LandingColors.success});
}

/// A generic glass card with a title/icon header and a row of animated
/// count-up stats — used for the Sustainability section (CO2 saved, money
/// saved, trips shared) and anywhere else a quick stat grid is needed.
class StatisticCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<StatEntry> stats;

  const StatisticCard({super.key, required this.title, required this.icon, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: LandingColors.success.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 20, color: LandingColors.success),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: LandingType.cardTitle(size: 16))),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth < 420 ? 2 : stats.length;
            final gap = 16.0;
            final width = (constraints.maxWidth - (columns - 1) * gap) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [for (final s in stats) SizedBox(width: width, child: _StatTile(entry: s))],
            );
          }),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final StatEntry entry;
  const _StatTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(entry.icon, size: 16, color: entry.color),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: entry.value.toDouble()),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Text('${value.round()}${entry.suffix}', style: LandingType.cardTitle(size: 22)),
        ),
        const SizedBox(height: 4),
        Text(entry.label, style: LandingType.body(size: 11, color: LandingColors.textTertiary)),
      ],
    );
  }
}
