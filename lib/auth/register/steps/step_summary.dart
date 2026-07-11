import 'package:flutter/material.dart';

import '../../../data/car_colors.dart';
import '../../../landing/theme/typography.dart';
import '../../theme/auth_colors.dart';
import '../../widgets/role_selector.dart';
import '../register_data.dart';

class StepSummary extends StatelessWidget {
  final RegisterData data;

  const StepSummary({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDriver = data.isDriver;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SummaryCard(
          title: 'Datos personales',
          rows: [
            _SummaryRow('Nombre', data.fullName),
            _SummaryRow('Cédula', data.cedula),
            _SummaryRow('Correo', data.email),
            _SummaryRow('Teléfono', data.phone),
            _SummaryRow('Rol', data.role?.label ?? '—', highlight: true),
          ],
        ),
        const SizedBox(height: 14),
        _SummaryCard(
          title: 'Datos académicos',
          rows: [
            _SummaryRow('Carné ECI', data.studentId),
            _SummaryRow('Programa', data.program ?? '—'),
            _SummaryRow('Semestre', data.semester ?? '—'),
            _SummaryRow('Vinculación', data.affiliation ?? '—'),
            _SummaryRow('Zona', data.zone ?? '—'),
          ],
        ),
        if (isDriver) ...[
          const SizedBox(height: 14),
          _SummaryCard(
            title: 'Datos del vehículo',
            rows: [
              _SummaryRow('Vehículo', '${data.vehicleBrand} ${data.vehicleModel}'.trim()),
              _SummaryRow('Color', data.vehicleColor != null ? _colorLabel(data.vehicleColor!) : '—'),
              _SummaryRow('Placa', data.plate),
              _SummaryRow('Capacidad', '${data.seatCapacity} pasajeros'),
              _SummaryRow('SOAT vence', data.soatExpiry.isEmpty ? '—' : data.soatExpiry),
            ],
          ),
        ],
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AuthColors.secondaryAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AuthColors.secondaryAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AuthColors.secondaryAccent),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: LandingType.body(size: 12, color: AuthColors.textSecondary),
                    children: [
                      const TextSpan(text: 'Tu solicitud será revisada por un administrador de la ECI en las próximas '),
                      const TextSpan(text: '24 horas', style: TextStyle(fontWeight: FontWeight.w700, color: AuthColors.textPrimary)),
                      const TextSpan(text: '. Recibirás un correo de confirmación.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _colorLabel(CarColor c) => switch (c) {
        CarColor.blue => 'Azul',
        CarColor.white => 'Blanco',
        CarColor.gray => 'Gris',
        CarColor.black => 'Negro',
        CarColor.red => 'Rojo',
        CarColor.green => 'Verde',
      };
}

class _SummaryRow {
  final String label;
  final String value;
  final bool highlight;
  const _SummaryRow(this.label, this.value, {this.highlight = false});
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final List<_SummaryRow> rows;

  const _SummaryCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AuthColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: LandingType.body(size: 10.5, color: AuthColors.primary).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
          Wrap(
            runSpacing: 12,
            children: [
              for (var i = 0; i < rows.length; i += 2)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _RowText(rows[i])),
                    if (i + 1 < rows.length) Expanded(child: _RowText(rows[i + 1])) else const Expanded(child: SizedBox()),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  final _SummaryRow row;
  const _RowText(this.row);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label, style: LandingType.body(size: 10.5, color: AuthColors.textMuted)),
          const SizedBox(height: 3),
          Text(
            row.value.isEmpty ? '—' : row.value,
            style: TextStyle(
              color: row.highlight ? AuthColors.primary : AuthColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
