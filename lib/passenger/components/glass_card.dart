import 'package:flutter/material.dart';

import '../theme.dart';

/// The base card surface used across the passenger dashboard: rounded
/// glassmorphic panel, soft border, subtle shadow. Optionally lifts and
/// glows on hover when [onTap] is provided.
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? tint;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 20,
    this.onTap,
    this.tint,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final card = LandingEffects.glassChild(
      radius: widget.radius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: widget.padding,
        transform: Matrix4.translationValues(0, (widget.onTap != null && _hover) ? -3 : 0, 0),
        decoration: LandingEffects.glassDecoration(
          radius: widget.radius,
          tint: widget.tint,
          borderColor: (widget.onTap != null && _hover) ? LandingColors.primaryLight.withValues(alpha: 0.4) : null,
        ),
        child: widget.child,
      ),
    );

    if (widget.onTap == null) return card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.radius),
          onTap: widget.onTap,
          child: card,
        ),
      ),
    );
  }
}
