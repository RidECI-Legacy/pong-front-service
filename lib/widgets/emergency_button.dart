import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// SOS button used on active-trip panels. Mirrors the "Botón de emergencia"
/// flow from the requirements: confirm -> "locate" -> notify -> success.
class EmergencyButton extends StatelessWidget {
  final Color background;
  final Color foreground;

  const EmergencyButton({
    super.key,
    this.background = AppColors.coral,
    this.foreground = Colors.white,
  });

  Future<void> _handleTap(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.warning_amber_rounded, color: AppColors.coral, size: 32),
        title: const Text('¿Enviar alerta de emergencia?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        content: Text(
          'Se compartirá tu ubicación en tiempo real con tu contacto de confianza y con seguridad institucional.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Confirmar alerta', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.deepGreenDarker,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.mint, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Alerta enviada con tu ubicación a tu contacto y a seguridad institucional.',
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sos_rounded, size: 14, color: background),
              const SizedBox(width: 6),
              Text('SOS', style: TextStyle(color: background, fontSize: 11.5, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
            ],
          ),
        ),
      ),
    );
  }
}
