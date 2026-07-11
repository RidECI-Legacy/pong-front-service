import 'package:flutter/material.dart';

import '../theme.dart';
import 'status_badge.dart';

/// A single ride-history row. Built by the screen from the app's mock data
/// (HistoryItem + the matching driver/vehicle), so this widget stays a pure
/// presentation component.
class HistoryRowData {
  final DateTime date;
  final String dateLabel;
  final String origin;
  final String destination;
  final String driver;
  final String vehicle;
  final int price;
  final TripStatus status;
  final double rating;

  const HistoryRowData({
    required this.date,
    required this.dateLabel,
    required this.origin,
    required this.destination,
    required this.driver,
    required this.vehicle,
    required this.price,
    required this.status,
    required this.rating,
  });
}

/// A modern, filterable, paginated ride-history table.
class HistoryTable extends StatefulWidget {
  final List<HistoryRowData> rows;
  const HistoryTable({super.key, required this.rows});

  @override
  State<HistoryTable> createState() => _HistoryTableState();
}

class _HistoryTableState extends State<HistoryTable> {
  static const _pageSize = 5;

  String _query = '';
  String _month = 'Todos';
  TripStatus? _status;
  int _page = 0;

  List<String> get _months {
    const names = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    final set = <String>{};
    for (final r in widget.rows) {
      set.add(names[r.date.month - 1]);
    }
    return ['Todos', ...set];
  }

  List<HistoryRowData> get _filtered {
    const names = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return widget.rows.where((r) {
      final matchesQuery = _query.isEmpty ||
          r.driver.toLowerCase().contains(_query.toLowerCase()) ||
          r.origin.toLowerCase().contains(_query.toLowerCase()) ||
          r.destination.toLowerCase().contains(_query.toLowerCase());
      final matchesMonth = _month == 'Todos' || names[r.date.month - 1] == _month;
      final matchesStatus = _status == null || r.status == _status;
      return matchesQuery && matchesMonth && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalPages = filtered.isEmpty ? 1 : ((filtered.length - 1) ~/ _pageSize) + 1;
    final page = _page.clamp(0, totalPages - 1);
    final pageRows = filtered.skip(page * _pageSize).take(_pageSize).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: 220,
              child: TextField(
                onChanged: (v) => setState(() {
                  _query = v;
                  _page = 0;
                }),
                style: const TextStyle(color: LandingColors.textPrimary, fontSize: 12.5),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Buscar conductor o ruta…',
                  hintStyle: const TextStyle(color: LandingColors.textTertiary, fontSize: 12.5),
                  prefixIcon: const Icon(Icons.search_rounded, size: 17, color: LandingColors.textTertiary),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.03),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LandingColors.glassBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LandingColors.glassBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LandingColors.accent, width: 1.4)),
                ),
              ),
            ),
            _FilterDropdown<String>(
              value: _month,
              items: _months,
              labelFor: (m) => m,
              onChanged: (v) => setState(() {
                _month = v;
                _page = 0;
              }),
            ),
            _FilterDropdown<TripStatus?>(
              value: _status,
              items: [null, ...TripStatus.values],
              labelFor: (s) => s == null ? 'Todos los estados' : s.label,
              onChanged: (v) => setState(() {
                _status = v;
                _page = 0;
              }),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No hay viajes que coincidan con los filtros.', style: LandingType.body(size: 12.5))),
          )
        else
          LayoutBuilder(builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            if (compact) {
              return Column(children: [for (final r in pageRows) _HistoryMobileRow(row: r)]);
            }
            return Column(
              children: [
                const _HeaderRow(),
                for (final r in pageRows) _HistoryDesktopRow(row: r),
              ],
            );
          }),
        const SizedBox(height: 14),
        if (filtered.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Página ${page + 1} de $totalPages · ${filtered.length} viajes', style: LandingType.body(size: 11.5, color: LandingColors.textTertiary)),
              Row(
                children: [
                  _PageButton(icon: Icons.chevron_left_rounded, onTap: page > 0 ? () => setState(() => _page = page - 1) : null),
                  const SizedBox(width: 8),
                  _PageButton(icon: Icons.chevron_right_rounded, onTap: page < totalPages - 1 ? () => setState(() => _page = page + 1) : null),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    TextStyle style() => LandingType.body(size: 10.5, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.4);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('FECHA', style: style())),
          Expanded(flex: 4, child: Text('RUTA', style: style())),
          Expanded(flex: 2, child: Text('CONDUCTOR', style: style())),
          Expanded(flex: 2, child: Text('VEHÍCULO', style: style())),
          Expanded(flex: 2, child: Text('PRECIO', style: style())),
          Expanded(flex: 2, child: Text('ESTADO', style: style())),
          Expanded(flex: 1, child: Text('★', style: style())),
        ],
      ),
    );
  }
}

class _HistoryDesktopRow extends StatefulWidget {
  final HistoryRowData row;
  const _HistoryDesktopRow({required this.row});

  @override
  State<_HistoryDesktopRow> createState() => _HistoryDesktopRowState();
}

class _HistoryDesktopRowState extends State<_HistoryDesktopRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.row;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _hover ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LandingColors.glassBorder),
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(r.dateLabel, style: const TextStyle(color: LandingColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w600))),
            Expanded(
              flex: 4,
              child: Text('${r.origin} → ${r.destination}', style: LandingType.body(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Expanded(flex: 2, child: Text(r.driver, style: LandingType.body(size: 12), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text(r.vehicle, style: LandingType.body(size: 12), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text('\$${r.price}', style: const TextStyle(color: LandingColors.success, fontSize: 12.5, fontWeight: FontWeight.w700))),
            Expanded(flex: 2, child: StatusBadge(status: r.status, withIcon: false)),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFBBF24)),
                  const SizedBox(width: 2),
                  Text('${r.rating}', style: const TextStyle(color: LandingColors.textPrimary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryMobileRow extends StatelessWidget {
  final HistoryRowData row;
  const _HistoryMobileRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LandingColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(row.dateLabel, style: LandingType.cardTitle(size: 12.5)),
              StatusBadge(status: row.status, withIcon: false),
            ],
          ),
          const SizedBox(height: 8),
          Text('${row.origin} → ${row.destination}', style: LandingType.body(size: 12.5)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${row.driver} · ${row.vehicle}', style: LandingType.body(size: 11.5, color: LandingColors.textTertiary)),
              Text('\$${row.price}', style: const TextStyle(color: LandingColors.success, fontWeight: FontWeight.w700, fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelFor;
  final ValueChanged<T> onChanged;

  const _FilterDropdown({required this.value, required this.items, required this.labelFor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LandingColors.glassBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          dropdownColor: LandingColors.bgSurface,
          icon: const Icon(Icons.expand_more_rounded, size: 16, color: LandingColors.textTertiary),
          style: const TextStyle(color: LandingColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w600),
          items: [for (final item in items) DropdownMenuItem(value: item, child: Text(labelFor(item)))],
          onChanged: (v) {
            if (v != null || items.contains(null)) onChanged(v as T);
          },
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _PageButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          child: Icon(icon, size: 17, color: enabled ? LandingColors.textPrimary : LandingColors.textTertiary.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}
