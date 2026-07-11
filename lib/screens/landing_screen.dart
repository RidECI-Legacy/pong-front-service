import 'package:flutter/material.dart';

import '../landing/landing_page.dart';

/// Entry point kept for the router: the actual premium landing page lives
/// under lib/landing/ (components/, theme/, landing_page.dart) per the
/// RidECI landing spec.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RidEciLandingPage();
  }
}
