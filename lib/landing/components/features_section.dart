import 'package:flutter/material.dart';

import '../../widgets/responsive_container.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/typography.dart';
import 'scroll_reveal.dart';

/// SECTION 2 — Why RidECI: three animated glass cards.
class FeaturesSection extends StatelessWidget {
  final ScrollController scrollController;
  const FeaturesSection({super.key, required this.scrollController});

  static const _features = [
    (
      Icons.shield_rounded,
      'Comunidad Verificada',
      'Solo miembros de la Escuela Colombiana de Ingeniería pueden acceder a la plataforma.',
      LandingColors.primaryMid,
    ),
    (
      Icons.map_rounded,
      'Viajes Seguros',
      'Consulta perfiles, calificaciones y comparte trayectos con confianza.',
      LandingColors.accent,
    ),
    (
      Icons.eco_rounded,
      'Movilidad Inteligente',
      'Reduce costos, disminuye el tráfico y contribuye a una movilidad más sostenible.',
      LandingColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LandingColors.bgMid,
      child: ResponsiveContainer(
        maxWidth: 1180,
        child: Column(
          children: [
            Text('¿Por qué RidECI?', style: LandingType.eyebrow()),
            const SizedBox(height: 12),
            Text('Movilidad diseñada para tu comunidad', style: LandingType.sectionTitle(), textAlign: TextAlign.center),
            const SizedBox(height: 48),
            LayoutBuilder(builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 860;
              final cards = [
                for (var i = 0; i < _features.length; i++)
                  ScrollReveal(
                    controller: scrollController,
                    delay: Duration(milliseconds: 120 * i),
                    child: _FeatureCard(
                      icon: _features[i].$1,
                      title: _features[i].$2,
                      description: _features[i].$3,
                      accent: _features[i].$4,
                    ),
                  ),
              ];
              if (isMobile) {
                return Column(children: [for (final c in cards) Padding(padding: const EdgeInsets.only(bottom: 20), child: c)]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (final c in cards) Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: c))],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color accent;

  const _FeatureCard({required this.icon, required this.title, required this.description, required this.accent});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
        child: LandingEffects.glassChild(
          radius: 22,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: LandingEffects.glassDecoration(
              radius: 22,
              borderColor: _hover ? widget.accent.withValues(alpha: 0.5) : LandingColors.glassBorder,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: widget.accent.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(16)),
                  child: Icon(widget.icon, size: 26, color: widget.accent),
                ),
                const SizedBox(height: 22),
                Text(widget.title, style: LandingType.cardTitle()),
                const SizedBox(height: 12),
                Text(widget.description, style: LandingType.body(size: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
