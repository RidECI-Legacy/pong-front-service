import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Mock "reportar comportamiento" flow (Módulo 5). Local only — shows a
/// confirmation SnackBar instead of hitting a backend.
Future<void> showReportDialog(BuildContext context, {required String userName}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _ReportDialog(userName: userName),
  );
}

class _ReportDialog extends StatefulWidget {
  final String userName;
  const _ReportDialog({required this.userName});

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  static const _reasons = ['Comportamiento inapropiado', 'No se presentó', 'Seguridad en la ruta', 'Otro'];
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Reportar a ${widget.userName}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selecciona el motivo del reporte:', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final reason in _reasons)
                ChoiceChip(
                  label: Text(reason, style: const TextStyle(fontSize: 11.5)),
                  selected: _selected == reason,
                  selectedColor: AppColors.coral.withValues(alpha: 0.16),
                  labelStyle: TextStyle(color: _selected == reason ? AppColors.coral : AppColors.textMuted),
                  onSelected: (_) => setState(() => _selected = reason),
                ),
            ],
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        ),
        ElevatedButton(
          onPressed: _selected == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.deepGreenDarker,
                      content: Text(
                        'Reporte enviado. El equipo de seguridad lo revisará pronto.',
                        style: const TextStyle(color: Colors.white, fontSize: 12.5),
                      ),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Enviar reporte', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
