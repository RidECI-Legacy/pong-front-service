import 'package:go_router/go_router.dart';

import '../screens/admin_screen.dart';
import '../screens/driver_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/passenger_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const landing = '/';
  static const passenger = '/pasajero';
  static const driver = '/conductor';
  static const admin = '/admin';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.landing,
  routes: [
    GoRoute(
      path: AppRoutes.landing,
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: AppRoutes.passenger,
      builder: (context, state) => const PassengerScreen(),
    ),
    GoRoute(
      path: AppRoutes.driver,
      builder: (context, state) => const DriverScreen(),
    ),
    GoRoute(
      path: AppRoutes.admin,
      builder: (context, state) => const AdminScreen(),
    ),
  ],
);
