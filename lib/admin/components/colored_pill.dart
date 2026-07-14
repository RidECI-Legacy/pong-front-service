import 'package:flutter/material.dart';

/// A small rounded, colored label pill — used for role badges, report
/// types and status indicators across every admin list so the same kind
/// of information always looks the same (Nielsen: consistency & standards).
class ColoredPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const ColoredPill({super.key, required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Shared color/icon lookups so every admin section (validations, users,
/// reports…) renders the same role/status pill consistently.
class AdminPalette {
  AdminPalette._();

  static const roleColors = {
    'Conductor': Color(0xFF8C86E0),
    'Pasajero': Color(0xFF35E6B5),
    'Acompañante': Color(0xFFF3A73F),
    'Profesor': Color(0xFF60A5FA),
  };

  static const userStatusColors = {
    'Activo': Color(0xFF35E6B5),
    'Suspendido': Color(0xFFF06B54),
    'Pendiente': Color(0xFFF3A73F),
  };

  static const userStatusIcons = {
    'Activo': Icons.check_circle_rounded,
    'Suspendido': Icons.block_rounded,
    'Pendiente': Icons.hourglass_empty_rounded,
  };

  static const reportTypeColors = {
    'Comportamiento': Color(0xFFF3A73F),
    'Ausencia': Color(0xFF8C86E0),
    'Seguridad': Color(0xFFF06B54),
  };

  static const reportStatusColors = {
    'Pendiente': Color(0xFFF06B54),
    'En revisión': Color(0xFFF3A73F),
    'Resuelto': Color(0xFF35E6B5),
  };

  static const reportStatusIcons = {
    'Pendiente': Icons.error_outline_rounded,
    'En revisión': Icons.hourglass_empty_rounded,
    'Resuelto': Icons.check_circle_rounded,
  };

  static const tripStatusColors = {
    'En curso': Color(0xFF35E6B5),
    'Por iniciar': Color(0xFFF3A73F),
  };
}
