import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';
import 'glow_blob.dart';

/// A decorative phone frame showing a *live* RidECI trip-tracking screen —
/// map background, a little car running the route, live stats and driver
/// info — instead of a flat static graphic. Floats slowly up and down with
/// a soft blue glow behind it.
class PhoneMockup extends StatelessWidget {
  final double width;
  const PhoneMockup({super.key, this.width = 300});

  @override
  Widget build(BuildContext context) {
    final height = width * 2.2;
    return SizedBox(
      width: width * 1.6,
      height: height * 1.12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GlowBlob(size: width * 1.4, color: LandingColors.primaryMid, opacity: 0.4, driftX: 10, driftY: 14),
          _Frame(width: width, height: height)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -10, end: 10, duration: 3600.ms, curve: Curves.easeInOut),
        ],
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  final double width;
  final double height;
  const _Frame({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1220),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, offset: const Offset(0, 24)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: LandingColors.bgSurface,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 56,
                height: 5,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _HeaderRow(),
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: _TripMapCard(),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: _InfoChipsRow(),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: _DriverCard(),
              ),
              const SizedBox(height: 6),
              const _BottomNav(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('RidECI', style: LandingType.cardTitle(size: 15)),
            const SizedBox(width: 8),
            const _LiveBadge(),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none_rounded, size: 18, color: LandingColors.textTertiary),
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(color: LandingColors.accent, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Small blinking "live" pill — a plain looping opacity animation.
class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: LandingColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(color: LandingColors.success, shape: BoxShape.circle),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeOut(duration: 700.ms, curve: Curves.easeInOut),
          const SizedBox(width: 5),
          Text('En vivo', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: LandingColors.success)),
        ],
      ),
    );
  }
}

/// The main "trip in progress" card: live stats up top, animated map below.
class _TripMapCard extends StatelessWidget {
  const _TripMapCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tu viaje en curso', style: LandingType.body(size: 10.5, color: LandingColors.textTertiary)),
          const SizedBox(height: 6),
          Text('4.2 km', style: LandingType.cardTitle(size: 24)),
          Text('12 min', style: LandingType.cardTitle(size: 15, color: LandingColors.primaryLight)),
          const SizedBox(height: 2),
          Text('Tiempo estimado', style: LandingType.body(size: 9.5, color: LandingColors.textTertiary)),
          const SizedBox(height: 12),
          const Expanded(child: _MapArea()),
        ],
      ),
    );
  }
}

/// Shared route geometry so the canvas painter and the widget-positioned
/// car marker always agree on where the path is.
class _RouteGeometry {
  final Offset start;
  final Offset end;
  final Offset control;

  _RouteGeometry(Size size)
      : start = Offset(size.width * 0.16, size.height * 0.82),
        end = Offset(size.width * 0.82, size.height * 0.14),
        control = Offset(size.width * 0.78, size.height * 0.78);

  // `late final` fields with an inline initializer are evaluated lazily on
  // first access, by which point start/end/control (set above via the
  // initializer list) are already available.
  late final Path path = Path()
    ..moveTo(start.dx, start.dy)
    ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

  late final metric = path.computeMetrics().first;
}

/// The animated map: a textured background, a glowing route, a radar-pulse
/// pickup point and a little car that continuously runs the route.
class _MapArea extends StatefulWidget {
  const _MapArea();

  @override
  State<_MapArea> createState() => _MapAreaState();
}

class _MapAreaState extends State<_MapArea> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3400))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(builder: (context, constraints) {
        final size = constraints.biggest;
        final geometry = _RouteGeometry(size);
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final phase = _controller.value;
            final travelled = geometry.metric.length * phase;
            final tangent = geometry.metric.getTangentForOffset(travelled);
            return Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _RoutePainter(phase: phase))),
                if (tangent != null)
                  Positioned(
                    left: tangent.position.dx - 11,
                    top: tangent.position.dy - 11,
                    child: Transform.rotate(
                      angle: tangent.angle,
                      child: const _CarMarker(),
                    ),
                  ),
                const Positioned(bottom: 8, right: 8, child: _ViewOnMapButton()),
              ],
            );
          },
        );
      }),
    );
  }
}

