import 'package:flutter/material.dart';

import '../../landing/theme/typography.dart';
import '../theme/auth_colors.dart';

/// Numbered step indicator used across the register wizard and password
/// recovery flow. The step count is dynamic (the register wizard grows by
/// one step for the "Conductor" role), so this rebuilds cleanly whenever
/// [labels] changes length.
class StepProgress extends StatelessWidget {
  final List<String> labels;
  final int currentIndex;

  const StepProgress({super.key, required this.labels, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final progress = labels.length <= 1 ? 1.0 : currentIndex / (labels.length - 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < labels.length; i++) ...[
              if (i > 0) const Expanded(child: SizedBox()),
              _StepDot(
                index: i,
                label: labels[i],
                state: i < currentIndex
                    ? _DotState.done
                    : i == currentIndex
                        ? _DotState.current
                        : _DotState.upcoming,
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 3,
            child: Stack(
              children: [
                Container(color: AuthColors.border),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(gradient: AuthColors.buttonGradient),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _DotState { done, current, upcoming }

class _StepDot extends StatelessWidget {
  final int index;
  final String label;
  final _DotState state;

  const _StepDot({required this.index, required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDone = state == _DotState.done;
    final isCurrent = state == _DotState.current;
    final circleColor = isDone || isCurrent ? AuthColors.primary : Colors.transparent;
    final borderColor = isDone || isCurrent ? AuthColors.primary : AuthColors.border;
    final textColor = isDone || isCurrent ? AuthColors.primary : AuthColors.textMuted;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: isCurrent
                ? [BoxShadow(color: AuthColors.primary.withValues(alpha: 0.45), blurRadius: 14, spreadRadius: 1)]
                : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isDone
                  ? const Icon(Icons.check_rounded, key: ValueKey('check'), size: 16, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      key: ValueKey('n$index'),
                      style: TextStyle(
                        color: isCurrent ? Colors.white : AuthColors.textMuted,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: LandingType.body(size: 9.5, color: textColor).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6),
        ),
      ],
    );
  }
}
