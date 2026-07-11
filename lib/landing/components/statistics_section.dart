import 'package:flutter/material.dart';

import '../../widgets/responsive_container.dart';
import '../theme/colors.dart';
import 'animated_counter.dart';

/// SECTION 5 — Statistics: animated counters revealed on scroll.
class StatisticsSection extends StatelessWidget {
  final ScrollController scrollController;
  const StatisticsSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LandingColors.bgMid,
      child: ResponsiveContainer(
        maxWidth: 1180,
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          int columns = 4;
          if (width < 760) columns = 2;
          final gap = 20.0;
          final stats = [
            AnimatedCounter(controller: scrollController, targetValue: 100, suffix: '%', label: 'Usuarios Verificados'),
            AnimatedCounter(controller: scrollController, staticValue: '24/7', label: 'Soporte', delay: const Duration(milliseconds: 100)),
            AnimatedCounter(controller: scrollController, targetValue: 500, prefix: '+', label: 'Viajes Compartidos', delay: const Duration(milliseconds: 200)),
            AnimatedCounter(controller: scrollController, staticValue: 'CO₂ ↓', label: 'Movilidad Sostenible', delay: const Duration(milliseconds: 300)),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final s in stats) SizedBox(width: (width - (columns - 1) * gap) / columns, child: s),
            ],
          );
        }),
      ),
    );
  }
}
