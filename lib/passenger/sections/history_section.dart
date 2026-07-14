import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../components/glass_card.dart';
import '../components/history_table.dart';
import '../components/section_title.dart';
import '../passenger_mock_helpers.dart';

/// SECTION "Historial": the full ride-history table.
class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = PassengerMockHelpers.historyRows();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: Icons.history_rounded,
          title: 'Historial de viajes',
          subtitle: '${rows.length} viaje${rows.length == 1 ? '' : 's'} completado${rows.length == 1 ? '' : 's'}',
        ),
        const SizedBox(height: 20),
        GlassCard(radius: 20, padding: const EdgeInsets.all(20), child: HistoryTable(rows: rows))
            .animate()
            .fadeIn(duration: 300.ms, delay: 60.ms)
            .slideY(begin: 0.05, curve: Curves.easeOutCubic),
      ],
    );
  }
}
