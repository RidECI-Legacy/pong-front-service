import 'package:flutter/material.dart';

import '../driver/driver_dashboard_screen.dart';

/// Entry point kept for the router: the actual premium driver dashboard
/// lives under lib/driver/ (components/, sections/) and reuses the
/// RidECI landing design system for full visual consistency with the
/// passenger dashboard.
class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DriverDashboardScreen();
  }
}
