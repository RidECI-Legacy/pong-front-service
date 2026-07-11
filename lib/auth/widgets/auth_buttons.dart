import 'package:flutter/material.dart';

import '../../landing/theme/typography.dart';
import '../theme/auth_colors.dart';

/// Primary CTA — blue gradient fill (matches the landing page), morphs into a loading spinner while
/// [loading] is true (used for the final "Enviar solicitud" submit).
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final IconData? trailingIcon;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null || loading;
    return SizedBox(
      width: double.infinity,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: disabled && !loading ? 0.5 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AuthColors.buttonGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: AuthColors.primary.withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 8))
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: disabled ? null : onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: loading
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.4, color: Colors.white),
                          )
                        : Row(
                            key: const ValueKey('label'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(label,
                                  style: LandingType.button(color: Colors.white)
                                      .copyWith(fontWeight: FontWeight.w700)),
                              if (trailingIcon != null) ...[
                                const SizedBox(width: 8),
                                Icon(trailingIcon,
                                    size: 17, color: Colors.white),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined "back" button, matching the small pill in the Mocks.
class AuthGhostButton extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final VoidCallback? onTap;

  const AuthGhostButton(
      {super.key, required this.label, this.leadingIcon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuthColors.glassBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 16, color: AuthColors.textSecondary),
                  const SizedBox(width: 6),
                ],
                Text(label,
                    style: LandingType.body(
                            size: 13, color: AuthColors.textSecondary)
                        .copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small inline text-link button (e.g. "Inicia sesión", "Reenviar código").
/// Shows a pointer cursor and brightens/underlines on hover, same as any
/// other clickable control in the flow.
class AuthTextLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const AuthTextLink({super.key, required this.label, required this.onTap});

  @override
  State<AuthTextLink> createState() => _AuthTextLinkState();
}

class _AuthTextLinkState extends State<AuthTextLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            color: _hover ? AuthColors.primaryHover : AuthColors.primary,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            decoration: _hover ? TextDecoration.underline : TextDecoration.none,
            decorationColor: AuthColors.primaryHover,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
