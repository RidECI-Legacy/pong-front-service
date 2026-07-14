import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../components/empty_state.dart';
import '../components/reservation_card.dart';
import '../components/section_title.dart';
import '../passenger_actions.dart';

/// SECTION "Mis Reservas": the upcoming reservation plus quick pointers to
/// past trips.
class ReservationsSection extends StatelessWidget {
  final ActiveTrip activeTrip;
  final VoidCallback onViewHistory;

  const ReservationsSection({super.key, required this.activeTrip, required this.onViewHistory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.event_available_rounded, title: 'Mis reservas', subtitle: 'Tu próximo viaje y su estado en tiempo real'),
        const SizedBox(height: 20),
        ReservationCard(
          trip: activeTrip,
          meetingPoint: 'Portal 80',
          onViewDetails: () => showActionSnack(context, 'Mostrando el detalle completo del viaje.'),
          onChat: () => showTripChatDialog(context, withName: activeTrip.driverName),
          onEmergency: () => showEmergencyDialog(context),
        ),
        const SizedBox(height: 32),
        EmptyState(
          icon: Icons.event_available_rounded,
          title: 'No tienes más reservas próximas',
          description: 'Cuando reserves un nuevo viaje, aparecerá aquí junto con su estado en tiempo real.',
          actionLabel: 'Ver historial',
          onAction: onViewHistory,
        ),
      ],
    );
  }
}
