import 'package:flutter/material.dart';

import '../../widgets/responsive_container.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'scroll_reveal.dart';

/// SECTION 3 — How it works: four connected steps revealed on scroll.
class HowItWorksSection extends StatelessWidget {
  final ScrollController scrollController;
  const HowItWorksSection({super.key, required this.scrollController});

  static const _steps = [
    (Icons.search_rounded, 'Busca', 'Encuentra viajes disponibles cerca de ti.'),
    (Icons.event_seat_rounded, 'Reserva', 'Selecciona un conductor y reserva tu cupo.'),
    (Icons.directions_car_rounded, 'Viaja', 'Comparte el recorrido con tranquilidad.'),
    (Icons.star_rounded, 'Califica', 'Ayuda a fortalecer la comunidad compartiendo tu experiencia.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LandingColors.bgDeepest,
      child: ResponsiveContainer(
        maxWidth: 1180,
        child: Column(
          children: [
            Text('Cómo funciona', style: LandingType.eyebrow()),
            const SizedBox(height: 12),
            Text('Cuatro pasos para tu primer viaje', style: LandingType.sectionTitle(), textAlign: TextAlign.center),
            const SizedBox(height: 56),
            LayoutBuilder(builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 860;
              if (isMobile) {
                return Column(
                  children: [
                    for (var i = 0; i < _steps.length; i++)
                      ScrollReveal(
                        controller: scrollController,
                        delay: Duration(milliseconds: 120 * i),
                        child: _StepColumn(
                          index: i,
                          icon: _steps[i].$1,
                          title: _steps[i].$2,
                          description: _steps[i].$3,
                          isLast: i == _steps.length - 1,
                          vertical: true,
                        ),
                      ),
                  ],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < _steps.length; i++)
                      Expanded(
                        child: ScrollReveal(
                          controller: scrollController,
                          delay: Duration(milliseconds: 120 * i),
                          child: _StepColumn(
                            index: i,
                            icon: _steps[i].$1,
                            title: _steps[i].$2,
                            description: _steps[i].$3,
                            isLast: i == _steps.length - 1,
                            vertical: false,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StepColumn extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;
  final bool vertical;

  const _StepColumn({
    required this.index,
    required this.icon,
    required this.title,
    required this.description,
    required this.isLast,
    required this.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Column(
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LandingColors.heroGradient,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: LandingColors.primary.withValues(alpha: 0.4), blurRadius: 22, offset: const Offset(0, 8))],
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ],
    );

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: vertical ? 0 : 12, vertical: vertical ? 12 : 0),
      child: Column(
        crossAxisAlignment: vertical ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text('0${index + 1}', style: LandingType.eyebrow(color: LandingColors.textTertiary)),
          const SizedBox(height: 8),
          Text(title, style: LandingType.cardTitle(size: 19), textAlign: vertical ? TextAlign.left : TextAlign.center),
          const SizedBox(height: 8),
          Text(
            description,
            style: LandingType.body(size: 13.5),
            textAlign: vertical ? TextAlign.left : TextAlign.center,
          ),
        ],
      ),
    );

    if (vertical) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                badge,
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 6), color: LandingColors.glassBorder),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: index == 0 ? const SizedBox() : Container(height: 2, color: LandingColors.glassBorder)),
            badge,
            Expanded(child: isLast ? const SizedBox() : Container(height: 2, color: LandingColors.glassBorder)),
          ],
        ),
        const SizedBox(height: 20),
        content,
      ],
    );
  }
}
