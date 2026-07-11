import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Firma de la función de proyección isométrica: recibe una coordenada de
/// grilla (x, y) más una altura (z, en píxeles) y devuelve el punto en
/// pantalla correspondiente.
typedef _IsoFn = Offset Function(double x, double y, double z);

/// Clamp explícito que siempre devuelve `double` (a diferencia de
/// `num.clamp`, que puede inferir `num` y romper la asignación a parámetros
/// tipados como `double` en las APIs de canvas).
double _clampD(double value, double lo, double hi) => value < lo ? lo : (value > hi ? hi : value);

/// Escena isométrica animada que acompaña al Hero: una pequeña plataforma
/// flotante con el edificio de la Escuela, una ruta serpenteante y un carro
/// que va y vuelve por ella, como el viaje compartido que representa la app.
///
/// Todo se dibuja con [CustomPainter] (sin paquetes ni assets 3D nuevos), así
/// que se ve igual en Android, iOS y Web y es liviano de mantener.
class Hero3DScene extends StatefulWidget {
  final double height;

  const Hero3DScene({super.key, this.height = 220});

  @override
  State<Hero3DScene> createState() => _Hero3DSceneState();
}

class _Hero3DSceneState extends State<Hero3DScene> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 9000))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _IsoScenePainter(phase: _controller.value),
            );
          },
        ),
      ),
    );
  }
}

class _IsoScenePainter extends CustomPainter {
  /// Ciclo continuo 0→1: controla el flote de la plataforma, el ida-y-vuelta
  /// del carro por la ruta y las partículas que suben junto al edificio.
  final double phase;

  const _IsoScenePainter({required this.phase});

  static const double _gridSize = 6.0;

  /// Ruta sobre la plataforma, en coordenadas de grilla, desde la puerta del
  /// edificio hasta la esquina opuesta.
  static const List<Offset> _roadPoints = [
    Offset(2.5, 1.9),
    Offset(3.0, 2.5),
    Offset(3.55, 3.3),
    Offset(4.0, 4.1),
    Offset(4.55, 4.7),
    Offset(5.25, 5.25),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final tileW = _clampD(size.shortestSide / 11, 13.0, 30.0);
    final tileH = tileW * 0.5;
    final origin = Offset(size.width * 0.5, size.height * 0.30);

    Offset iso(double x, double y, double z) =>
        Offset(origin.dx + (x - y) * tileW, origin.dy + (x + y) * tileH - z);

    final bobUnit = math.sin(phase * 2 * math.pi);
    final bob = bobUnit * (tileW * 0.12);

    // Sombra de contacto: se queda "en el suelo" (no flota) y se comprime un
    // poco cuando la plataforma sube, para reforzar la sensación de altura.
    final shadowCenter = iso(_gridSize / 2, _gridSize / 2, -tileW * 0.9) + Offset(0, tileW * 0.35);
    final shadowWidth = _gridSize * tileW * 0.85;
    final shadowSquish = 1.0 - bobUnit * 0.06;
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: shadowWidth * shadowSquish,
        height: shadowWidth * 0.30,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    canvas.save();
    canvas.translate(0, bob);

    _drawPlatform(canvas, iso, tileW);
    _drawRoad(canvas, iso, tileW);
    _drawTree(canvas, iso, tileW, const Offset(4.7, 1.15));
    _drawTree(canvas, iso, tileW, const Offset(1.05, 4.55));
    _drawBuilding(canvas, iso, tileW);
    _drawCar(canvas, iso, tileW);
    _drawParticles(canvas, iso, tileW);

    canvas.restore();
  }

  /// Dibuja una caja isométrica genérica a partir de una huella (footprint)
  /// convexa en coordenadas de grilla y un rango vertical [z0, z1]. Detecta
  /// automáticamente la esquina más cercana a la cámara (mayor x+y) para
  /// elegir qué dos caras laterales son visibles, así que sirve tanto para
  /// cajas alineadas a la grilla (plataforma, edificio) como rotadas (carro).
  void _drawIsoBox(
    Canvas canvas,
    _IsoFn iso, {
    required List<Offset> footprint,
    required double z0,
    required double z1,
    required Color topColor,
    required Color sideColorA,
    required Color sideColorB,
  }) {
    final n = footprint.length;
    var nearIdx = 0;
    var best = double.negativeInfinity;
    for (var i = 0; i < n; i++) {
      final s = footprint[i].dx + footprint[i].dy;
      if (s > best) {
        best = s;
        nearIdx = i;
      }
    }
    final nextIdx = (nearIdx + 1) % n;
    final prevIdx = (nearIdx - 1 + n) % n;

    Path facePath(int a, int b) {
      final pa = footprint[a];
      final pb = footprint[b];
      return Path()
        ..addPolygon([
          iso(pa.dx, pa.dy, z1),
          iso(pb.dx, pb.dy, z1),
          iso(pb.dx, pb.dy, z0),
          iso(pa.dx, pa.dy, z0),
        ], true);
    }

    canvas.drawPath(facePath(nearIdx, nextIdx), Paint()..color = sideColorA);
    canvas.drawPath(facePath(prevIdx, nearIdx), Paint()..color = sideColorB);

    final topPts = [for (final p in footprint) iso(p.dx, p.dy, z1)];
    canvas.drawPath(Path()..addPolygon(topPts, true), Paint()..color = topColor);
  }

