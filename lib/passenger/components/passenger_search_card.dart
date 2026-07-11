import 'package:flutter/material.dart';

import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';
import 'search_field.dart';

class TripSearchCriteria {
  final String origin;
  final String destination;
  final DateTime date;
  final TimeOfDay time;
  final int passengers;

  const TripSearchCriteria({
    required this.origin,
    required this.destination,
    required this.date,
    required this.time,
    required this.passengers,
  });
}

/// The most important component of the dashboard: a large glass card with
/// origin/destination/date/time/passengers and the primary "Buscar Viajes"
/// CTA.
class PassengerSearchCard extends StatefulWidget {
  final ValueChanged<TripSearchCriteria> onSearch;

  const PassengerSearchCard({super.key, required this.onSearch});

  @override
  State<PassengerSearchCard> createState() => _PassengerSearchCardState();
}

class _PassengerSearchCardState extends State<PassengerSearchCard> {
  final _originController = TextEditingController(text: 'Portal 80');
  final _destinationController = TextEditingController(text: 'Escuela Ing. Julio Garavito');
  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 6, minute: 40);
  int _passengers = 1;

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  static Widget _darkPickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: LandingColors.accent,
          onPrimary: Colors.black,
          surface: LandingColors.bgSurface,
        ),
        dialogBackgroundColor: LandingColors.bgSurface,
      ),
      child: child!,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: _darkPickerTheme,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time, builder: _darkPickerTheme);
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    widget.onSearch(TripSearchCriteria(
      origin: _originController.text,
      destination: _destinationController.text,
      date: _date,
      time: _time,
      passengers: _passengers,
    ));
  }

  String get _dateLabel => '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}';
  String get _timeLabel => _time.format(context);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 24,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BUSCAR VIAJE', style: LandingType.eyebrow(color: LandingColors.accent)),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 760;
            final origin = SearchField(label: 'Origen', icon: Icons.my_location_rounded, controller: _originController, hint: 'Punto de partida');
            final destination = SearchField(label: 'Destino', icon: Icons.place_rounded, controller: _destinationController, hint: 'A dónde vas');
            final date = _TapField(label: 'Fecha', icon: Icons.calendar_today_rounded, value: _dateLabel, onTap: _pickDate);
            final time = _TapField(label: 'Hora', icon: Icons.access_time_rounded, value: _timeLabel, onTap: _pickTime);
            final passengers = _PassengerStepper(
              value: _passengers,
              onChanged: (v) => setState(() => _passengers = v),
            );
            final button = PrimaryButton(label: 'Buscar Viajes', icon: Icons.search_rounded, onTap: _submit, expand: isMobile);

            if (isMobile) {
              return Column(
                children: [
                  origin,
                  const SizedBox(height: 12),
                  destination,
                  const SizedBox(height: 12),
                  Row(children: [Expanded(child: date), const SizedBox(width: 12), Expanded(child: time)]),
                  const SizedBox(height: 12),
                  passengers,
                  const SizedBox(height: 16),
                  button,
                ],
              );
            }

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: origin),
                    const SizedBox(width: 12),
                    Expanded(flex: 3, child: destination),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: date),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: time),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: passengers),
                    const SizedBox(width: 16),
                    button,
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _TapField({required this.label, required this.icon, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: LandingColors.glassBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: LandingColors.textTertiary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label.toUpperCase(), style: LandingType.body(size: 9.5, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                    Text(value, style: const TextStyle(color: LandingColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassengerStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _PassengerStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LandingColors.glassBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_alt_rounded, size: 16, color: LandingColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Text('$value ${value == 1 ? 'pasajero' : 'pasajeros'}', style: const TextStyle(color: LandingColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600)),
          ),
          _StepButton(icon: Icons.remove_rounded, onTap: value > 1 ? () => onChanged(value - 1) : null),
          const SizedBox(width: 6),
          _StepButton(icon: Icons.add_rounded, onTap: value < 4 ? () => onChanged(value + 1) : null),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          child: Icon(icon, size: 14, color: enabled ? LandingColors.textPrimary : LandingColors.textTertiary.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}
