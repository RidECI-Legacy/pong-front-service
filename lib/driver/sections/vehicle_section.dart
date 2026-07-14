import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../passenger/components/buttons.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/passenger_actions.dart';
import '../../passenger/theme.dart';
import '../components/vehicle_showcase_card.dart';

/// SECTION "Mi vehículo": the vehicle showcase plus verified documents and
/// details.
class VehicleSection extends StatelessWidget {
  const VehicleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final v = MockData.driverVehicle;
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 900;
      final showcase = VehicleShowcaseCard(
        brandModel: '${v.brand} ${v.model}',
        rating: 4.8,
        carColor: v.carColor,
        verified: v.verified,
        specs: [
          (Icons.confirmation_number_outlined, 'Placa ${v.plate}'),
          (Icons.event_seat_outlined, '${v.capacity} puestos'),
        ],
      );
      final details = GlassCard(
        radius: 22,
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DATOS DEL VEHÍCULO', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
            const SizedBox(height: 18),
            _DetailRow(label: 'Marca', value: v.brand),
            _DetailRow(label: 'Modelo', value: v.model),
            _DetailRow(label: 'Placa', value: v.plate),
            _DetailRow(label: 'Capacidad', value: '${v.capacity} puestos'),
            _DetailRow(label: 'Licencia vence', value: v.licenseExpiry),
            const SizedBox(height: 8),
            SecondaryButton(
              label: 'Actualizar documentos',
              icon: Icons.upload_file_rounded,
              expand: true,
              onTap: () => showActionSnack(context, 'Selecciona los documentos actualizados de tu vehículo.', icon: Icons.upload_file_rounded),
            ),
          ],
        ),
      );

      if (isMobile) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [showcase, const SizedBox(height: 20), details]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 300, child: showcase),
          const SizedBox(width: 24),
          Expanded(child: details),
        ],
      );
    });
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: LandingType.body(size: 12.5, color: LandingColors.textTertiary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: LandingColors.textPrimary)),
        ],
      ),
    );
  }
}
