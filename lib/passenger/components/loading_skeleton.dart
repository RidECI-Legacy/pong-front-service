import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme.dart';

/// A shimmering placeholder block — used instead of a blank screen while
/// a section's data is "loading".
class LoadingSkeleton extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const LoadingSkeleton({super.key, this.height = 16, this.width, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(radius)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, color: Colors.white.withValues(alpha: 0.14));
  }
}

/// A skeleton shaped like a [TripCard], used while recommended trips load.
class TripCardSkeleton extends StatelessWidget {
  const TripCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LandingColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LoadingSkeleton(height: 44, width: 44, radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LoadingSkeleton(height: 13, width: 120),
                    const SizedBox(height: 8),
                    LoadingSkeleton(height: 11, width: 80),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LoadingSkeleton(height: 40),
          const SizedBox(height: 14),
          Row(
            children: [
              const LoadingSkeleton(height: 30, width: 80),
              const Spacer(),
              LoadingSkeleton(height: 36, width: 100, radius: 12),
            ],
          ),
        ],
      ),
    );
  }
}
