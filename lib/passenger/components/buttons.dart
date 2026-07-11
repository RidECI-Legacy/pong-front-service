import 'package:flutter/material.dart';

import '../theme.dart';

/// Filled, green/blue-gradient CTA button with a hover glow — the primary
/// action button used throughout the passenger dashboard.
class PrimaryButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool expand;
  final EdgeInsetsGeometry padding;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.expand = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onTap == null;
    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 17, color: Colors.white),
          const SizedBox(width: 9),
        ],
        Text(widget.label, style: LandingType.button()),
      ],
    );

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: (!disabled && _hover) ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 160),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: disabled ? null : LandingColors.buttonGradient,
            color: disabled ? Colors.white.withValues(alpha: 0.06) : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                      color: LandingColors.primary.withValues(alpha: _hover ? 0.5 : 0.28),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              child: Padding(padding: widget.padding, child: content),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined ghost button — secondary action.
class SecondaryButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool expand;

  const SecondaryButton({super.key, required this.label, this.icon, this.onTap, this.expand = false});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: _hover ? Colors.white.withValues(alpha: 0.07) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LandingColors.glassBorder),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Row(
                mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 16, color: LandingColors.textPrimary),
                    const SizedBox(width: 8),
                  ],
                  Text(widget.label, style: LandingType.button(color: LandingColors.textPrimary)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small icon-only button (ghost) used in toolbars and card headers.
class GhostIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size;

  const GhostIconButton({super.key, required this.icon, this.onTap, this.tooltip, this.size = 38});

  @override
  State<GhostIconButton> createState() => _GhostIconButtonState();
}

class _GhostIconButtonState extends State<GhostIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: widget.size,
        height: widget.size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _hover ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: LandingColors.glassBorder),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: widget.onTap,
            child: Icon(widget.icon, size: 17, color: LandingColors.textSecondary),
          ),
        ),
      ),
    );
    if (widget.tooltip == null) return button;
    return Tooltip(message: widget.tooltip!, child: button);
  }
}
