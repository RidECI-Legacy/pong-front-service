import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/auth_colors.dart';

/// Six-box one-time-code input with auto-advance/auto-backspace between
/// boxes, used by the password recovery flow's verification stage.
class OtpCodeField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final bool hasError;

  const OtpCodeField({super.key, required this.onChanged, this.hasError = false});

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  static const _length = 6;
  late final List<TextEditingController> _controllers = List.generate(_length, (_) => TextEditingController());
  late final List<FocusNode> _nodes = List.generate(
    _length,
    (i) => FocusNode(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace && _controllers[i].text.isEmpty && i > 0) {
          _nodes[i - 1].requestFocus();
          _controllers[i - 1].clear();
          _emit();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    ),
  );

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _emit() {
    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _nodes[index + 1].requestFocus();
    }
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < _length; i++)
          SizedBox(
            width: 46,
            height: 56,
            child: TextField(
              controller: _controllers[i],
              focusNode: _nodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: AuthColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.hasError ? AuthColors.danger.withValues(alpha: 0.6) : AuthColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.hasError ? AuthColors.danger.withValues(alpha: 0.6) : AuthColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.hasError ? AuthColors.danger : AuthColors.primary, width: 1.5),
                ),
              ),
              onChanged: (v) => _onChanged(i, v),
            ),
          ),
      ],
    );
  }
}
