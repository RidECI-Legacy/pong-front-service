import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../driver/components/trip_row.dart';
import '../../passenger/components/empty_state.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/section_title.dart';
import '../../passenger/components/status_badge.dart';
import '../../passenger/theme.dart';

/// SECTION "Viajes activos": every trip currently running or about to
/// start across the whole community.
class ActiveTripsSection extends StatelessWidget {
  const ActiveTripsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = MockData.activeAdminTrips;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(icon: Icons.alt_route_rounded, title: 'Viajes activos', subtitle: '${trips.length} viajes en curso o por iniciar', accent: LandingColors.accent),
        const SizedBox(height: 20),
        if (trips.isEmpty)
          const EmptyState(icon: Icons.alt_route_rounded, title: 'Sin viajes activos', description: 'No hay viajes en curso en este momento.')
        else
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                for (var i = 0; i < trips.length; i++) ...[
                  TripRow(
                    title: trips[i].driverName,
                    subtitle: '${trips[i].route} · ${trips[i].time}',
                    amountLabel: '${trips[i].seatsFilled}/${trips[i].seatsTotal} cupos',
                    status: trips[i].status == 'En curso' ? TripStatus.inProgress : TripStatus.confirmed,
                  ),
                  if (i != trips.length - 1) Divider(height: 1, color: LandingColors.glassBorder),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
