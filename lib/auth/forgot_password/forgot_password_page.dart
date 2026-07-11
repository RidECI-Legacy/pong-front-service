import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../landing/theme/effects.dart';
import '../../landing/theme/typography.dart';
import '../../routing/app_router.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_glass_card.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/liquid_step_switcher.dart';
import '../widgets/otp_code_field.dart';
import '../widgets/password_strength_bar.dart';
import '../widgets/step_illustration.dart';
import '../widgets/step_progress.dart';

enum _Stage { email, code, newPassword, done }

const _stageLabels = ['Correo', 'Verificación', 'Nueva contraseña'];

/// Password recovery — same single-route, in-place "liquid glass" stage
/// morphing as the register wizard, just a shorter, linear flow with no
/// passenger/driver branching: email → code → new password → done.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  _Stage _stage = _Stage.email;
  Map<String, String> _errors = {};
  bool _submitting = false;
  String _code = '';

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _isInstitutionalEmail(String email) {
    final lower = email.trim().toLowerCase();
    return lower.endsWith('@escuelaing.edu.co') ||
        lower.endsWith('@mail.escuelaing.edu.co');
  }

  Future<void> _advance() async {
    switch (_stage) {
      case _Stage.email:
        if (!_isInstitutionalEmail(_emailCtrl.text)) {
          setState(() => _errors = {
                'email': 'Usa tu correo institucional @escuelaing.edu.co.'
              });
          return;
        }
        setState(() {
          _errors = {};
          _submitting = true;
        });
        await Future.delayed(const Duration(milliseconds: 900));
        if (!mounted) return;
        setState(() {
          _submitting = false;
          _stage = _Stage.code;
        });
        break;
      case _Stage.code:
        if (_code.length != 6) {
          setState(() => _errors = {'code': 'Ingresa el código de 6 dígitos.'});
          return;
        }
        setState(() {
          _errors = {};
          _submitting = true;
        });
        await Future.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;
        setState(() {
          _submitting = false;
          _stage = _Stage.newPassword;
        });
        break;
      case _Stage.newPassword:
        final errors = <String, String>{};
        if (_passwordCtrl.text.length < 8) {
          errors['password'] = 'Mínimo 8 caracteres.';
        }
        if (_confirmCtrl.text != _passwordCtrl.text ||
            _passwordCtrl.text.isEmpty) {
          errors['confirmPassword'] = 'Las contraseñas no coinciden.';
        }
        if (errors.isNotEmpty) {
          setState(() => _errors = errors);
          return;
        }
        setState(() {
          _errors = {};
          _submitting = true;
        });
        await Future.delayed(const Duration(milliseconds: 900));
        if (!mounted) return;
        setState(() {
          _submitting = false;
          _stage = _Stage.done;
        });
        break;
      case _Stage.done:
        break;
    }
  }

  void _goBack() {
    setState(() {
      _errors = {};
      _stage = switch (_stage) {
        _Stage.code => _Stage.email,
        _Stage.newPassword => _Stage.code,
        _ => _stage,
      };
    });
  }

  int get _stageIndex => switch (_stage) {
        _Stage.email => 0,
        _Stage.code => 1,
        _Stage.newPassword => 2,
        _Stage.done => 2,
      };

  (String, String, String) get _copy => switch (_stage) {
        _Stage.email => (
            'Recupera tu\nacceso a\n',
            'Ingresa tu correo institucional y te enviaremos un código para restablecer tu contraseña.',
            'RidECI.',
          ),
        _Stage.code => (
            'Revisa tu\ncorreo\n',
            'Enviamos un código de 6 dígitos a tu correo institucional. Ingrésalo para continuar.',
            'electrónico.',
          ),
        _Stage.newPassword => (
            'Crea una\nnueva\n',
            'Elige una contraseña segura y diferente a las anteriores para proteger tu cuenta.',
            'contraseña.',
          ),
        _Stage.done => (
            '¡Contraseña\nactualizada\n',
            'Ya puedes iniciar sesión con tu nueva contraseña.',
            'con éxito!',
          ),
      };

  String get _illustration => switch (_stage) {
        _Stage.email => 'assets/illustrations/step_register.svg',
        _Stage.code => 'assets/illustrations/step_register.svg',
        _Stage.newPassword => 'assets/illustrations/step_match.svg',
        _Stage.done => 'assets/illustrations/step_ride.svg',
      };

  @override
  Widget build(BuildContext context) {
    final (headlineStart, subtitle, headlineEnd) = _copy;

    return AuthScaffold(
      leftPanel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthLogo(),
          const SizedBox(height: 44),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            child: LayoutBuilder(
              key: ValueKey(_stage),
              builder: (context, constraints) {
                final text = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(headlineStart,
                        style: LandingType.heroHeadline(size: 48)),
                    LandingEffects.gradientText(headlineEnd,
                        style: LandingType.heroHeadline(size: 48),
                        gradient: AuthColors.heroGradient),
                    const SizedBox(height: 20),
                    Text(subtitle, style: LandingType.body(size: 15.5)),
                  ],
                );
                final illustration = StepIllustration(asset: _illustration);
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
        ],
      ),
      card: AuthGlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_stage != _Stage.done) ...[
              StepProgress(labels: _stageLabels, currentIndex: _stageIndex),
              const SizedBox(height: 22),
            ],
            LiquidStepSwitcher(
              stepKey: _stage,
              child: _stage == _Stage.done ? _DoneContent() : _buildStageBody(),
            ),
            if (_stage != _Stage.done) ...[
              const SizedBox(height: 22),
              Row(
                children: [
                  if (_stage != _Stage.email) ...[
                    AuthGhostButton(
                        label: 'Atrás',
                        leadingIcon: Icons.arrow_back_rounded,
                        onTap: _goBack),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: AuthPrimaryButton(
                      label: switch (_stage) {
                        _Stage.email => 'Enviar código',
                        _Stage.code => 'Verificar código',
                        _Stage.newPassword => 'Guardar contraseña',
                        _Stage.done => '',
                      },
                      loading: _submitting,
                      onTap: _advance,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 22),
              AuthPrimaryButton(
                label: 'Ir a iniciar sesión',
                trailingIcon: Icons.arrow_forward_rounded,
                onTap: () => context.go(AppRoutes.landing),
              ),
            ],
            const SizedBox(height: 18),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text('¿Recordaste tu contraseña? ',
                      style: LandingType.body(size: 12.5)),
                  AuthTextLink(
                    label: 'Inicia sesión',
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRoutes.landing),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageBody() {
    switch (_stage) {
      case _Stage.email:
        return Column(
          key: const ValueKey('email-body'),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Recuperar contraseña',
                style: LandingType.cardTitle(size: 21)),
            const SizedBox(height: 4),
            Text('Ingresa el correo institucional asociado a tu cuenta.',
                style: LandingType.body(size: 12.5)),
            const SizedBox(height: 20),
            AuthTextField(
              label: 'Correo institucional',
              hint: 'nombre@mail.escuelaing.edu.co',
              keyboardType: TextInputType.emailAddress,
              controller: _emailCtrl,
              errorText: _errors['email'],
              onChanged: (_) => setState(() {}),
            ),
          ],
        );
      case _Stage.code:
        return Column(
          key: const ValueKey('code-body'),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Verifica tu identidad',
                style: LandingType.cardTitle(size: 21)),
            const SizedBox(height: 4),
            Text('Enviamos un código a ${_emailCtrl.text.trim()}',
                style: LandingType.body(size: 12.5)),
            const SizedBox(height: 20),
            OtpCodeField(
              hasError: _errors['code'] != null,
              onChanged: (v) {
                _code = v;
                setState(() {});
              },
            ),
            if (_errors['code'] != null) ...[
              const SizedBox(height: 10),
              Text(_errors['code']!,
                  style: const TextStyle(
                      color: AuthColors.danger,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Text('¿No llegó el código? ',
                    style: LandingType.body(size: 12)),
                AuthTextLink(label: 'Reenviar', onTap: () {}),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AuthColors.glassBorder),
              ),
              child: Text(
                'Modo demo: ingresa cualquier código de 6 dígitos para continuar.',
                style: LandingType.body(size: 11, color: AuthColors.textMuted),
              ),
            ),
          ],
        );
      case _Stage.newPassword:
        return Column(
          key: const ValueKey('password-body'),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Crea una nueva contraseña',
                style: LandingType.cardTitle(size: 21)),
            const SizedBox(height: 4),
            Text('Usa al menos 8 caracteres, combinando letras y números.',
                style: LandingType.body(size: 12.5)),
            const SizedBox(height: 20),
            AuthTextField(
              label: 'Nueva contraseña',
              hint: 'Mínimo 8 caracteres',
              obscureText: true,
              controller: _passwordCtrl,
              errorText: _errors['password'],
              onChanged: (_) => setState(() {}),
            ),
            PasswordStrengthBar(password: _passwordCtrl.text),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Confirmar contraseña',
              hint: 'Repite tu contraseña',
              obscureText: true,
              controller: _confirmCtrl,
              errorText: _errors['confirmPassword'],
              onChanged: (_) => setState(() {}),
            ),
          ],
        );
      case _Stage.done:
        return const SizedBox.shrink();
    }
  }
}

class _DoneContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('done-body'),
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
        Text('¡Contraseña actualizada!',
            style: LandingType.cardTitle(size: 21),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Tu contraseña se cambió con éxito. Ya puedes iniciar sesión con tus nuevas credenciales.',
          style: LandingType.body(size: 13),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
