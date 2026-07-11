import 'package:flutter/material.dart';

import '../theme.dart';

/// Rounded dark input with a leading icon, floating label and an animated
/// focus glow — used by the top bar search and the trip search card.
class SearchField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData icon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchField({
    super.key,
    required this.label,
    required this.icon,
    this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _focused ? LandingColors.accent.withValues(alpha: 0.6) : LandingColors.glassBorder, width: _focused ? 1.5 : 1),
        boxShadow: _focused ? [BoxShadow(color: LandingColors.accent.withValues(alpha: 0.15), blurRadius: 16)] : null,
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 17, color: _focused ? LandingColors.accent : LandingColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.label.toUpperCase(), style: LandingType.body(size: 9.5, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly,
                  style: const TextStyle(color: LandingColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hint,
                    hintStyle: const TextStyle(color: LandingColors.textTertiary, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
