import 'package:flutter/material.dart';

/// Reveals [child] with a fade + upward slide the first time it scrolls into
/// the viewport of [controller]. Visibility is recomputed on every scroll
/// tick (and once after the first frame, for content already on screen).
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration delay;
  final double offsetY;

  const ScrollReveal({
    super.key,
    required this.child,
    required this.controller,
    this.delay = Duration.zero,
    this.offsetY = 32,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
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
      if (widget.delay == Duration.zero) {
        setState(() => _visible = true);
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) setState(() => _visible = true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : Offset(0, widget.offsetY / 100),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
