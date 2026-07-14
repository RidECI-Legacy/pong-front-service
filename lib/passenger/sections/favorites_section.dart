import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../components/empty_state.dart';
import '../components/favorite_driver_card.dart';
import '../components/search_field.dart';
import '../components/section_title.dart';
import '../passenger_actions.dart';
import '../passenger_mock_helpers.dart';
import '../theme.dart';

enum _SortMode { rating, trips, name }

/// SECTION "Favoritos": a search + sort toolbar, an at-a-glance stats strip
/// and an interactive grid of favorite drivers. Unfavoriting is reversible
/// ("Deshacer"), each card offers a one-tap message action, and cards enter
/// with a staggered fade + slide so the screen feels alive instead of a
/// static list (Nielsen: visibility of status, user control & freedom,
/// recognition rather than recall, aesthetic & minimalist design).
class FavoritesSection extends StatefulWidget {
  const FavoritesSection({super.key});

  @override
  State<FavoritesSection> createState() => _FavoritesSectionState();
}

class _FavoritesSectionState extends State<FavoritesSection> {
  late final List<FavoriteDriverEntry> _favorites = PassengerMockHelpers.favoriteDrivers();
  String _query = '';
  _SortMode _sort = _SortMode.rating;

  List<FavoriteDriverEntry> get _visible {
    final list = _favorites.where((e) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return e.driver.driverName.toLowerCase().contains(q) || e.driver.car.toLowerCase().contains(q);
    }).toList();

    switch (_sort) {
      case _SortMode.rating:
        list.sort((a, b) => b.driver.rating.compareTo(a.driver.rating));
      case _SortMode.trips:
        list.sort((a, b) => b.tripsTogether.compareTo(a.tripsTogether));
      case _SortMode.name:
        list.sort((a, b) => a.driver.driverName.compareTo(b.driver.driverName));
    }
    return list;
  }

  void _removeFavorite(FavoriteDriverEntry entry) {
    final index = _favorites.indexOf(entry);
    if (index == -1) return;
    setState(() => _favorites.removeAt(index));
    showActionSnack(
      context,
      '${entry.driver.driverName} se quitó de tus favoritos.',
      icon: Icons.star_border_rounded,
      action: SnackBarAction(
        label: 'Deshacer',
        textColor: LandingColors.accent,
        onPressed: () {
          if (!mounted) return;
          setState(() => _favorites.insert(index.clamp(0, _favorites.length), entry));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final total = _favorites.length;
    final avgRating = total == 0 ? 0.0 : _favorites.map((e) => e.driver.rating).reduce((a, b) => a + b) / total;
    final totalTrips = _favorites.fold<int>(0, (sum, e) => sum + e.tripsTogether);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: Icons.star_rounded,
          title: 'Conductores favoritos',
          subtitle: total == 0
              ? 'Aún no tienes conductores guardados'
              : '$total conductor${total == 1 ? '' : 'es'} guardado${total == 1 ? '' : 's'} para encontrarlos rápido',
          accent: const Color(0xFFFBBF24),
        ),
        if (total > 0) ...[
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatChip(icon: Icons.star_rounded, value: '$total', label: 'Favoritos', color: LandingColors.accent),
              _StatChip(icon: Icons.grade_rounded, value: avgRating.toStringAsFixed(1), label: 'Calificación prom.', color: const Color(0xFFFBBF24)),
              _StatChip(icon: Icons.route_rounded, value: '$totalTrips', label: 'Viajes juntos', color: LandingColors.success),
            ],
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.12, curve: Curves.easeOutCubic),
          const SizedBox(height: 22),
          LayoutBuilder(builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 560;
            final search = SearchField(
              label: 'Buscar',
              icon: Icons.search_rounded,
              hint: 'Nombre o vehículo…',
              onChanged: (v) => setState(() => _query = v),
            );
            final sort = _SortSwitcher(selected: _sort, onSelect: (s) => setState(() => _sort = s));
            if (isNarrow) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [search, const SizedBox(height: 12), sort]);
            }
            return Row(
              children: [
                Expanded(child: search),
                const SizedBox(width: 12),
                sort,
              ],
            );
          }).animate().fadeIn(duration: 300.ms, delay: 60.ms).slideY(begin: 0.12, curve: Curves.easeOutCubic),
          const SizedBox(height: 24),
        ] else
          const SizedBox(height: 16),
        if (total == 0)
          const EmptyState(
            icon: Icons.star_border_rounded,
            title: 'Aún no tienes conductores favoritos',
            description: 'Marca como favorito a los conductores con los que más viajas para encontrarlos rápido y escribirles en un tap.',
          )
        else if (visible.isEmpty)
          EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Sin resultados',
            description: 'Ningún favorito coincide con "$_query". Intenta con otro nombre o vehículo.',
            actionLabel: 'Limpiar búsqueda',
            onAction: () => setState(() => _query = ''),
          )
        else
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (var i = 0; i < visible.length; i++)
                FavoriteDriverCard(
                  key: ValueKey(visible[i].driver.driverName),
                  entry: visible[i],
                  onViewProfile: () => showActionSnack(context, 'Abriendo el perfil de ${visible[i].driver.driverName}.'),
                  onMessage: () => showTripChatDialog(context, withName: visible[i].driver.driverName),
                  onToggleFavorite: () => _removeFavorite(visible[i]),
                ).animate(delay: (40 * i).ms).fadeIn(duration: 320.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic),
            ],
          ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatChip({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: LandingColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 15, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value, style: LandingType.cardTitle(size: 15)),
                  Text(label, style: LandingType.body(size: 10, color: LandingColors.textTertiary), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortSwitcher extends StatelessWidget {
  final _SortMode selected;
  final ValueChanged<_SortMode> onSelect;
  const _SortSwitcher({required this.selected, required this.onSelect});

  static const _modes = [_SortMode.rating, _SortMode.trips, _SortMode.name];
  static const _icons = {
    _SortMode.rating: Icons.star_rounded,
    _SortMode.trips: Icons.route_rounded,
    _SortMode.name: Icons.sort_by_alpha_rounded,
  };
  static const _labels = {
    _SortMode.rating: 'Calificación',
    _SortMode.trips: 'Viajes',
    _SortMode.name: 'Nombre',
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
          for (final mode in _modes)
            _SortButton(
              icon: _icons[mode]!,
              label: _labels[mode]!,
              active: selected == mode,
              onTap: () => onSelect(mode),
            ),
        ],
      ),
    );
  }
}

class _SortButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SortButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  State<_SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<_SortButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(
        message: 'Ordenar por ${widget.label.toLowerCase()}',
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.active
                  ? LandingColors.primary.withValues(alpha: 0.18)
                  : (_hover ? Colors.white.withValues(alpha: 0.04) : Colors.transparent),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: widget.active ? LandingColors.primaryLight : LandingColors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: widget.active ? LandingColors.textPrimary : LandingColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
