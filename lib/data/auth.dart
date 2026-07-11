import '../routing/app_router.dart';

class DemoAccount {
  final String email;
  final String name;
  final String routePath;
  final String roleLabel;

  const DemoAccount({
    required this.email,
    required this.name,
    required this.routePath,
    required this.roleLabel,
  });
}

class AuthResult {
  final bool success;
  final String? error;
  final DemoAccount? account;

  const AuthResult.ok(this.account) : success = true, error = null;
  const AuthResult.fail(this.error) : success = false, account = null;
}

class DemoAuth {
  DemoAuth._();

  static const accounts = [
    DemoAccount(
      email: 'pasajero.demo@mail.escuelaing.edu.co',
      name: 'María Camacho',
      routePath: AppRoutes.passenger,
      roleLabel: 'Pasajero',
    ),
    DemoAccount(
      email: 'conductor.demo@mail.escuelaing.edu.co',
      name: 'Camilo Rojas',
      routePath: AppRoutes.driver,
      roleLabel: 'Conductor',
    ),
    DemoAccount(
      email: 'admin.demo@escuelaing.edu.co',
      name: 'Administrador',
      routePath: AppRoutes.admin,
      roleLabel: 'Admin',
    ),
  ];

  static bool _hasInstitutionalDomain(String email) {
    final lower = email.trim().toLowerCase();
    return lower.endsWith('@escuelaing.edu.co') ||
        lower.endsWith('@mail.escuelaing.edu.co');
  }

  static AuthResult login(String email, String password) {
    final trimmed = email.trim();
    if (trimmed.isEmpty || password.isEmpty) {
      return const AuthResult.fail('Ingresa tu correo y contraseña.');
    }
    if (!_hasInstitutionalDomain(trimmed)) {
      return const AuthResult.fail(
        'Usa tu correo institucional @escuelaing.edu.co o @mail.escuelaing.edu.co.',
      );
    }
    for (final account in accounts) {
      if (account.email.toLowerCase() == trimmed.toLowerCase()) {
        return AuthResult.ok(account);
      }
    }
    return const AuthResult.fail(
      'Correo no reconocido. Usa una de las cuentas de prueba.',
    );
  }
}
