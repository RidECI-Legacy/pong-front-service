import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../passenger/components/dashboard_hero.dart';
import '../../passenger/components/quick_actions_grid.dart';
import '../../passenger/components/statistic_card.dart';
import '../../passenger/components/status_badge.dart';
import '../../passenger/passenger_actions.dart';
import '../../passenger/theme.dart';
import '../components/current_trip_card.dart';
import '../components/trip_row.dart';
import '../driver_section.dart';

/// SECTION "Inicio": greeting, the current trip in progress (with live
/// map and confirmed passengers), a quick stats snapshot, quick actions
/// and a peek at recent history.
class DriverDashboardSection extends StatelessWidget {
  final String driverName;
  final ValueChanged<DriverSection> onNavigate;

  const DriverDashboardSection({super.key, required this.driverName, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final stats = MockData.driverStats;
    final passengers = MockData.confirmedPassengers;
    final recent = MockData.driverHistory.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardHero(name: driverName.split(' ').first),
        const SizedBox(height: 28),
        CurrentTripCard(
          passengers: passengers,
          onEmergency: () => showEmergencyDialog(context),
          onChatPassenger: (p) => showTripChatDialog(context, withName: p.name),
          onReportPassenger: (p) => showActionSnack(context, 'Reporte sobre ${p.name} enviado a seguridad institucional.', icon: Icons.flag_rounded),
        ),
        const SizedBox(height: 36),
        StatisticCard(
          title: 'Tus estadísticas',
          icon: Icons.bar_chart_rounded,
          stats: [
            StatEntry(icon: Icons.route_rounded, value: stats.tripsCompleted, label: 'Viajes completados'),
            StatEntry(icon: Icons.star_rounded, value: stats.rating.round(), label: 'Calificación', color: const Color(0xFFFBBF24)),
            StatEntry(icon: Icons.eco_rounded, value: stats.co2Kg, suffix: 'kg', label: 'CO₂ ahorrado'),
            StatEntry(icon: Icons.savings_rounded, value: stats.earningsCop ~/ 1000, suffix: 'k', label: 'Ganancias del mes'),
          ],
        ),
        const SizedBox(height: 36),
        Text('Acciones rápidas', style: LandingType.cardTitle(size: 18)),
        const SizedBox(height: 16),
        QuickActionsGrid(actions: [
          QuickAction(icon: Icons.add_road_rounded, label: 'Crear viaje', accent: LandingColors.accent, onTap: () => onNavigate(DriverSection.createTrip)),
          QuickAction(icon: Icons.directions_car_filled_rounded, label: 'Mi vehículo', accent: LandingColors.primaryLight, onTap: () => onNavigate(DriverSection.vehicle)),
          QuickAction(icon: Icons.list_alt_rounded, label: 'Mis viajes', accent: LandingColors.success, onTap: () => onNavigate(DriverSection.myTrips)),
          QuickAction(icon: Icons.bar_chart_rounded, label: 'Estadísticas', accent: const Color(0xFFFBBF24), onTap: () => onNavigate(DriverSection.stats)),
          QuickAction(icon: Icons.shield_rounded, label: 'Seguridad', accent: LandingColors.warning, onTap: () => onNavigate(DriverSection.security)),
          QuickAction(icon: Icons.sos_rounded, label: 'Emergencia', accent: LandingColors.danger, onTap: () => showEmergencyDialog(context)),
        ]),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Historial reciente', style: LandingType.cardTitle(size: 18)),
            TextButton(
              onPressed: () => onNavigate(DriverSection.myTrips),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Ver todos', style: TextStyle(color: LandingColors.accent, fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: LandingColors.glassBorder)),
          child: Column(
            children: [
              for (var i = 0; i < recent.length; i++) ...[
                TripRow(
                  title: recent[i].route,
                  subtitle: recent[i].date,
                  amountLabel: '+\$${_formatCop(recent[i].amount)}',
                  status: TripStatus.completed,
                  amountColor: LandingColors.success,
                ),
                if (i != recent.length - 1) Divider(height: 1, color: LandingColors.glassBorder),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

String _formatCop(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final posFromEnd = s.length - i;
    buffer.write(s[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}
