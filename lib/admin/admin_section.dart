import 'package:flutter/material.dart';

/// The admin dashboard's primary navigation destinations, shared by the
/// sidebar, the mobile bottom nav and the screen that swaps content.
enum AdminSection {
  validations(Icons.verified_user_rounded, 'Validaciones'),
  trips(Icons.alt_route_rounded, 'Viajes activos'),
  reports(Icons.flag_rounded, 'Reportes'),
  stats(Icons.query_stats_rounded, 'Estadísticas'),
  users(Icons.groups_rounded, 'Usuarios'),
  institutional(Icons.summarize_rounded, 'Institucional');

  final IconData icon;
  final String label;
  const AdminSection(this.icon, this.label);
}
