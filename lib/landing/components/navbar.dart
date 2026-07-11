import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';
import 'login_dialog.dart';

/// Transparent floating navbar that gains a blurred, translucent background
/// once the page scrolls past a small threshold.
class LandingNavbar extends StatefulWidget {
  final ScrollController controller;
  final void Function(String label) onNavTap;

  const LandingNavbar({super.key, required this.controller, required this.onNavTap});

  static const links = ['Inicio', 'Cómo funciona', 'Seguridad', 'Beneficios', 'FAQ'];

  @override
  State<LandingNavbar> createState() => _LandingNavbarState();
}

class _LandingNavbarState extends State<LandingNavbar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final scrolled = widget.controller.offset > 12;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _scrolled ? 16 : 0, sigmaY: _scrolled ? 16 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _scrolled ? LandingColors.bgDeepest.withValues(alpha: 0.55) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: _scrolled ? LandingColors.glassBorder : Colors.transparent,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Logo(),
                if (!isMobile) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final l in LandingNavbar.links) _NavLink(label: l, onTap: widget.onNavTap),
                    ],
                  ),
                  _LoginButton(onTap: () => showLoginDialog(context)),
                ] else
                  _MobileMenuButton(onNavTap: widget.onNavTap),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
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

class _NavLink extends StatefulWidget {
  final String label;
  final void Function(String) onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => widget.onTap(widget.label),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: LandingType.navLink().copyWith(
              color: _hover ? LandingColors.textPrimary : LandingColors.textSecondary,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LoginButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LandingColors.buttonGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            child: Text('Ingresar', style: LandingType.button()),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final void Function(String) onNavTap;
  const _MobileMenuButton({required this.onNavTap});

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: LandingColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final l in LandingNavbar.links)
                  ListTile(
                    title: Text(l, style: LandingType.body(size: 15, color: LandingColors.textPrimary)),
                    onTap: () {
                      Navigator.of(context).pop();
                      onNavTap(l);
                    },
                  ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _LoginButton(onTap: () {
                      Navigator.of(context).pop();
                      showLoginDialog(context);
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _openMenu(context),
      icon: const Icon(Icons.menu_rounded, color: LandingColors.textPrimary),
    );
  }
}
