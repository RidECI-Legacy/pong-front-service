import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RouteStop {
  final String label;
  final String detail;
  final Color dotColor;

  const RouteStop({required this.label, required this.detail, required this.dotColor});
}

/// Vertical timeline of route stops (start / intermediate / finish), mirroring
/// the reference dashboard's trip route breakdown.
class RouteTimeline extends StatelessWidget {
  final List<RouteStop> stops;

  const RouteTimeline({super.key, required this.stops});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < stops.length; i++) _buildRow(stops[i], i == stops.length - 1),
      ],
    );
  }

  Widget _buildRow(RouteStop stop, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: stop.dotColor, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.5, color: AppColors.border),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.label,
                    style: TextStyle(color: AppColors.textDark, fontSize: 12.5, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stop.detail,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