  void _drawPlatform(Canvas canvas, _IsoFn iso, double tileW) {
    final footprint = [
      const Offset(0, 0),
      const Offset(_gridSize, 0),
      const Offset(_gridSize, _gridSize),
      const Offset(0, _gridSize),
    ];
    _drawIsoBox(
      canvas,
      iso,
      footprint: footprint,
      z0: -tileW * 0.55,
      z1: 0,
      topColor: AppColors.surface,
      sideColorA: AppColors.mintDark.withValues(alpha: 0.55),
      sideColorB: AppColors.mintDeep.withValues(alpha: 0.75),
    );

    final topPts = [for (final p in footprint) iso(p.dx, p.dy, 0)];
    canvas.drawPath(
      Path()..addPolygon(topPts, true),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.border,
    );
  }

  void _drawBuilding(Canvas canvas, _IsoFn iso, double tileW) {
    const base = [
      Offset(0.9, 0.7),
      Offset(2.5, 0.7),
      Offset(2.5, 2.1),
      Offset(0.9, 2.1),
    ];
    final bodyHeight = tileW * 1.5;
    _drawIsoBox(
      canvas,
      iso,
      footprint: base,
      z0: 0,
      z1: bodyHeight,
      topColor: AppColors.blueAccent.withValues(alpha: 0.18),
      sideColorA: AppColors.blueAccentDark,
      sideColorB: AppColors.blueAccent,
    );

    const cap = [
      Offset(1.05, 0.85),
      Offset(2.35, 0.85),
      Offset(2.35, 1.95),
      Offset(1.05, 1.95),
    ];
    _drawIsoBox(
      canvas,
      iso,
      footprint: cap,
      z0: bodyHeight,
      z1: bodyHeight + tileW * 0.32,
      topColor: AppColors.mint,
      sideColorA: AppColors.mintDark,
      sideColorB: AppColors.mintDeep,
    );

    // Ventanas encendidas sobre la cara frontal del edificio (y = 2.1).
    final winPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    for (final wy in [bodyHeight * 0.32, bodyHeight * 0.66]) {
      for (final wx in [1.3, 1.75, 2.2]) {
        final c = iso(wx, 2.1, wy);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: c, width: tileW * 0.16, height: tileW * 0.16),
            Radius.circular(tileW * 0.03),
          ),
          winPaint,
        );
      }
    }
  }

  void _drawRoad(Canvas canvas, _IsoFn iso, double tileW) {
    final roadZ = tileW * 0.02;
    final pts = [for (final p in _roadPoints) iso(p.dx, p.dy, roadZ)];
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = tileW * 0.62
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = appThemeController.isDark ? const Color(0xFF2A3346) : const Color(0xFF3B4453),
    );

    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileW * 0.05
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.55);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashLen = 6.0;
      const gapLen = 7.0;
      while (distance < metric.length) {
        final next = math.min(distance + dashLen, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), dashPaint);
        distance = next + gapLen;
      }
    }
  }

  void _drawTree(Canvas canvas, _IsoFn iso, double tileW, Offset gridPos) {
    final trunkTop = tileW * 0.28;
    final trunkBase = iso(gridPos.dx, gridPos.dy, 0);
    final trunkTopPt = iso(gridPos.dx, gridPos.dy, trunkTop);
    canvas.drawLine(
      trunkBase,
      trunkTopPt,
      Paint()
        ..strokeWidth = tileW * 0.09
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF8A6A4A),
    );
    final canopyCenter = iso(gridPos.dx, gridPos.dy, trunkTop + tileW * 0.30);
    canvas.drawCircle(canopyCenter, tileW * 0.34, Paint()..color = AppColors.mintDark.withValues(alpha: 0.9));
    canvas.drawCircle(
      canopyCenter.translate(-tileW * 0.10, -tileW * 0.08),
      tileW * 0.22,
      Paint()..color = AppColors.mint.withValues(alpha: 0.85),
    );
  }

  ({Offset pos, double heading}) _carState(double t) {
    final pos = _pointOnPolyline(_roadPoints, t);
    const eps = 0.01;
    final t1 = _clampD(t - eps, 0.0, 1.0);
    final t2 = _clampD(t + eps, 0.0, 1.0);
    final p1 = _pointOnPolyline(_roadPoints, t1);
    final p2 = _pointOnPolyline(_roadPoints, t2);
    final heading = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    return (pos: pos, heading: heading);
  }

  void _drawCar(Canvas canvas, _IsoFn iso, double tileW) {
    // Recorrido de ida y vuelta (0→1→0): el carro va hacia el punto de
    // encuentro y regresa, como un viaje compartido completo.
    final tri = phase < 0.5 ? phase * 2 : 2 - phase * 2;
    final state = _carState(tri);
    final gx = state.pos.dx;
    final gy = state.pos.dy;
    final cosT = math.cos(state.heading);
    final sinT = math.sin(state.heading);

    Offset rotated(double u, double v) => Offset(gx + u * cosT - v * sinT, gy + u * sinT + v * cosT);

    const halfLen = 0.34;
    const halfWid = 0.20;
    final bodyFootprint = [
      rotated(halfLen, -halfWid),
      rotated(halfLen, halfWid),
      rotated(-halfLen, halfWid),
      rotated(-halfLen, -halfWid),
    ];
    final roadZ = tileW * 0.02;
    final bodyH = tileW * 0.30;

    final wheelPaint = Paint()..color = AppColors.deepGreenDarker.withValues(alpha: 0.85);
    for (final corner in bodyFootprint) {
      canvas.drawCircle(iso(corner.dx, corner.dy, roadZ), tileW * 0.075, wheelPaint);
    }

    _drawIsoBox(
      canvas,
      iso,
      footprint: bodyFootprint,
      z0: roadZ,
      z1: roadZ + bodyH,
      topColor: AppColors.mint,
      sideColorA: AppColors.mintDeep,
      sideColorB: AppColors.mintDark,
    );

    const cabinLen = 0.18;
    const cabinWid = 0.15;
    final cabinFootprint = [
      rotated(cabinLen, -cabinWid),
      rotated(cabinLen, cabinWid),
      rotated(-cabinLen, cabinWid),
      rotated(-cabinLen, -cabinWid),
    ];
    _drawIsoBox(
      canvas,
      iso,
      footprint: cabinFootprint,
      z0: roadZ + bodyH,
      z1: roadZ + bodyH + tileW * 0.18,
      topColor: AppColors.blueAccent.withValues(alpha: 0.85),
      sideColorA: AppColors.blueAccentDark.withValues(alpha: 0.9),
      sideColorB: AppColors.blueAccent.withValues(alpha: 0.9),
    );
  }

  void _drawParticles(Canvas canvas, _IsoFn iso, double tileW) {
    const seeds = [0.15, 0.55, 0.85];
    for (var i = 0; i < seeds.length; i++) {
      final local = (phase + seeds[i]) % 1.0;
      final gx = 3.6 + i * 0.5;
      final gy = 1.4 + i * 0.3;
      final rise = local * tileW * 2.2;
      final alpha = _clampD((1 - local) * 0.6, 0.0, 0.6);
      final center = iso(gx, gy, tileW * 0.5 + rise);
      canvas.drawCircle(center, tileW * 0.06, Paint()..color = AppColors.mint.withValues(alpha: alpha));
    }
  }

  @override
  bool shouldRepaint(covariant _IsoScenePainter oldDelegate) => oldDelegate.phase != phase;
}

Offset _pointOnPolyline(List<Offset> pts, double t) {
  final segLengths = <double>[];
  var total = 0.0;
  for (var i = 0; i < pts.length - 1; i++) {
    final d = (pts[i + 1] - pts[i]).distance;
    segLengths.add(d);
    total += d;
  }
  if (total == 0) return pts.first;

  var target = _clampD(t, 0.0, 1.0) * total;
  for (var i = 0; i < segLengths.length; i++) {
    if (target <= segLengths[i] || i == segLengths.length - 1) {
      final f = segLengths[i] == 0 ? 0.0 : _clampD(target / segLengths[i], 0.0, 1.0);
      return Offset.lerp(pts[i], pts[i + 1], f)!;
    }
    target -= segLengths[i];
  }
  return pts.last;
}
