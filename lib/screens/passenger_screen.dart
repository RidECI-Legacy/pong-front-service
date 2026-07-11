import 'package:flutter/material.dart';

import '../passenger/passenger_dashboard_screen.dart';

/// Entry point kept for the router: the actual premium passenger dashboard
/// lives under lib/passenger/ (components/, sections/, theme.dart) and
/// reuses the RidECI landing design system for full visual consistency.
class PassengerScreen extends StatelessWidget {
  const PassengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PassengerDashboardScreen();
  }
}
