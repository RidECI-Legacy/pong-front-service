import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/auth.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/typography.dart';

/// Opens the institutional-login modal (glassmorphic, matches the new
/// landing aesthetic) reusing the existing [DemoAuth] flow so the rest of
/// the app (passenger/driver/admin routes) keeps working unchanged.
Future<void> showLoginDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) => const _LoginDialog(),
  );
}

class _LoginDialog extends StatefulWidget {
  const _LoginDialog();

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  bool _obscure = true;
  String? _error;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final result = DemoAuth.login(_emailController.text, _passwordController.text);
    if (!result.success) {
      setState(() => _error = result.error);
      return;
    }
    setState(() => _error = null);
    final path = result.account!.routePath;
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(path);
  }

  void _fillDemo(DemoAccount account) {
    _emailController.text = account.email;
    _passwordController.text = 'demo1234';
    setState(() => _error = null);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: LandingEffects.glassChild(
          radius: 24,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: LandingEffects.glassDecoration(radius: 24, tint: LandingColors.bgSurface.withValues(alpha: 0.92)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ingresar', style: LandingType.cardTitle(size: 22)),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, color: LandingColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ingresa con tu correo institucional para continuar.',
                    style: LandingType.body(size: 13.5),
                  ),
                  const SizedBox(height: 22),
                  _FieldLabel('Correo institucional'),
                  const SizedBox(height: 8),
                  _AuthField(controller: _emailController, hint: 'nombre@mail.escuelaing.edu.co'),
                  const SizedBox(height: 16),
                  _FieldLabel('Contraseña'),
                  const SizedBox(height: 8),
                  _AuthField(
                    controller: _passwordController,
                    hint: '••••••••',
                    obscureText: _obscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: LandingColors.textTertiary,
                        size: 18,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF06B54).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF06B54).withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.error_outline, size: 15, color: Color(0xFFF06B54)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Color(0xFFF06B54), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LandingColors.buttonGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _submit,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Center(child: Text('Entrar  →', style: LandingType.button())),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'CUENTAS DE PRUEBA',
                    style: LandingType.body(size: 10.5, color: LandingColors.textTertiary)
                        .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                  const SizedBox(height: 10),
                  for (final account in DemoAuth.accounts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: LandingColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _fillDemo(account),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: LandingColors.glassBorder),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: LandingColors.accent.withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    account.roleLabel,
                                    style: const TextStyle(color: LandingColors.accent, fontSize: 10.5, fontWeight: FontWeight.w700),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label, style: LandingType.body(size: 12.5, color: LandingColors.textSecondary));
  }
}

class _AuthField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const _AuthField({
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: LandingColors.textPrimary, fontSize: 13.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: LandingColors.textTertiary, fontSize: 13.5),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: LandingColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: LandingColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: LandingColors.accent, width: 1.5),
        ),
      ),
    );
  }
}
