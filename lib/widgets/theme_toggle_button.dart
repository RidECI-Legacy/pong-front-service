import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Button that flips the whole app between light and dark mode.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appThemeController,
      builder: (context, _) {
        final isDark = appThemeController.isDark;
        return Tooltip(
          message: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: appThemeController.toggle,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns:
                          Tween<double>(begin: 0.65, end: 1).animate(animation),
                      child: ScaleTransition(
                          scale: animation,
                          child:
                              FadeTransition(opacity: animation, child: child)),
                    ),
                    child: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      key: ValueKey(isDark),
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
