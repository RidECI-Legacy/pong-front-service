import 'package:flutter/material.dart';

import '../../passenger/components/buttons.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/section_title.dart';
import '../../passenger/passenger_actions.dart';
import '../../passenger/theme.dart';

/// SECTION "Institucional": allowed publishing hours plus report export.
class InstitutionalSection extends StatefulWidget {
  const InstitutionalSection({super.key});

  @override
  State<InstitutionalSection> createState() => _InstitutionalSectionState();
}

class _InstitutionalSectionState extends State<InstitutionalSection> {
  String _range = 'Semanal';
  String _format = 'PDF';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.summarize_rounded, title: 'Reportes institucionales', subtitle: 'Horarios permitidos y exportación de reportes', accent: LandingColors.warning),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final schedule = GlassCard(
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HORARIOS PERMITIDOS PARA PUBLICAR VIAJES', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10)),
                const SizedBox(height: 18),
                const _ScheduleRow(days: 'Lunes a viernes', hours: '4:00 am – 9:00 pm'),
                const _ScheduleRow(days: 'Sábados', hours: '4:00 am – 6:00 pm'),
                const _ScheduleRow(days: 'Domingos', hours: 'No disponible'),
              ],
            ),
          );

          final export = GlassCard(
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EXPORTAR REPORTES', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10)),
                const SizedBox(height: 18),
                Text('Periodo', style: LandingType.body(size: 11.5, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final r in const ['Semanal', 'Mensual', 'Semestral']) _Chip(label: r, selected: _range == r, onTap: () => setState(() => _range = r)),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Formato', style: LandingType.body(size: 11.5, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final f in const ['PDF', 'Excel']) _Chip(label: f, selected: _format == f, onTap: () => setState(() => _format = f)),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Generar y descargar',
                  icon: Icons.file_download_rounded,
                  expand: true,
                  onTap: () => showActionSnack(context, 'Reporte $_range generado en $_format.', icon: Icons.file_download_rounded),
                ),
              ],
            ),
          );

          if (isMobile) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [schedule, const SizedBox(height: 16), export]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: schedule), const SizedBox(width: 16), Expanded(child: export)],
          );
        }),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final String days;
  final String hours;
  const _ScheduleRow({required this.days, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(days, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: LandingColors.textPrimary)),
          Text(hours, style: LandingType.body(size: 12.5, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? LandingColors.success.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? LandingColors.success.withValues(alpha: 0.4) : LandingColors.glassBorder),
          ),
          child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? LandingColors.success : LandingColors.textSecondary)),
        ),
      ),
    );
  }
}
