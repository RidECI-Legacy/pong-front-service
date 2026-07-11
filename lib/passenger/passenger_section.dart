import 'package:flutter/material.dart';

/// The passenger dashboard's primary navigation destinations, shared by the
/// sidebar, the mobile bottom nav and the screen that swaps content.
enum PassengerSection {
  dashboard(Icons.grid_view_rounded, 'Dashboard'),
  search(Icons.search_rounded, 'Buscar Viajes'),
  reservations(Icons.event_available_rounded, 'Mis Reservas'),
  history(Icons.history_rounded, 'Historial'),
  favorites(Icons.star_rounded, 'Favoritos'),
  profile(Icons.person_rounded, 'Mi Perfil'),
  security(Icons.shield_rounded, 'Seguridad'),
  settings(Icons.settings_rounded, 'Configuración');

  final IconData icon;
  final String label;
  const PassengerSection(this.icon, this.label);
}
