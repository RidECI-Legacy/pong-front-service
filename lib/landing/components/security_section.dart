import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/responsive_container.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/typography.dart';
import 'scroll_reveal.dart';

/// SECTION 4 — Security: large shield illustration + the platform's real
/// safety features.
class SecuritySection extends StatelessWidget {
  final ScrollController scrollController;
  const SecuritySection({super.key, required this.scrollController});

  static const _features = [
    (Icons.verified_user_rounded, 'Comunidad Verificada', 'Todos los conductores y pasajeros validan su identidad con correo institucional.'),
    (Icons.star_rate_rounded, 'Calificaciones', 'Consulta el historial y las reseñas de cada miembro antes de compartir un viaje.'),
    (Icons.sos_rounded, 'Botón de Emergencia', 'Comparte tu ubicación en tiempo real con seguridad institucional en un toque.'),
    (Icons.flag_rounded, 'Reportes', 'Reporta cualquier incidente directamente desde la app para una respuesta rápida.'),
    (Icons.chat_bubble_rounded, 'Chat conductor-pasajero', 'Coordina el punto de encuentro sin salir de la aplicación.'),
    (Icons.alt_route, 'Alertas por desvío de ruta', 'El sistema notifica automáticamente si el trayecto se desvía del plan.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LandingColors.bgDeepest,
      child: ResponsiveContainer(
        maxWidth: 1180,
        child: Column(
          children: [
            Text('Seguridad', style: LandingType.eyebrow(color: LandingColors.success)),
            const SizedBox(height: 12),
            Text('Viaja acompañado, siempre', style: LandingType.sectionTitle(), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            SizedBox(
              width: 560,
              child: Text(
                'Cada función de RidECI está diseñada para que sepas exactamente con quién viajas y '
                'tengas ayuda a un toque de distancia.',
                style: LandingType.body(),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            const _ShieldIllustration(),
            const SizedBox(height: 48),
            LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              int columns = 3;
              if (width < 860) columns = 2;
              if (width < 560) columns = 1;
              final gap = 18.0;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < _features.length; i++)
                    SizedBox(
                      width: (width - (columns - 1) * gap) / columns,
                      child: ScrollReveal(
                        controller: scrollController,
                        delay: Duration(milliseconds: 90 * i),
                        child: _SecurityCard(icon: _features[i].$1, title: _features[i].$2, description: _features[i].$3),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ShieldIllustration extends StatelessWidget {
  const _ShieldIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LandingColors.success.withValues(alpha: 0.18), width: 1.5),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 0.94, end: 1.0, duration: 2600.ms),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LandingColors.success.withValues(alpha: 0.28), width: 1.5),
            ),
          ),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [LandingColors.success.withValues(alpha: 0.35), Colors.transparent]),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [LandingColors.success, LandingColors.primaryMid]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: LandingColors.success.withValues(alpha: 0.45), blurRadius: 36, offset: const Offset(0, 12))],
            ),
            child: const Icon(Icons.shield_rounded, size: 52, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  const _SecurityCard({required this.icon, required this.title, required this.description});

  @override
  State<_SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends State<_SecurityCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        child: LandingEffects.glassChild(
          radius: 18,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: LandingEffects.glassDecoration(
              radius: 18,
              borderColor: _hover ? LandingColors.success.withValues(alpha: 0.45) : LandingColors.glassBorder,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: LandingColors.success.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                  child: Icon(widget.icon, size: 20, color: LandingColors.success),
                ),
                const SizedBox(height: 16),
                Text(widget.title, style: LandingType.cardTitle(size: 15.5)),
                const SizedBox(height: 8),
                Text(widget.description, style: LandingType.body(size: 12.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
