import '../../data/car_colors.dart';
import '../widgets/role_selector.dart';

/// Static option lists for the register wizard's dropdowns. Kept together
/// so the ECI-specific vocabulary (programs, zones, affiliations) lives in
/// one obvious place.
class RegisterOptions {
  RegisterOptions._();

  static const programs = [
    'Ingeniería de Sistemas',
    'Ingeniería Industrial',
    'Ingeniería Civil',
    'Ingeniería Electrónica',
    'Ingeniería Mecánica',
    'Ingeniería Mecatrónica',
    'Ingeniería Ambiental',
    'Ingeniería Biomédica',
    'Ingeniería Matemática',
    'Administración de Empresas',
    'Economía',
    'Otro',
  ];

  static const semesters = ['1°', '2°', '3°', '4°', '5°', '6°', '7°', '8°', '9°', '10°', 'Egresado'];

  static const affiliations = ['Estudiante pregrado', 'Estudiante posgrado', 'Docente', 'Administrativo'];

  static const zones = [
    'Suba',
    'Usaquén',
    'Chapinero',
    'Engativá',
    'Fontibón',
    'Kennedy',
    'Teusaquillo',
    'Ciudad Bolívar',
    'Bosa',
    'Fuera de Bogotá',
  ];

  static const seatCapacities = [1, 2, 3, 4, 5, 6];
}

/// Mutable bag holding everything the wizard collects across its steps.
/// Plain class (not a ChangeNotifier) — it's only ever mutated from within
/// the single [RegisterPage] State that owns it, which calls `setState`
/// itself after each field update.
class RegisterData {
  // Step 1 — Personal
  String fullName = '';
  String cedula = '';
  String phone = '';
  String email = '';
  RideRole? role;

  // Step 2 — Académico
  String studentId = '';
  String? program;
  String? semester;
  String? affiliation;
  String? zone;

  // Step 3 — Vehículo (conductor only)
  CarColor? vehicleColor;
  String vehicleBrand = '';
  String vehicleModel = '';
  String plate = '';
  int seatCapacity = 3;
  String soatExpiry = '';

  // Step — Cuenta
  String password = '';
  String confirmPassword = '';

  bool get isDriver => role == RideRole.conductor;
}
