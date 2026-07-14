import 'package:flutter/material.dart';

import '../../passenger/components/buttons.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/search_field.dart';
import '../../passenger/theme.dart';

/// The "Crear viaje" form: origin, destination, date/time, seats and
/// price, plus a submit button. Purely presentational — [onPublish] is
/// called with the raw field values so the caller decides what "publish"
/// means (here: a confirmation snackbar over mock data).
class PublishTripForm extends StatefulWidget {
  final void Function(String origin, String destination, String when, String seats, String price) onPublish;

  const PublishTripForm({super.key, required this.onPublish});

  @override
  State<PublishTripForm> createState() => _PublishTripFormState();
}

class _PublishTripFormState extends State<PublishTripForm> {
  final _origin = TextEditingController();
  final _destination = TextEditingController();
  final _when = TextEditingController();
  final _seats = TextEditingController();
  final _price = TextEditingController();

  @override
  void dispose() {
    _origin.dispose();
    _destination.dispose();
    _when.dispose();
    _seats.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CREAR VIAJE', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
          const SizedBox(height: 16),
          SearchField(label: 'Origen', icon: Icons.trip_origin_rounded, hint: 'Portal 80', controller: _origin),
          const SizedBox(height: 12),
          SearchField(label: 'Destino', icon: Icons.flag_rounded, hint: 'Escuela Ing. Julio Garavito', controller: _destination),
          const SizedBox(height: 12),
          SearchField(label: 'Fecha y hora', icon: Icons.schedule_rounded, hint: 'Lun 7:00 AM', controller: _when),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: SearchField(label: 'Cupos', icon: Icons.event_seat_rounded, hint: '3', controller: _seats)),
              const SizedBox(width: 10),
              Expanded(child: SearchField(label: 'Precio', icon: Icons.payments_rounded, hint: '\$4.500', controller: _price)),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Publicar viaje',
            icon: Icons.send_rounded,
            expand: true,
            onTap: () => widget.onPublish(
              _origin.text.isEmpty ? 'Portal 80' : _origin.text,
              _destination.text.isEmpty ? 'Escuela Ing. Julio Garavito' : _destination.text,
              _when.text.isEmpty ? 'Lun 7:00 AM' : _when.text,
              _seats.text.isEmpty ? '3' : _seats.text,
              _price.text.isEmpty ? '\$4.500' : _price.text,
            ),
          ),
        ],
      ),
    );
  }
}
