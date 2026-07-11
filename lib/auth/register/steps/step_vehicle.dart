import 'package:flutter/material.dart';

import '../../../data/car_colors.dart';
import '../../../landing/theme/typography.dart';
import '../../theme/auth_colors.dart';
import '../../widgets/auth_field.dart';
import '../register_data.dart';

/// Driver-only step: this is the concrete divergence between the passenger
/// and driver registration paths — it's inserted into the wizard only when
/// `data.role == RideRole.conductor` (see [RegisterPage._steps]).
class StepVehicle extends StatelessWidget {
  final RegisterData data;
  final Map<String, String> errors;
  final TextEditingController brandCtrl;
  final TextEditingController modelCtrl;
  final TextEditingController plateCtrl;
  final VoidCallback onChanged;

  const StepVehicle({
    super.key,
    required this.data,
    required this.errors,
    required this.brandCtrl,
    required this.modelCtrl,
    required this.plateCtrl,
    required this.onChanged,
  });

  Future<void> _pickExpiry(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AuthColors.primary, surface: AuthColors.modal),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      data.soatExpiry = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'COLOR DEL VEHÍCULO *',
          style: LandingType.body(size: 10.5, color: AuthColors.textMuted).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.8),
        ),
        const SizedBox(height: 8),
        _ColorPicker(
          value: data.vehicleColor,
          onChanged: (c) {
            data.vehicleColor = c;
            onChanged();
          },
        ),
        if (errors['vehicleColor'] != null) ...[
          const SizedBox(height: 6),
          Text(errors['vehicleColor']!, style: const TextStyle(color: AuthColors.danger, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ],
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AuthTextField(
                label: 'Marca',
                hint: 'Ej: Chevrolet',
                controller: brandCtrl,
                errorText: errors['vehicleBrand'],
                onChanged: (v) {
                  data.vehicleBrand = v;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AuthTextField(
                label: 'Modelo',
                hint: 'Ej: Spark GT 2020',
                controller: modelCtrl,
                errorText: errors['vehicleModel'],
                onChanged: (v) {
                  data.vehicleModel = v;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AuthTextField(
                label: 'Placa',
                hint: 'ABC-123',
                controller: plateCtrl,
                errorText: errors['plate'],
                onChanged: (v) {
                  data.plate = v.toUpperCase();
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AuthDropdownField<int>(
                label: 'Capacidad',
                hint: 'Cupos',
                value: data.seatCapacity,
                options: RegisterOptions.seatCapacities,
                labelOf: (v) => '$v pasajero${v == 1 ? '' : 's'}',
                onChanged: (v) {
                  if (v != null) data.seatCapacity = v;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AuthFieldShell(
          label: 'Vigencia SOAT / Tecnomecánica',
          errorText: errors['soatExpiry'],
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _pickExpiry(context),
            child: InputDecorator(
              decoration: authInputDecoration(
                hint: 'DD/MM/AAAA',
                hasError: errors['soatExpiry'] != null,
                suffixIcon: const Icon(Icons.calendar_today_rounded, size: 16, color: AuthColors.textMuted),
              ),
              child: Text(
                data.soatExpiry.isEmpty ? 'DD/MM/AAAA' : data.soatExpiry,
                style: TextStyle(
                  color: data.soatExpiry.isEmpty ? AuthColors.textDisabled : AuthColors.textPrimary,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final CarColor? value;
  final ValueChanged<CarColor> onChanged;

  const _ColorPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final entry in carColorStyles.entries)
          _ColorSwatch(color: entry.key, style: entry.value, selected: value == entry.key, onTap: () => onChanged(entry.key)),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final CarColor color;
  final CarColorStyle style;
  final bool selected;
  final VoidCallback onTap;

  const _ColorSwatch({required this.color, required this.style, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: style.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: selected ? AuthColors.primary : Colors.transparent, width: 2.5),
            boxShadow: selected ? [BoxShadow(color: AuthColors.primary.withValues(alpha: 0.5), blurRadius: 12)] : null,
          ),
          child: selected
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
              : null,
        ),
      ),
    );
  }
}