/// Tiny top-down car glyph with a soft glow halo, oriented via
/// [Transform.rotate] to match the route's tangent direction.
class _CarMarker extends StatelessWidget {
  const _CarMarker();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Colors.white.withValues(alpha: 0.35), Colors.white.withValues(alpha: 0)]),
            ),
          ),
          Container(
            width: 14,
            height: 8.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [BoxShadow(color: LandingColors.accent.withValues(alpha: 0.7), blurRadius: 6)],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 3),
            width: 6,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF0A1220),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewOnMapButton extends StatelessWidget {
  const _ViewOnMapButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_rounded, size: 11, color: LandingColors.primaryLight),
          const SizedBox(width: 4),
          Text('Ver en mapa', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9))),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final double phase;
  const _RoutePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    _paintMapTexture(canvas, size);

    final geometry = _RouteGeometry(size);
    final start = geometry.start;
    final end = geometry.end;
    final path = geometry.path;
    final metric = geometry.metric;

    // Faint full route underneath, so the traveled portion reads as
    // "progress" against the total path.
    canvas.drawPath(
      path,
      Paint()
        ..color = LandingColors.accent.withValues(alpha: 0.16)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final totalLength = metric.length;
    final travelled = totalLength * phase;
    final progressPath = metric.extractPath(0, travelled);
    canvas.drawPath(
      progressPath,
      Paint()
        ..shader = LinearGradient(colors: [LandingColors.success, LandingColors.accent]).createShader(Rect.fromPoints(start, end))
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2),
    );

    // Destination pin (blue) with a soft static glow ring.
    canvas.drawCircle(end, 12, Paint()..color = LandingColors.primary.withValues(alpha: 0.25));
    canvas.drawCircle(end, 7, Paint()..color = LandingColors.primary);
    canvas.drawCircle(end, 7, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = Colors.white);

    // Pickup point (green) with a continuous outward radar pulse.
    _drawRadarPing(canvas, start, (phase * 1.6) % 1.0);
    _drawRadarPing(canvas, start, ((phase * 1.6) + 0.5) % 1.0);
    canvas.drawCircle(start, 7, Paint()..color = LandingColors.success);
    canvas.drawCircle(start, 7, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = Colors.white);
  }

  /// Faint city-block shapes + crossing avenues so the backdrop reads as a
  /// real map instead of a flat gradient.
  void _paintMapTexture(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = LandingColors.bgDeepest);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LandingColors.primary.withValues(alpha: 0.24), LandingColors.bgDeepest],
        ).createShader(Offset.zero & size),
    );

    final blockPaint = Paint()..color = Colors.white.withValues(alpha: 0.035);
    final blocks = [
      Rect.fromLTWH(size.width * 0.06, size.height * 0.08, size.width * 0.28, size.height * 0.18),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.05, size.width * 0.22, size.height * 0.14),
      Rect.fromLTWH(size.width * 0.62, size.height * 0.42, size.width * 0.3, size.height * 0.2),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.55, size.width * 0.24, size.height * 0.22),
      Rect.fromLTWH(size.width * 0.32, size.height * 0.32, size.width * 0.2, size.height * 0.14),
    ];
    for (final rect in blocks) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), blockPaint);
    }

    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.28), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.68), Offset(size.width, size.height * 0.6), roadPaint);
    canvas.drawLine(Offset(size.width * 0.38, 0), Offset(size.width * 0.5, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.72, 0), Offset(size.width * 0.6, size.height), roadPaint);
  }

  void _drawRadarPing(Canvas canvas, Offset center, double t) {
    final radius = 7 + t * 18;
    final opacity = (1 - t) * 0.5;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = LandingColors.success.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => oldDelegate.phase != phase;
}

/// Row of three quick facts about the trip, mirroring the "Origen / Llegada
/// / Viaje seguro" chips of the reference design.
class _InfoChipsRow extends StatelessWidget {
  const _InfoChipsRow();

  static const _items = [
    (Icons.trending_up_rounded, 'Origen', 'Universidad', LandingColors.textPrimary),
    (Icons.access_time_rounded, 'Llegada', '3:21 p.m.', LandingColors.textPrimary),
    (Icons.shield_rounded, 'Viaje seguro', 'Verificado', LandingColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in _items)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.$1, size: 12, color: item.$4),
                    const SizedBox(height: 5),
                    Text(item.$2, style: LandingType.body(size: 8.5, color: LandingColors.textTertiary)),
                    Text(
                      item.$3,
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: item.$4),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: LandingColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.person_rounded, size: 17, color: Colors.white),
                  ),
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: LandingColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: LandingColors.bgSurface, width: 2),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 0.85, end: 1.15, duration: 900.ms),
                  ),
                ],
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Camilo R.', style: LandingType.cardTitle(size: 12)),
                        const SizedBox(width: 5),
                        const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFBBF24)),
                        Text(' 4.9', style: LandingType.body(size: 10.5, color: LandingColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text('En camino · llega en 3 min', style: LandingType.body(size: 10, color: LandingColors.textTertiary)),
                  ],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: LandingColors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.chat_bubble_rounded, size: 13, color: LandingColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _TripProgressSlider(),
        ],
      ),
    );
  }
}

/// A slider-style progress track with a glowing thumb, reading as a live
/// trip-completion indicator.
class _TripProgressSlider extends StatelessWidget {
  const _TripProgressSlider();

  static const double _progress = 0.6;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 3,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(child: Container(color: Colors.white.withValues(alpha: 0.1))),
                  FractionallySizedBox(
                    widthFactor: _progress,
                    heightFactor: 1,
                    child: Container(decoration: BoxDecoration(gradient: LandingColors.buttonGradient)),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(_progress * 2 - 1, 0),
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: LandingColors.primaryLight, width: 2),
                boxShadow: [BoxShadow(color: LandingColors.primaryLight.withValues(alpha: 0.6), blurRadius: 6)],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 0.9, end: 1.15, duration: 1000.ms),
          ),
        ],
      ),
    );
  }
}

/// Bottom app-nav strip with labels so the screen reads as a full app view.
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  static const _items = [
    (Icons.home_rounded, 'Inicio'),
    (Icons.map_rounded, 'Viajes'),
    (Icons.receipt_rounded, 'Mis viajes'),
    (Icons.person_rounded, 'Perfil'),
  ];
  static const _activeIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < _items.length; i++)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _items[i].$1,
                  size: 16,
                  color: i == _activeIndex ? LandingColors.accent : LandingColors.textTertiary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 3),
                Text(
                  _items[i].$2,
                  style: TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w600,
                    color: i == _activeIndex ? LandingColors.accent : LandingColors.textTertiary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
