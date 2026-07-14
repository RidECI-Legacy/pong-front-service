import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import 'community_rating_card.dart';
import 'security_card.dart';
import 'statistic_card.dart';

enum _InsightTab { community, security, impact }

/// Consolidates "Reputación en la comunidad", "Seguridad" and "Impacto
/// sostenible" — three previously stacked full-width cards — into a single
/// switchable panel. Cuts how much the dashboard forces you to scroll
/// through while keeping every metric one tap away (Nielsen: aesthetic &
/// minimalist design, user control and freedom).
class DashboardInsightsTabs extends StatefulWidget {
  final RiderProfile rider;
  final VoidCallback onEmergency;
  final VoidCallback onReport;
  final VoidCallback onOpenSecurityCenter;

  const DashboardInsightsTabs({
    super.key,
    required this.rider,
    required this.onEmergency,
    required this.onReport,
    required this.onOpenSecurityCenter,
  });

  @override
  State<DashboardInsightsTabs> createState() => _DashboardInsightsTabsState();
}

class _DashboardInsightsTabsState extends State<DashboardInsightsTabs> {
  _InsightTab _tab = _InsightTab.community;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabSwitcher(selected: _tab, onSelect: (t) => setState(() => _tab = t)),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.03), end: Offset.zero).animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(key: ValueKey(_tab), child: _panelFor(_tab)),
        ),
      ],
    );
  }

  Widget _panelFor(_InsightTab tab) {
    switch (tab) {
      case _InsightTab.community:
        return CommunityRatingCard(
          rating: widget.rider.rating,
          completedRides: widget.rider.trips,
          reviews: const [
            ReviewSnippet(author: 'Camilo Rojas', rating: 5, comment: 'Excelente pasajera, muy puntual.'),
            ReviewSnippet(author: 'Valentina Ruiz', rating: 4.8, comment: 'Buena comunicación durante el viaje.'),
          ],
        );
      case _InsightTab.security:
        return SecurityCard(
          onEmergency: widget.onEmergency,
          onReport: widget.onReport,
          onOpenCenter: widget.onOpenSecurityCenter,
        );
      case _InsightTab.impact:
        return StatisticCard(
          title: 'Tu impacto sostenible',
          icon: Icons.eco_rounded,
          stats: [
            StatEntry(icon: Icons.eco_rounded, value: widget.rider.co2Kg, suffix: 'kg', label: 'CO₂ ahorrado'),
            StatEntry(icon: Icons.savings_rounded, value: widget.rider.savedCop ~/ 1000, suffix: 'k', label: 'Dinero ahorrado'),
            StatEntry(icon: Icons.directions_car_rounded, value: widget.rider.trips, label: 'Viajes compartidos'),
            StatEntry(icon: Icons.groups_rounded, value: 412, suffix: '+', label: 'Comunidad activa'),
          ],
        );
    }
  }
}

class _TabSwitcher extends StatelessWidget {
  final _InsightTab selected;
  final ValueChanged<_InsightTab> onSelect;
  const _TabSwitcher({required this.selected, required this.onSelect});

  static const _tabs = [
    _InsightTab.community,
    _InsightTab.security,
    _InsightTab.impact,
  ];
  static const _icons = {
    _InsightTab.community: Icons.emoji_events_rounded,
    _InsightTab.security: Icons.shield_rounded,
    _InsightTab.impact: Icons.eco_rounded,
  };
  static const _labels = {
    _InsightTab.community: 'Comunidad',
    _InsightTab.security: 'Seguridad',
    _InsightTab.impact: 'Impacto',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LandingColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final tab in _tabs)
            _TabButton(
              icon: _icons[tab]!,
              label: _labels[tab]!,
              active: selected == tab,
              onTap: () => onSelect(tab),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.active
                ? LandingColors.primary.withValues(alpha: 0.18)
                : (_hover ? Colors.white.withValues(alpha: 0.04) : Colors.transparent),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 15, color: widget.active ? LandingColors.primaryLight : LandingColors.textTertiary),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: widget.active ? LandingColors.textPrimary : LandingColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
