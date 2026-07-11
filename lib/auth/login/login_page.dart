import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/auth.dart';
import '../../landing/theme/effects.dart';
import '../../landing/theme/typography.dart';
import '../../routing/app_router.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_glass_card.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/step_illustration.dart';

/// Full-page login screen sharing the same "liquid glass" shell as the
/// register wizard and password recovery flow (`AuthScaffold` +
/// `AuthGlassCard`), replacing the old landing-page modal dialog. Keeps the
/// demo-account quick-access shortcuts from the dialog so testing the three
/// roles still takes one click.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscure = true;
  String? _error;
  bool _submitting = false;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _submitting = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final result = DemoAuth.login(_emailCtrl.text, _passwordCtrl.text);
    if (!result.success) {
      setState(() {
        _submitting = false;
        _error = result.error;
      });
      return;
    }
    context.go(result.account!.routePath);
  }

  void _fillDemo(DemoAccount account) {
    _emailCtrl.text = account.email;
    _passwordCtrl.text = 'demo1234';
    setState(() => _error = null);
  }

  void _goToRegister() => context.push(AppRoutes.register);

  void _goToForgotPassword() => context.push(AppRoutes.forgotPassword);

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      leftPanel: _LeftPanel(),
      card: AuthGlassCard(
        maxWidth: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inicia sesión', style: LandingType.cardTitle(size: 21)),
            const SizedBox(height: 4),
            Text('Ingresa con tu correo institucional para continuar.',
                style: LandingType.body(size: 12.5)),
            const SizedBox(height: 22),
            AuthTextField(
              label: 'Correo institucional',
              hint: 'nombre@mail.escuelaing.edu.co',
              keyboardType: TextInputType.emailAddress,
              controller: _emailCtrl,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Contraseña',
              hint: '••••••••',
              obscureText: _obscure,
              controller: _passwordCtrl,
              onChanged: (_) => setState(() {}),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AuthColors.textMuted,
                  size: 18,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: AuthTextLink(
                label: '¿Olvidaste tu contraseña?',
                onTap: _goToForgotPassword,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AuthColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AuthColors.danger.withValues(alpha: 0.35)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 15, color: AuthColors.danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                            color: AuthColors.danger,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            AuthPrimaryButton(
              label: 'Entrar',
              trailingIcon: Icons.arrow_forward_rounded,
              loading: _submitting,
              onTap: _submit,
            ),
            const SizedBox(height: 22),
            Text(
              'CUENTAS DE PRUEBA',
              style: LandingType.body(size: 10.5, color: AuthColors.textMuted)
                  .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 10),
            for (final account in DemoAuth.accounts)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: AuthColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _fillDemo(account),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AuthColors.glassBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AuthColors.secondaryAccent
                                  .withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              account.roleLabel,
                              style: const TextStyle(
                                  color: AuthColors.secondaryAccent,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              account.email,
                              style: LandingType.body(size: 11.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 6),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text('¿No tienes cuenta? ', style: LandingType.body(size: 12.5)),
                  AuthTextLink(label: 'Crear cuenta', onTap: _goToRegister),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AuthLogo(),
        const SizedBox(height: 44),
        LayoutBuilder(
          builder: (context, constraints) {
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Bienvenido\nde nuevo a',
                    style: LandingType.heroHeadline(size: 48)),
                LandingEffects.gradientText('RidECI.',
                    style: LandingType.heroHeadline(size: 48),
                    gradient: AuthColors.heroGradient),
                const SizedBox(height: 20),
                Text(
                  'Ingresa con tu correo institucional para conectar con conductores y pasajeros verificados de la Escuela Colombiana de Ingeniería.',
                  style: LandingType.body(size: 15.5),
                ),
              ],
            );
            final illustration =
                const StepIllustration(asset: 'assets/illustrations/step_ride.svg');
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
      ],
    );
  }
}
