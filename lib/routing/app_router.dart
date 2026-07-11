import 'package:go_router/go_router.dart';

import '../auth/forgot_password/forgot_password_page.dart';
import '../auth/register/register_page.dart';
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
  static const register = '/registro';
  static const forgotPassword = '/recuperar-password';
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
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
  ],
);
