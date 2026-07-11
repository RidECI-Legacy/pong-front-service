import 'package:flutter/material.dart';

import 'components/cta_section.dart';
import 'components/features_section.dart';
import 'components/footer_section.dart';
import 'components/hero_section.dart';
import 'components/how_it_works_section.dart';
import 'components/navbar.dart';
import 'components/security_section.dart';
import 'components/statistics_section.dart';
import 'theme/colors.dart';

/// The full RidECI marketing landing page: 7 sections assembled around a
/// single shared [ScrollController] so the navbar can react to scroll
/// position and each section can reveal itself as it enters the viewport.
class RidEciLandingPage extends StatefulWidget {
  const RidEciLandingPage({super.key});

  @override
  State<RidEciLandingPage> createState() => _RidEciLandingPageState();
}

class _RidEciLandingPageState extends State<RidEciLandingPage> {
  final _scrollController = ScrollController();

  final _heroKey = GlobalKey();
  final _featuresKey = GlobalKey();
  final _howItWorksKey = GlobalKey();
  final _securityKey = GlobalKey();
  final _footerKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handleNavTap(String label) {
    switch (label) {
      case 'Inicio':
        _scrollToTop();
        break;
      case 'Cómo funciona':
        _scrollToKey(_howItWorksKey);
        break;
      case 'Seguridad':
        _scrollToKey(_securityKey);
        break;
      case 'Beneficios':
        _scrollToKey(_featuresKey);
        break;
      case 'FAQ':
        _scrollToKey(_footerKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LandingColors.bgDeepest,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  key: _heroKey,
                  child: HeroSection(onSeeHowItWorks: () => _scrollToKey(_howItWorksKey)),
                ),
                Container(key: _featuresKey, child: FeaturesSection(scrollController: _scrollController)),
                Container(key: _howItWorksKey, child: HowItWorksSection(scrollController: _scrollController)),
                Container(key: _securityKey, child: SecuritySection(scrollController: _scrollController)),
                StatisticsSection(scrollController: _scrollController),
                CtaSection(onLearnMore: () => _scrollToKey(_featuresKey)),
                Container(key: _footerKey, child: FooterSection(onNavTap: _handleNavTap)),
              ],
            ),
          ),
          // Pinned overlay so the navbar stays visible (and blurs) while the
          // rest of the page scrolls underneath it.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LandingNavbar(controller: _scrollController, onNavTap: _handleNavTap),
          ),
        ],
      ),
    );
  }
}
