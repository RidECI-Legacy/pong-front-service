import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/theme.dart';
import 'colored_pill.dart';

/// One security/behavior report: reported user, type, description, date
/// and a status selector so admins can triage without leaving the list.
class SecurityReportCard extends StatelessWidget {
  final SecurityReport report;
  final ValueChanged<String> onStatusChange;

  const SecurityReportCard({super.key, required this.report, required this.onStatusChange});

  static const _statuses = ['Pendiente', 'En revisión', 'Resuelto'];

  @override
  Widget build(BuildContext context) {
    final typeColor = AdminPalette.reportTypeColors[report.type] ?? LandingColors.textTertiary;
    final statusColor = AdminPalette.reportStatusColors[report.status] ?? LandingColors.textTertiary;
    return GlassCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(report.reportedUser, style: LandingType.cardTitle(size: 14), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    ColoredPill(label: report.type, color: typeColor),
                  ],
                ),
                const SizedBox(height: 6),
                Text(report.description, style: LandingType.body(size: 12.5)),
                const SizedBox(height: 6),
                Text(report.date, style: LandingType.body(size: 11, color: LandingColors.textTertiary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: report.status,
                dropdownColor: LandingColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                icon: Icon(Icons.expand_more_rounded, size: 16, color: statusColor),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor),
                items: [
                  for (final status in _statuses)
                    DropdownMenuItem(
                      value: status,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(AdminPalette.reportStatusIcons[status], size: 14, color: AdminPalette.reportStatusColors[status]),
                          const SizedBox(width: 6),
                          Text(status),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) onStatusChange(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
