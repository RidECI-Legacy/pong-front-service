import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Cross-fades between wizard steps *in place* (no route change): the
/// outgoing step fades/slides out while the incoming one fades, slides and
/// un-blurs into focus — the "liquid glass" morph the register/recovery
/// flows use to move between stages. Per `UI_Guidelines.md` no animation
/// here exceeds 350ms.
class LiquidStepSwitcher extends StatelessWidget {
  final Widget child;
  final Object stepKey;

  const LiquidStepSwitcher({super.key, required this.child, required this.stepKey});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topCenter,
        children: [...previousChildren, if (currentChild != null) currentChild],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(stepKey),
        child: child.animate().blurXY(begin: 8, end: 0, duration: 280.ms, curve: Curves.easeOut),
      ),
    );
  }
}
