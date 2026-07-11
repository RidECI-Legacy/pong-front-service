import 'package:flutter/material.dart';

import '../theme/typography.dart';

/// Animates a counter from 0 up to a numeric value once it scrolls into
/// view, formatting the result with an optional [prefix]/[suffix] (e.g.
/// "+", "%"). Non-numeric stat values (like "24/7" or "CO2 down") are
/// rendered statically via [staticValue].
class AnimatedCounter extends StatefulWidget {
  final ScrollController controller;
  final int? targetValue;
  final String? staticValue;
  final String prefix;
  final String suffix;
  final String label;
  final Duration delay;

  const AnimatedCounter({
    super.key,
    required this.controller,
    required this.label,
    this.targetValue,
    this.staticValue,
    this.prefix = '',
    this.suffix = '',
    this.delay = Duration.zero,
  }) : assert(targetValue != null || staticValue != null);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_visible || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;
    final position = renderObject.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    if (position.dy < screenHeight * 0.92) {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.targetValue != null)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _visible ? widget.targetValue!.toDouble() : 0),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Text(
                '${widget.prefix}${value.round()}${widget.suffix}',
                style: LandingType.statValue(),
              );
            },
          )
        else
          Text(widget.staticValue!, style: LandingType.statValue(size: 38)),
        const SizedBox(height: 8),
        Text(widget.label, style: LandingType.statLabel()),
      ],
    );
  }
}
