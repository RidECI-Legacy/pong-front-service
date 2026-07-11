import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_router.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/typography.dart';
import 'glow_blob.dart';
import 'phone_mockup.dart';

/// The hero itself — background, particles, headline/CTAs and the floating
/// phone mockup. The navbar is rendered separately as a page-level overlay
/// (see landing_page.dart) so it stays pinned while the whole page scrolls;
/// this section just reserves top padding so its copy clears the navbar.
class HeroSection extends StatelessWidget {
  final VoidCallback onSeeHowItWorks;

  const HeroSection({
    super.key,
    required this.onSeeHowItWorks,
  });

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    return ClipRect(
      child: ConstrainedBox(
        // Grows past 100% viewport height on small screens instead of
        // clipping/overflowing when content (copy + phone mockup) is
        // taller than the device, while still filling the full screen on
        // desktop where content comfortably fits.
        constraints: BoxConstraints(minHeight: viewportHeight),
        child: Stack(
          children: [
            const Positioned.fill(child: _HeroBackground()),
            Positioned.fill(child: _ParticleField()),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 108, 24, 56),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: LayoutBuilder(builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 960;
                        if (isMobile) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 24),
                              _HeroCopy(onSeeHowItWorks: onSeeHowItWorks),
                              const SizedBox(height: 40),
                              const PhoneMockup(width: 220),
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 6, child: _HeroCopy(onSeeHowItWorks: onSeeHowItWorks)),
                            const SizedBox(width: 24),
                            const Expanded(flex: 5, child: Center(child: PhoneMockup())),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Deep-navy gradient backdrop with slowly drifting glow blobs.
class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LandingColors.pageGradient),
      child: Stack(
        children: [
          Positioned(top: -80, left: -60, child: GlowBlob(size: 420, color: LandingColors.primary, opacity: 0.32)),
          Positioned(top: 120, right: -100, child: GlowBlob(size: 380, color: LandingColors.accent, opacity: 0.26, duration: const Duration(seconds: 7))),
          Positioned(bottom: -120, left: 60, child: GlowBlob(size: 320, color: LandingColors.success, opacity: 0.18, duration: const Duration(seconds: 8))),
        ],
      ),
    );
  }
}

/// A handful of softly pulsing dots — the "particles" ambience layer.
class _ParticleField extends StatefulWidget {
  const _ParticleField();

  @override
  State<_ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<_ParticleField> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _points = [
    Offset(0.08, 0.18), Offset(0.22, 0.65), Offset(0.35, 0.32), Offset(0.5, 0.82),
    Offset(0.62, 0.15), Offset(0.74, 0.55), Offset(0.88, 0.28), Offset(0.93, 0.72),
    Offset(0.15, 0.9), Offset(0.45, 0.12), Offset(0.68, 0.88), Offset(0.9, 0.1),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(painter: _ParticlePainter(_controller.value), size: Size.infinite);
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double phase;
  const _ParticlePainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _ParticleFieldState._points.length; i++) {
      final base = _ParticleFieldState._points[i];
      final pos = Offset(base.dx * size.width, base.dy * size.height);
      final twinkle = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(phase * 2 * math.pi + i * 1.7));
      canvas.drawCircle(pos, 1.6 + (i % 3), Paint()..color = Colors.white.withValues(alpha: twinkle * 0.5));
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => oldDelegate.phase != phase;
}

class _HeroCopy extends StatelessWidget {
  final VoidCallback onSeeHowItWorks;
  const _HeroCopy({required this.onSeeHowItWorks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: LandingColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: LandingColors.accent.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: LandingColors.accent, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('Exclusivo para la Escuela Colombiana de Ingeniería', style: LandingType.eyebrow()),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text('Comparte el camino.', style: LandingType.heroHeadline(size: 50)),
        LandingEffects.gradientText('Conecta con tu comunidad.', style: LandingType.heroHeadline(size: 50)),
        const SizedBox(height: 22),
        SizedBox(
          width: 520,
          child: Text(
            'RidECI conecta estudiantes, profesores y colaboradores de la Escuela Colombiana '
            'de Ingeniería para compartir viajes seguros dentro de una comunidad verificada.',
            style: LandingType.body(),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _PrimaryButton(label: 'Comenzar', onTap: () => context.push(AppRoutes.register)),
            _SecondaryButton(label: 'Ver cómo funciona', onTap: onSeeHowItWorks),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic);
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LandingColors.buttonGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: LandingColors.primary.withValues(alpha: _hover ? 0.55 : 0.35), blurRadius: 26, offset: const Offset(0, 10)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                child: Text(widget.label, style: LandingType.button()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _hover ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: LandingColors.glassBorder),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.label, style: LandingType.button(color: LandingColors.textPrimary)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: LandingColors.textPrimary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
