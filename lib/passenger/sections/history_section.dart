import 'package:flutter/material.dart';

import '../components/glass_card.dart';
import '../components/history_table.dart';
import '../passenger_mock_helpers.dart';
import '../theme.dart';

/// SECTION "Historial": the full ride-history table.
class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = PassengerMockHelpers.historyRows();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial de viajes', style: LandingType.cardTitle(size: 18)),
        const SizedBox(height: 16),
        GlassCard(radius: 20, padding: const EdgeInsets.all(20), child: HistoryTable(rows: rows)),
      ],
    );
  }
}
