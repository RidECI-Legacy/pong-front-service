import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_router.dart';
import '../../widgets/responsive_container.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'glow_blob.dart';

/// SECTION 6 — Call to action.
class CtaSection extends StatelessWidget {
  final VoidCallback onLearnMore;
  const CtaSection({super.key, required this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [LandingColors.bgDeepest, LandingColors.bgSurface],
                ),
              ),
            ),
          ),
          Positioned(top: -60, left: -40, child: GlowBlob(size: 340, color: LandingColors.primary, opacity: 0.4)),
          Positioned(bottom: -60, right: -40, child: GlowBlob(size: 340, color: LandingColors.accent, opacity: 0.35, duration: const Duration(seconds: 7))),
          ResponsiveContainer(
            maxWidth: 900,
            child: Column(
              children: [
                Text('Únete al cambio', style: LandingType.eyebrow()),
                const SizedBox(height: 16),
                Text(
                  'Únete a la nueva forma de movilizarte dentro de la\nEscuela Colombiana de Ingeniería.',
                  style: LandingType.sectionTitle(size: 34),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _CtaPrimaryButton(label: 'Comenzar ahora', onTap: () => context.push(AppRoutes.register)),
                    _CtaSecondaryButton(label: 'Conocer más', onTap: onLearnMore),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _CtaPrimaryButton({required this.label, required this.onTap});

  @override
  State<_CtaPrimaryButton> createState() => _CtaPrimaryButtonState();
}

class _CtaPrimaryButtonState extends State<_CtaPrimaryButton> {
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
            boxShadow: [BoxShadow(color: LandingColors.primary.withValues(alpha: _hover ? 0.55 : 0.35), blurRadius: 26, offset: const Offset(0, 10))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                child: Text(widget.label, style: LandingType.button()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CtaSecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _CtaSecondaryButton({required this.label, required this.onTap});

  @override
  State<_CtaSecondaryButton> createState() => _CtaSecondaryButtonState();
}

class _CtaSecondaryButtonState extends State<_CtaSecondaryButton> {
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
              child: Text(widget.label, style: LandingType.button(color: LandingColors.textPrimary)),
            ),
          ),
        ),
      ),
    );
  }
}
