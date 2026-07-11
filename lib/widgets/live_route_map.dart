import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../theme/app_theme.dart';

// TomTom Maps API key. Retrieved from compile-time environment variables.
// Run/build using: flutter run --dart-define-from-file=.env
const _tomTomApiKey = String.fromEnvironment('TOMTOM_API_KEY');

/// Real, interactive map built with flutter_map + TomTom raster tiles. Fetches
/// the actual driving route from TomTom's Routing API so the polyline follows
/// real streets instead of drawing a straight line between the two points.
class LiveRouteMap extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;
  final String originLabel;
  final String destinationLabel;
  final String driverName;
  final int etaMinutes;
  final double progress;

  const LiveRouteMap({
    super.key,
    required this.origin,
    required this.destination,
    required this.originLabel,
    required this.destinationLabel,
    required this.driverName,
    required this.etaMinutes,
    required this.progress,
  });

  @override
  State<LiveRouteMap> createState() => _LiveRouteMapState();
}

class _LiveRouteMapState extends State<LiveRouteMap> {
  final _mapController = MapController();
  String? _activeTooltip;
  List<LatLng>? _routePoints;
  bool _routeFailed = false;

  List<LatLng> get _polylinePoints => _routePoints ?? [widget.origin, widget.destination];
  LatLngBounds get _bounds => LatLngBounds.fromPoints(_polylinePoints);
  LatLng get _carPoint => _pointAlongRoute(_polylinePoints, widget.progress);

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    try {
      final uri = Uri.parse(
        'https://api.tomtom.com/routing/1/calculateRoute/'
        '${widget.origin.latitude},${widget.origin.longitude}:'
        '${widget.destination.latitude},${widget.destination.longitude}'
        '/json?key=$_tomTomApiKey',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) throw Exception('HTTP ${response.statusCode}');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List;
      final points = (routes.first['legs'] as List).first['points'] as List;
      final route = [
        for (final p in points) LatLng((p['latitude'] as num).toDouble(), (p['longitude'] as num).toDouble()),
      ];
      if (!mounted || route.length < 2) return;
      setState(() => _routePoints = route);
      _mapController.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(route), padding: const EdgeInsets.all(48)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _routeFailed = true);
    }
  }

  LatLng _pointAlongRoute(List<LatLng> points, double t) {
    if (points.length < 2) return points.first;
    const distanceCalc = Distance();
    final segmentLengths = [for (var i = 0; i < points.length - 1; i++) distanceCalc.distance(points[i], points[i + 1])];
    final total = segmentLengths.fold<double>(0, (sum, d) => sum + d);
    var target = total * t.clamp(0.0, 1.0);
    for (var i = 0; i < segmentLengths.length; i++) {
      if (target <= segmentLengths[i] || i == segmentLengths.length - 1) {
        final f = segmentLengths[i] == 0 ? 0.0 : (target / segmentLengths[i]).clamp(0.0, 1.0);
        return LatLng(
          points[i].latitude + (points[i + 1].latitude - points[i].latitude) * f,
          points[i].longitude + (points[i + 1].longitude - points[i].longitude) * f,
        );
      }
      target -= segmentLengths[i];
    }
    return points.last;
  }

  void _toggleTooltip(String key) => setState(() => _activeTooltip = _activeTooltip == key ? null : key);

  void _zoomBy(double delta) {
    final camera = _mapController.camera;
    _mapController.move(camera.center, (camera.zoom + delta).clamp(9.0, 17.0));
  }

  void _recenter() {
    _mapController.fitCamera(CameraFit.bounds(bounds: _bounds, padding: const EdgeInsets.all(48)));
    setState(() => _activeTooltip = null);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(bounds: _bounds, padding: const EdgeInsets.all(48)),
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                onTap: (_, __) => setState(() => _activeTooltip = null),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$_tomTomApiKey',
                  userAgentPackageName: 'com.rideeci.app',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _polylinePoints,
                      color: AppColors.blueAccentDark,
                      strokeWidth: 4,
                      pattern: _routePoints == null ? StrokePattern.dashed(segments: const [10, 8]) : const StrokePattern.solid(),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.origin,
                      width: 34,
                      height: 34,
                      alignment: Alignment.topCenter,
                      child: _MapPin(color: AppColors.mint, onTap: () => _toggleTooltip('origin')),
                    ),
                    Marker(
                      point: widget.destination,
                      width: 34,
                      height: 34,
                      alignment: Alignment.topCenter,
                      child: _MapPin(color: AppColors.coral, onTap: () => _toggleTooltip('destination')),
                    ),
                    Marker(
                      point: _carPoint,
                      width: 30,
                      height: 30,
                      child: _CarMarker(onTap: () => _toggleTooltip('car')),
                    ),
                  ],
                ),
                RichAttributionWidget(
                  alignment: AttributionAlignment.bottomLeft,
                  attributions: [
                    TextSourceAttribution('© TomTom', onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
          if (_activeTooltip == 'origin') _TooltipCard(text: widget.originLabel, alignment: Alignment.topLeft),
          if (_activeTooltip == 'destination') _TooltipCard(text: widget.destinationLabel, alignment: Alignment.topRight),
          if (_activeTooltip == 'car')
            _TooltipCard(text: '${widget.driverName} · llega en ${widget.etaMinutes} min', alignment: Alignment.topCenter),
          const Positioned(top: 10, left: 10, child: _LiveBadge()),
          if (_routePoints == null)
            Positioned(
              top: 10,
              right: 10,
              child: _StatusChip(
                loading: !_routeFailed,
                label: _routeFailed ? 'Ruta aproximada' : 'Calculando ruta…',
              ),
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Column(
              children: [
                _MapIconButton(icon: Icons.add, onTap: () => _zoomBy(1), tooltip: 'Acercar'),
                const SizedBox(height: 6),
                _MapIconButton(icon: Icons.remove, onTap: () => _zoomBy(-1), tooltip: 'Alejar'),
                const SizedBox(height: 6),
                _MapIconButton(icon: Icons.my_location, onTap: _recenter, tooltip: 'Centrar ruta'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  const _MapPin({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.location_on, size: 34, color: color, shadows: const [Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2))]),
    );
  }
}

class _CarMarker extends StatelessWidget {
  final VoidCallback onTap;
  const _CarMarker({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const size = 26.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.deepGreenDarker,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 5, offset: Offset(0, 2))],
        ),
        child: const Icon(Icons.directions_car, size: 13, color: AppColors.mint),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.18, duration: 900.ms, curve: Curves.easeInOut),
    );
  }
}

class _TooltipCard extends StatelessWidget {
  final String text;
  final Alignment alignment;
  const _TooltipCard({required this.text, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.only(top: 46, left: 10, right: 10),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 170),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppColors.deepGreenDarker, borderRadius: BorderRadius.circular(8)),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, height: 1.3),
          ),
        ).animate().fadeIn(duration: 150.ms).scaleXY(begin: 0.9, end: 1),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.coral, shape: BoxShape.circle))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeOut(duration: 700.ms, curve: Curves.easeInOut),
          const SizedBox(width: 6),
          Text('EN VIVO', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool loading;
  final String label;
  const _StatusChip({required this.loading, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.8, color: AppColors.blueAccentDark))
          else
            Icon(Icons.info_outline, size: 12, color: AppColors.amberDeep),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _MapIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  const _MapIconButton({required this.icon, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(7), child: Icon(icon, size: 16, color: AppColors.textDark)),
        ),
      ),
    );
  }
}
