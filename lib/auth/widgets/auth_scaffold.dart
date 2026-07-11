import 'package:flutter/material.dart';

import '../../landing/components/glow_blob.dart';
import '../../landing/theme/typography.dart';
import '../theme/auth_colors.dart';

/// Shared shell for every auth screen (register wizard, password recovery):
/// dark gradient background with floating glow blobs, a small logo, and a
/// responsive split layout — branding on the left, glass card on the right
/// on wide screens; stacked single column on mobile/tablet.
class AuthScaffold extends StatelessWidget {
  final Widget leftPanel;
  final Widget card;

  const AuthScaffold({super.key, required this.leftPanel, required this.card});

  /// Scrolls [child] when it's taller than the viewport, otherwise centers
  /// it within the full available height — avoids both the bottom overflow
  /// on tall steps (e.g. the driver summary) and the top-anchored look on
  /// short ones (e.g. login) that a plain `SingleChildScrollView` produces.
  static Widget _centeredScrollable(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.bgDeepest,
      body: LayoutBuilder(
        builder: (context, outerConstraints) {
          return SizedBox(
            width: outerConstraints.maxWidth,
            height: outerConstraints.maxHeight,
            child: DecoratedBox(
              decoration: const BoxDecoration(gradient: AuthColors.pageGradient),
              child: Stack(
                children: [
                  Positioned(
                    top: -120,
                    left: -80,
                    child: GlowBlob(size: 420, color: AuthColors.primary, opacity: 0.22, duration: const Duration(seconds: 9)),
                  ),
                  Positioned(
                    bottom: -140,
                    right: -100,
                    child: GlowBlob(size: 480, color: AuthColors.secondaryAccent, opacity: 0.18, duration: const Duration(seconds: 11)),
                  ),
                  SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 980;
                        final content = isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 64),
                                      child: _centeredScrollable(leftPanel),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
                                      child: _centeredScrollable(card),
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _MobileLogo(),
                                    const SizedBox(height: 24),
                                    leftPanel,
                                    const SizedBox(height: 28),
                                    card,
                                  ],
                                ),
                              );
                        return content;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MobileLogo extends StatelessWidget {
  const _MobileLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.asset('assets/branding/rideci_icon.png', width: 32, height: 32, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Text('RidECI', style: LandingType.cardTitle(size: 18)),
      ],
    );
  }
}

/// Small logo lockup used at the top of the left branding panel on wide
/// layouts (mobile shows [_MobileLogo] above the whole page instead).
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.asset('assets/branding/rideci_icon.png', width: 32, height: 32, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Text('RidECI', style: LandingType.cardTitle(size: 18)),
      ],
    );
  }
}
