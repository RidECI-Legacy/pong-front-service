import 'package:flutter/material.dart';

/// The driver dashboard's primary navigation destinations, shared by the
/// sidebar, the mobile bottom nav and the screen that swaps content.
enum DriverSection {
  dashboard(Icons.grid_view_rounded, 'Inicio'),
  createTrip(Icons.add_road_rounded, 'Crear viaje'),
  myTrips(Icons.list_alt_rounded, 'Mis viajes'),
  vehicle(Icons.directions_car_filled_rounded, 'Mi vehículo'),
  stats(Icons.bar_chart_rounded, 'Estadísticas'),
  security(Icons.shield_rounded, 'Seguridad');

  final IconData icon;
  final String label;
  const DriverSection(this.icon, this.label);
}
