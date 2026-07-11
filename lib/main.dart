import 'package:flutter/material.dart';

import 'routing/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RideEciApp());
}

class RideEciApp extends StatelessWidget {
  const RideEciApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appThemeController,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'RidECI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeFor(appThemeController.isDark),
          routerConfig: appRouter,
        );
      },
    );
  }
}
