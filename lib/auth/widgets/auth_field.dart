import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../landing/theme/typography.dart';
import '../theme/auth_colors.dart';

/// Labeled field shell shared by [AuthTextField] and [AuthDropdownField]:
/// uppercase caption label (+ optional required marker), helper text below,
/// and an animated error message that fades in without shifting the layout.
class AuthFieldShell extends StatelessWidget {
  final String label;
  final bool required;
  final String? helperText;
  final String? errorText;
  final Widget child;

  const AuthFieldShell({
    super.key,
    required this.label,
    required this.child,
    this.required = true,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: LandingType.body(size: 10.5, color: AuthColors.textMuted).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
            children: [
              TextSpan(text: label.toUpperCase()),
              if (required) const TextSpan(text: ' *', style: TextStyle(color: AuthColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 7),
        child,
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 13, color: AuthColors.danger),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: AuthColors.danger, fontSize: 11.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
              : (helperText != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(helperText!, style: LandingType.body(size: 11, color: AuthColors.textMuted)),
                    )
                  : const SizedBox.shrink()),
        ),
      ],
    );
  }
}

InputDecoration authInputDecoration({required String hint, bool hasError = false, Widget? suffixIcon, Widget? prefixIcon}) {
  final borderColor = hasError ? AuthColors.danger.withValues(alpha: 0.6) : AuthColors.glassBorder;
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AuthColors.textDisabled, fontSize: 13.5),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.03),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: hasError ? AuthColors.danger : AuthColors.primary, width: 1.5),
    ),
  );
}

/// Text input field styled to the auth glass card (56px height per
/// `DesignSystem.md` input spec, 14px radius).
class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool required;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.required = true,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return AuthFieldShell(
      label: label,
      required: required,
      helperText: helperText,
      errorText: errorText,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        style: const TextStyle(color: AuthColors.textPrimary, fontSize: 13.5),
        decoration: authInputDecoration(hint: hint, hasError: hasError, suffixIcon: suffixIcon),
      ),
    );
  }
}

/// Dropdown ("select") field styled to match [AuthTextField].
class AuthDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final bool required;
  final String? helperText;
  final String? errorText;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  const AuthDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.required = true,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return AuthFieldShell(
      label: label,
      required: required,
      helperText: helperText,
      errorText: errorText,
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AuthColors.textMuted),
        dropdownColor: AuthColors.modal,
        borderRadius: BorderRadius.circular(14),
        style: const TextStyle(color: AuthColors.textPrimary, fontSize: 13.5),
        decoration: authInputDecoration(hint: hint, hasError: hasError),
        hint: Text(hint, style: const TextStyle(color: AuthColors.textDisabled, fontSize: 13.5)),
        items: [
          for (final option in options) DropdownMenuItem(value: option, child: Text(labelOf(option))),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
