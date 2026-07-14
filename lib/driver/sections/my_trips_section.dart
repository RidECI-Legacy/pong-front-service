import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/status_badge.dart';
import '../../passenger/passenger_actions.dart';
import '../../passenger/theme.dart';
import '../components/trip_row.dart';

/// SECTION "Mis viajes": the next scheduled trip, its history, and an
/// earnings snapshot + a small tip card alongside.
class MyTripsSection extends StatelessWidget {
  const MyTripsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final history = MockData.driverHistory;
    final totalEarned = history.fold<int>(0, (sum, h) => sum + h.amount);
    final avgEarned = history.isEmpty ? 0 : totalEarned ~/ history.length;

    final mainCard = GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('VIAJE PROGRAMADO', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
          const SizedBox(height: 10),
          TripRow(
            title: 'Portal 80 → Escuela Ing. Julio Garavito',
            subtitle: 'Hoy · 7:00 AM · 3 cupos',
            amountLabel: '\$13.500',
            status: TripStatus.confirmed,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => showActionSnack(context, 'Abriendo edición del viaje programado.'),
                  child: const Text('Modificar', style: TextStyle(color: LandingColors.accent, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => showActionSnack(context, 'Viaje cancelado. Los pasajeros confirmados fueron notificados.', icon: Icons.cancel_rounded),
                  child: const Text('Cancelar', style: TextStyle(color: LandingColors.danger, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: LandingColors.glassBorder),
          const SizedBox(height: 16),
          Text('HISTORIAL', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
          for (final item in history)
            TripRow(
              title: item.route,
              subtitle: item.date,
              amountLabel: '+\$${_formatCop(item.amount)}',
              status: TripStatus.completed,
              amountColor: LandingColors.success,
            ),
        ],
      ),
    );

    final sidebar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          radius: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('GANANCIAS', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _StatBlock(value: '${history.length}', label: 'Viajes completados')),
                  Expanded(child: _StatBlock(value: '\$${_formatShort(totalEarned)}', label: 'Total ganado', valueColor: LandingColors.success)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _StatBlock(value: '\$${_formatShort(avgEarned)}', label: 'Promedio/viaje')),
                  Expanded(child: _StatBlock(value: '3', label: 'Cupos libres hoy')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          radius: 20,
          tint: LandingColors.success.withValues(alpha: 0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: LandingColors.success.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.bolt_rounded, size: 17, color: LandingColors.success),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Publica tu próximo viaje con anticipación: los conductores puntuales reciben más reservas.',
                  style: LandingType.body(size: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 900;
      if (isMobile) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [mainCard, const SizedBox(height: 16), sidebar]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: mainCard),
          const SizedBox(width: 24),
          SizedBox(width: 320, child: sidebar),
        ],
      );
    });
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  const _StatBlock({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: LandingType.cardTitle(size: 18, color: valueColor ?? LandingColors.textPrimary)),
        Text(label, style: LandingType.body(size: 11, color: LandingColors.textTertiary)),
      ],
    );
  }
}

String _formatShort(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}k';
  return '$value';
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
