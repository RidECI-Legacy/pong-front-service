import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models.dart';
import '../../passenger/components/empty_state.dart';
import '../../passenger/components/section_title.dart';
import '../../passenger/passenger_actions.dart';
import '../components/security_report_card.dart';

/// SECTION "Reportes": incidents and behavior reports filed by the
/// community, with an inline status triage.
class ReportsSection extends StatelessWidget {
  final List<SecurityReport> reports;
  final void Function(SecurityReport report, String status) onStatusChange;

  const ReportsSection({super.key, required this.reports, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: Icons.flag_rounded,
          title: 'Reportes de seguridad',
          subtitle: reports.isEmpty ? 'No hay reportes registrados' : '${reports.length} reporte${reports.length == 1 ? '' : 's'} de la comunidad',
        ),
        const SizedBox(height: 20),
        if (reports.isEmpty)
          const EmptyState(icon: Icons.shield_rounded, title: 'Sin incidentes', description: 'No hay reportes de seguridad registrados.')
        else
          for (var i = 0; i < reports.length; i++) ...[
            SecurityReportCard(
              report: reports[i],
              onStatusChange: (status) {
                onStatusChange(reports[i], status);
                showActionSnack(context, 'Reporte de ${reports[i].reportedUser} marcado como "$status".');
              },
            ).animate(delay: (40 * i).ms).fadeIn(duration: 280.ms).slideY(begin: 0.05, curve: Curves.easeOutCubic),
            if (i != reports.length - 1) const SizedBox(height: 12),
          ],
      ],
    );
  }
}
