import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../landing/theme/effects.dart';
import '../../landing/theme/typography.dart';
import '../../routing/app_router.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_glass_card.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/liquid_step_switcher.dart';
import '../widgets/step_illustration.dart';
import '../widgets/step_progress.dart';
import 'register_data.dart';
import 'steps/step_academic.dart';
import 'steps/step_account.dart';
import 'steps/step_personal.dart';
import 'steps/step_summary.dart';
import 'steps/step_vehicle.dart';

enum _StepKind { personal, academic, vehicle, account, summary }

class _StepMeta {
  final _StepKind kind;
  final String shortLabel;
  final String cardTitle;
  final String cardSubtitle;
  final List<String> headline;
  final String leftSubtitle;
  final String illustration;

  const _StepMeta({
    required this.kind,
    required this.shortLabel,
    required this.cardTitle,
    required this.cardSubtitle,
    required this.headline,
    required this.leftSubtitle,
    required this.illustration,
  });
}

const _kFeatureBullets = [
  'Solo para la comunidad ECI',
  'Conductores con antecedentes verificados',
  'Sistema de reputación y badges',
  'Rastrea tu impacto ambiental',
  'Registro gratuito sin tarjeta',
];

/// Single-route, multi-stage registration wizard. Nothing here ever
/// navigates to a new page mid-flow — [LiquidStepSwitcher] morphs the glass
/// card content in place, "liquid glass" style, as the user advances.
/// Picking "Conductor" in step 1 inserts an extra "Vehículo" step, which is
/// how the passenger vs. driver registration paths diverge.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _data = RegisterData();
  int _stepIndex = 0;
  Map<String, String> _errors = {};
  bool _submitting = false;
  bool _submitted = false;

  final _fullNameCtrl = TextEditingController();
  final _cedulaCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _studentIdCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _cedulaCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _studentIdCtrl.dispose();
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _plateCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  List<_StepMeta> get _steps => [
        const _StepMeta(
          kind: _StepKind.personal,
          shortLabel: 'Personal',
          cardTitle: 'Datos personales',
          cardSubtitle: 'Información básica para crear tu perfil en RidECI',
          headline: ['Únete a', 'la comunidad', 'ECI.'],
          leftSubtitle:
              'Crea tu cuenta en minutos y conecta con conductores y pasajeros verificados de la Escuela Colombiana de Ingeniería.',
          illustration: 'assets/illustrations/step_register.svg',
        ),
        const _StepMeta(
          kind: _StepKind.academic,
          shortLabel: 'Académico',
          cardTitle: 'Datos académicos',
          cardSubtitle: 'Verificamos que seas parte de la comunidad ECI',
          headline: ['Tu', 'información', 'académica.'],
          leftSubtitle:
              'Esta información nos permite verificar que perteneces a la comunidad de la Escuela Colombiana de Ingeniería.',
          illustration: 'assets/illustrations/step_register.svg',
        ),
        if (_data.isDriver)
          const _StepMeta(
            kind: _StepKind.vehicle,
            shortLabel: 'Vehículo',
            cardTitle: 'Datos del vehículo',
            cardSubtitle: 'Así lo verán tus pasajeros al confirmar el viaje',
            headline: ['Cuéntanos de', 'tu', 'vehículo.'],
            leftSubtitle:
                'Verificamos que tu vehículo cumpla los requisitos para ofrecer viajes seguros dentro de la comunidad ECI.',
            illustration: 'assets/illustrations/step_match.svg',
          ),
        const _StepMeta(
          kind: _StepKind.account,
          shortLabel: 'Cuenta',
          cardTitle: 'Seguridad de la cuenta',
          cardSubtitle: 'Crea una contraseña segura para proteger tu cuenta',
          headline: ['Asegura', 'tu cuenta', 'RidECI.'],
          leftSubtitle:
              'Crea una contraseña segura para proteger tu cuenta. La usarás junto con tu correo institucional para ingresar.',
          illustration: 'assets/illustrations/step_match.svg',
        ),
        const _StepMeta(
          kind: _StepKind.summary,
          shortLabel: 'Confirmación',
          cardTitle: 'Resumen de tu solicitud',
          cardSubtitle: 'Verifica que toda tu información sea correcta',
          headline: ['¡Ya casi', 'estás', 'dentro!'],
          leftSubtitle:
              'Revisa tu información antes de enviar la solicitud. Un administrador de la ECI validará tu cuenta en las próximas 24 horas.',
          illustration: 'assets/illustrations/step_ride.svg',
        ),
      ];

  bool _isInstitutionalEmail(String email) {
    final lower = email.trim().toLowerCase();
    return lower.endsWith('@escuelaing.edu.co') ||
        lower.endsWith('@mail.escuelaing.edu.co');
  }

  Map<String, String> _validate(_StepKind kind) {
    final errors = <String, String>{};
    switch (kind) {
      case _StepKind.personal:
        if (_data.fullName.trim().length < 3) {
          errors['fullName'] = 'Ingresa tu nombre completo.';
        }
        if (_data.cedula.trim().length < 6) {
          errors['cedula'] = 'Cédula inválida.';
        }
        if (_data.phone.trim().length < 7) {
          errors['phone'] = 'Teléfono inválido.';
        }
        if (!_isInstitutionalEmail(_data.email)) {
          errors['email'] = 'Usa tu correo institucional @escuelaing.edu.co.';
        }
        if (_data.role == null) {
          errors['role'] = 'Selecciona con qué rol quieres unirte.';
        }
        break;
      case _StepKind.academic:
        if (_data.studentId.trim().length < 4) {
          errors['studentId'] = 'Ingresa tu carné o ID ECI.';
        }
        if (_data.program == null) {
          errors['program'] = 'Selecciona tu programa.';
        }
        if (_data.semester == null) {
          errors['semester'] = 'Selecciona tu semestre.';
        }
        if (_data.affiliation == null) {
          errors['affiliation'] = 'Selecciona tu tipo de vinculación.';
        }
        break;
      case _StepKind.vehicle:
        if (_data.vehicleColor == null) {
          errors['vehicleColor'] = 'Selecciona el color de tu vehículo.';
        }
        if (_data.vehicleBrand.trim().isEmpty) {
          errors['vehicleBrand'] = 'Ingresa la marca.';
        }
        if (_data.vehicleModel.trim().isEmpty) {
          errors['vehicleModel'] = 'Ingresa el modelo.';
        }
        if (_data.plate.trim().length < 5) {
          errors['plate'] = 'Placa inválida.';
        }
        if (_data.soatExpiry.isEmpty) {
          errors['soatExpiry'] = 'Selecciona la vigencia del SOAT.';
        }
        break;
      case _StepKind.account:
        if (_data.password.length < 8) {
          errors['password'] = 'Mínimo 8 caracteres.';
        }
        if (_data.confirmPassword != _data.password || _data.password.isEmpty) {
          errors['confirmPassword'] = 'Las contraseñas no coinciden.';
        }
        break;
      case _StepKind.summary:
        break;
    }
    return errors;
  }

  void _goNext() {
    final steps = _steps;
    final errors = _validate(steps[_stepIndex].kind);
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }
    setState(() {
      _errors = {};
      if (_stepIndex < steps.length - 1) _stepIndex++;
    });
  }

  void _goBack() {
    if (_stepIndex == 0) return;
    setState(() {
      _errors = {};
      _stepIndex--;
    });
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  void _goToLogin(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.landing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;
    if (_stepIndex >= steps.length) _stepIndex = steps.length - 1;
    final current = steps[_stepIndex];

    return AuthScaffold(
      leftPanel: _LeftPanel(
          meta: current,
          stepIndex: _stepIndex,
          steps: steps,
          submitted: _submitted),
      card: AuthGlassCard(
        maxWidth: 480,
        child: _submitted
            ? _SuccessContent(onGoHome: () => context.go(AppRoutes.landing))
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepProgress(
                      labels: [for (final s in steps) s.shortLabel],
                      currentIndex: _stepIndex),
                  const SizedBox(height: 22),
                  LiquidStepSwitcher(
                    stepKey: '${current.kind}-${steps.length}',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(current.cardTitle,
                            style: LandingType.cardTitle(size: 21)),
                        const SizedBox(height: 4),
                        Text(current.cardSubtitle,
                            style: LandingType.body(size: 12.5)),
                        const SizedBox(height: 20),
                        _buildStepBody(current.kind),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      if (_stepIndex > 0) ...[
                        AuthGhostButton(
                            label: 'Atrás',
                            leadingIcon: Icons.arrow_back_rounded,
                            onTap: _goBack),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: current.kind == _StepKind.summary
                            ? AuthPrimaryButton(
                                label: 'Enviar solicitud de registro',
                                trailingIcon:
                                    Icons.check_circle_outline_rounded,
                                loading: _submitting,
                                onTap: _submit,
                              )
                            : AuthPrimaryButton(
                                label:
                                    'Siguiente → ${steps[_stepIndex + 1].shortLabel}',
                                onTap: _goNext,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('¿Ya tienes cuenta? ',
                            style: LandingType.body(size: 12.5)),
                        AuthTextLink(
                            label: 'Inicia sesión',
                            onTap: () => _goToLogin(context)),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStepBody(_StepKind kind) {
    switch (kind) {
      case _StepKind.personal:
        return StepPersonal(
          data: _data,
          errors: _errors,
          fullNameCtrl: _fullNameCtrl,
          cedulaCtrl: _cedulaCtrl,
          phoneCtrl: _phoneCtrl,
          emailCtrl: _emailCtrl,
          onChanged: () => setState(() {}),
        );
      case _StepKind.academic:
        return StepAcademic(
          data: _data,
          errors: _errors,
          studentIdCtrl: _studentIdCtrl,
          onChanged: () => setState(() {}),
        );
      case _StepKind.vehicle:
        return StepVehicle(
          data: _data,
          errors: _errors,
          brandCtrl: _brandCtrl,
          modelCtrl: _modelCtrl,
          plateCtrl: _plateCtrl,
          onChanged: () => setState(() {}),
        );
      case _StepKind.account:
        return StepAccount(
          data: _data,
          errors: _errors,
          passwordCtrl: _passwordCtrl,
          confirmCtrl: _confirmCtrl,
          onChanged: () => setState(() {}),
        );
      case _StepKind.summary:
        return StepSummary(data: _data);
    }
  }
}

class _LeftPanel extends StatelessWidget {
  final _StepMeta meta;
  final int stepIndex;
  final List<_StepMeta> steps;
  final bool submitted;

  const _LeftPanel(
      {required this.meta,
      required this.stepIndex,
      required this.steps,
      required this.submitted});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AuthLogo(),
        const SizedBox(height: 44),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          child: LayoutBuilder(
            key: ValueKey(meta.headline.join()),
            builder: (context, constraints) {
              final text = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < meta.headline.length; i++)
                    i == meta.headline.length - 1
                        ? LandingEffects.gradientText(meta.headline[i],
                            style: LandingType.heroHeadline(size: 48),
                            gradient: AuthColors.heroGradient)
                        : Text(meta.headline[i],
                            style: LandingType.heroHeadline(size: 48)),
                  const SizedBox(height: 20),
                  Text(meta.leftSubtitle, style: LandingType.body(size: 15.5)),
                ],
              );
              final illustration = StepIllustration(asset: meta.illustration);
              if (constraints.maxWidth >= 480) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: text),
                    const SizedBox(width: 28),
                    illustration,
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text,
                  const SizedBox(height: 28),
                  illustration,
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        if (stepIndex == 0 && !submitted)
          for (final bullet in _kFeatureBullets) _FeatureRow(label: bullet)
        else
          for (var i = 0; i < steps.length; i++)
            _ProgressRow(
              label: submitted
                  ? steps[i].shortLabel
                  : i < stepIndex
                      ? 'Paso ${i + 1} completo — ${steps[i].cardTitle}'
                      : i == stepIndex
                          ? '${steps[i].cardTitle} (ahora)'
                          : steps[i].cardTitle,
              state: submitted || i < stepIndex
                  ? _RowState.done
                  : i == stepIndex
                      ? _RowState.current
                      : _RowState.upcoming,
            ),
      ],
    );
  }
}

enum _RowState { done, current, upcoming }

class _FeatureRow extends StatelessWidget {
  final String label;
  const _FeatureRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
                color: AuthColors.primary.withValues(alpha: 0.16),
                shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded,
                size: 13, color: AuthColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: LandingType.body(size: 13.5))),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final _RowState state;
  const _ProgressRow({required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDone = state == _RowState.done;
    final isCurrent = state == _RowState.current;
    final color =
        isDone || isCurrent ? AuthColors.primary : AuthColors.textMuted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isDone
                  ? AuthColors.primary.withValues(alpha: 0.16)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: isCurrent ? AuthColors.primary : AuthColors.border),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded,
                    size: 13, color: AuthColors.primary)
                : isCurrent
                    ? const Icon(Icons.arrow_forward_rounded,
                        size: 12, color: AuthColors.primary)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: LandingType.body(size: 13.5, color: color).copyWith(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  final VoidCallback onGoHome;
  const _SuccessContent({required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
              color: AuthColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 34),
        ),
        const SizedBox(height: 20),
        Text('¡Solicitud enviada!',
            style: LandingType.cardTitle(size: 21),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Un administrador de la ECI revisará tu información. Te avisaremos por correo cuando tu cuenta esté lista.',
          style: LandingType.body(size: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AuthPrimaryButton(
            label: 'Ir al inicio',
            onTap: onGoHome,
            trailingIcon: Icons.arrow_forward_rounded),
      ],
    );
  }
}
