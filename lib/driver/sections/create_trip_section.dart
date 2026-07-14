import 'package:flutter/material.dart';

import '../../passenger/components/glass_card.dart';
import '../../passenger/passenger_actions.dart';
import '../../passenger/theme.dart';
import '../components/publish_trip_form.dart';

/// SECTION "Crear viaje": the publish-trip form plus the rules every
/// driver must follow, shown side by side so nothing is a surprise after
/// hitting publish (Nielsen: help users prevent errors).
class CreateTripSection extends StatelessWidget {
  const CreateTripSection({super.key});

  static const _rules = [
    'Horario permitido: lunes a viernes 4:00am–9:00pm, sábados 4:00am–6:00pm.',
    'Los cupos no pueden superar la capacidad de tu vehículo.',
    'El precio estimado debe ser mayor o igual a \$4.000.',
    'No puedes tener otro viaje activo al mismo tiempo.',
    'Puedes modificar o cancelar hasta 30 minutos antes del inicio.',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 900;
      final form = PublishTripForm(
        onPublish: (origin, destination, when, seats, price) => showActionSnack(
          context,
          'Viaje $origin → $destination publicado para $when. Ya aparece disponible para pasajeros.',
        ),
      );
      final rules = GlassCard(
        radius: 22,
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REGLAS DEL VIAJE', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
            const SizedBox(height: 16),
            for (final rule in _rules) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 15, color: LandingColors.success),
                  const SizedBox(width: 10),
                  Expanded(child: Text(rule, style: LandingType.body(size: 12.5))),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      );

      if (isMobile) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [form, const SizedBox(height: 20), rules]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: form),
          const SizedBox(width: 24),
          Expanded(flex: 5, child: rules),
        ],
      );
    });
  }
}
