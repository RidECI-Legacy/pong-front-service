import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../data/auth.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';
import '../widgets/theme_toggle_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static final howItWorksKey = GlobalKey();
  static final sostenibilidadKey = GlobalKey();
  static final seguridadKey = GlobalKey();

  static void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  static void handleNavTap(String label) {
    switch (label) {
      case 'Cómo funciona':
        _scrollTo(howItWorksKey);
        break;
      case 'Sostenibilidad':
        _scrollTo(sostenibilidadKey);
        break;
      case 'Seguridad':
        _scrollTo(seguridadKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HeroSection(),
            ResponsiveContainer(
              child: Container(key: howItWorksKey, child: const _HowItWorksSection()),
            ),
            Container(key: sostenibilidadKey, child: const _SostenibilidadSection()),
            Container(key: seguridadKey, child: const _SeguridadSection()),
            const _CommunitySection(),
            const _ImpactSection(),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          const Positioned.fill(child: _HeroBackdrop()),
          ResponsiveContainer(
            maxWidth: 1180,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TopNav(),
                  const SizedBox(height: 48),
                  LayoutBuilder(builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 860;
                    if (isMobile) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroCopy(),
                          SizedBox(height: 36),
                          _LoginCard(),
                        ],
                      );
                    }
                    return const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _HeroCopy()),
                        SizedBox(width: 32),
                        Expanded(flex: 5, child: _LoginCard()),
                      ],
                    );
                  }),
                  const SizedBox(height: 56),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fondo animado del hero: un mapa de calles esquemático con dos rutas que
/// se "dibujan" al cargar la página, ancladas en los márgenes para no
/// interferir con el texto ni la tarjeta de acceso.
class _HeroBackdrop extends StatefulWidget {
  const _HeroBackdrop();

  @override
  State<_HeroBackdrop> createState() => _HeroBackdropState();
}

class _HeroBackdropState extends State<_HeroBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3600))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.biggest;
      final isMobile = size.width < 860;

      return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: size,
            painter: _StreetMapPainter(phase: _controller.value, dense: !isMobile),
          );
        },
      );
    });
  }
}

enum _MarkerKind { pin, person, flag }

class _MapMarker {
  final Offset position;
  final _MarkerKind kind;
  final String? label;

  const _MapMarker(this.position, this.kind, {this.label});
}

class _StreetMapPainter extends CustomPainter {
  /// Ciclo continuo 0→1 usado solo para el leve parpadeo de los puntos de
  /// ubicación (el mapa y los pines en sí son estáticos).
  final double phase;
  final bool dense;

  const _StreetMapPainter({required this.phase, required this.dense});

  static const double panelFraction = 0.30;

  // Marcadores repartidos sobre los dos mapas laterales, igual que en la
  // referencia: pines, avatares de persona y una bandera, cada uno con su
  // puntico de ubicación debajo.
  static const markers = [
    _MapMarker(Offset(0.088, 0.205), _MarkerKind.pin),
    _MapMarker(Offset(0.128, 0.265), _MarkerKind.person),
    _MapMarker(Offset(0.058, 0.385), _MarkerKind.person),
    _MapMarker(Offset(0.078, 0.555), _MarkerKind.flag),
    _MapMarker(Offset(0.905, 0.205), _MarkerKind.person, label: 'Pasajero'),
    _MapMarker(Offset(0.955, 0.345), _MarkerKind.person),
    _MapMarker(Offset(0.875, 0.585), _MarkerKind.person),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.bg);
    _drawTopWash(canvas, size);
    if (!dense) return;
    _drawMapPanel(canvas, size, isLeft: true);
    _drawMapPanel(canvas, size, isLeft: false);
    for (var i = 0; i < markers.length; i++) {
      _drawMarker(canvas, size, markers[i], i);
    }
  }

  Offset _p(Offset fraction, Size size) => Offset(fraction.dx * size.width, fraction.dy * size.height);

  /// Franja superior con el degradado menta→azul, difuminada verticalmente
  /// para que se funda con el fondo en vez de cortar en seco.
  void _drawTopWash(Canvas canvas, Size size) {
    final bandHeight = (size.height * 0.4).clamp(110.0, 160.0);
    final rect = Rect.fromLTWH(0, 0, size.width, bandHeight);
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFDFF7EE), Color(0xFFE7EBFC)],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, 0.55, 1.0],
        ).createShader(rect)
        ..blendMode = BlendMode.dstIn,
    );
    canvas.restore();
  }

  /// Un panel de "mapa" (rejilla de calles) anclado al borde izquierdo o
  /// derecho, que se desvanece hacia el centro en vez de cortar como una caja.
  void _drawMapPanel(Canvas canvas, Size size, {required bool isLeft}) {
    final panelWidth = size.width * panelFraction;
    final rect = isLeft
        ? Rect.fromLTWH(0, 0, panelWidth, size.height)
        : Rect.fromLTWH(size.width - panelWidth, 0, panelWidth, size.height);

    canvas.saveLayer(rect, Paint());
    _drawStreetGrid(canvas, rect);
    final fadeGradient = isLeft
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, Colors.white, Colors.transparent],
            stops: [0.0, 0.5, 1.0],
          )
        : const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Colors.white, Colors.white, Colors.transparent],
            stops: [0.0, 0.5, 1.0],
          );
    canvas.drawRect(rect, Paint()..shader = fadeGradient.createShader(rect)..blendMode = BlendMode.dstIn);
    canvas.restore();
  }

  void _drawStreetGrid(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = const Color(0xFFC9D2CC)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final w = rect.width;
    final h = rect.height;
    final ox = rect.left;

    const vFracs = [0.08, 0.26, 0.45, 0.65, 0.86];
    for (var i = 0; i < vFracs.length; i++) {
      final x = ox + vFracs[i] * w;
      final wobble = (i.isEven ? 1 : -1) * w * 0.07;
      final path = Path()
        ..moveTo(x, 0)
        ..quadraticBezierTo(x + wobble, h * 0.5, x - wobble * 0.5, h);
      canvas.drawPath(path, paint);
    }

    const hFracs = [0.16, 0.38, 0.60, 0.82];
    for (var i = 0; i < hFracs.length; i++) {
      final y = hFracs[i] * h;
      final wobble = (i.isEven ? 1 : -1) * h * 0.05;
      final path = Path()
        ..moveTo(ox, y)
        ..quadraticBezierTo(ox + w * 0.5, y + wobble, ox + w, y - wobble * 0.5);
      canvas.drawPath(path, paint);
    }
  }

  void _drawMarker(Canvas canvas, Size size, _MapMarker marker, int index) {
    final pos = _p(marker.position, size);
    switch (marker.kind) {
      case _MarkerKind.pin:
        _drawTeardropPin(canvas, pos, AppColors.mintDeep);
        break;
      case _MarkerKind.person:
        _drawPersonBadge(canvas, pos);
        break;
      case _MarkerKind.flag:
        _drawFlagBadge(canvas, pos);
        break;
    }

    final dotCenter = pos + const Offset(0, 21);
    final breathe = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(phase * 2 * math.pi + index * 1.3));
    canvas.drawCircle(dotCenter, 4, Paint()..color = AppColors.mintDark.withValues(alpha: breathe));

    if (marker.label != null) {
      _drawLabel(canvas, dotCenter, marker.label!);
    }
  }

  void _drawPersonBadge(Canvas canvas, Offset center) {
    const r = 12.0;
    canvas.drawCircle(center, r, Paint()..color = AppColors.deepGreenDarker);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withValues(alpha: 0.9),
    );
    _drawIconGlyph(canvas, center - const Offset(0, 1), Icons.person, 14, Colors.white);
  }

  void _drawFlagBadge(Canvas canvas, Offset center) {
    const s = 24.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: s, height: s),
      const Radius.circular(7),
    );
    canvas.drawRRect(rrect, Paint()..color = AppColors.deepGreenDarker);
    _drawIconGlyph(canvas, center, Icons.flag_rounded, 13, Colors.white);
  }

  void _drawIconGlyph(Canvas canvas, Offset center, IconData icon, double size, Color color) {
    final painter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: size, fontFamily: icon.fontFamily, package: icon.fontPackage, color: color),
      )
      ..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  void _drawLabel(Canvas canvas, Offset dotCenter, String label) {
    final painter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
      )
      ..layout();
    final textPos = dotCenter + Offset(9, -painter.height / 2);
    painter.paint(canvas, textPos);
  }

  void _drawTeardropPin(Canvas canvas, Offset tip, Color color) {
    const r = 11.0;
    final top = tip - const Offset(0, r * 2.2);
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..cubicTo(tip.dx - r, tip.dy - r * 1.2, top.dx - r, top.dy + r * 0.4, top.dx, top.dy)
      ..cubicTo(top.dx + r, top.dy + r * 0.4, tip.dx + r, tip.dy - r * 1.2, tip.dx, tip.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(top, r * 0.42, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _StreetMapPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.dense != dense;
}

class _TopNav extends StatelessWidget {
  const _TopNav();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 860;
      final logo = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset('assets/branding/rideci_icon.png', width: 34, height: 34, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Text(
            'RidECI',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );

      final links = Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _NavLink('Cómo funciona'),
          SizedBox(width: 24),
          _NavLink('Sostenibilidad'),
          SizedBox(width: 24),
          _NavLink('Seguridad'),
        ],
      );

      if (isMobile) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [logo, const ThemeToggleButton()],
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [logo, links, const ThemeToggleButton()],
      );
    });
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  const _NavLink(this.label);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => LandingScreen.handleNavTap(label),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Text(
            label,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  static List<Color> get _heroStatColors => [AppColors.textDark, AppColors.blueAccentDark, AppColors.mintDeep];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.mint.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.mint.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: AppColors.mintDeep, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                'Exclusivo comunidad Escuela Ing. Julio Garavito',
                style: TextStyle(color: AppColors.mintDeep, fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.15, color: AppColors.textDark),
            children: [
              const TextSpan(text: 'Comparte el camino '),
              TextSpan(text: 'a la Escuela', style: TextStyle(color: AppColors.mintDeep)),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Conecta con estudiantes, profesores y conductores verificados de tu institución. '
          'Viaja seguro, ahorra en transporte y reduce tu huella de carbono en cada trayecto.',
          style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.textMuted),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 40,
          runSpacing: 16,
          children: [
            for (final entry in MockData.impactStatsHero.indexed)
              StatTile(
                value: entry.$2.value,
                label: entry.$2.label,
                valueColor: _heroStatColors[entry.$1 % _heroStatColors.length],
              ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 550.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic);
  }
}

class _LoginCard extends StatefulWidget {
  const _LoginCard();

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  bool _obscure = true;
  String? _error;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final result = DemoAuth.login(_emailController.text, _passwordController.text);
    if (!result.success) {
      setState(() => _error = result.error);
      return;
    }
    setState(() => _error = null);
    context.go(result.account!.routePath);
  }

  void _fillDemo(DemoAccount account) {
    _emailController.text = account.email;
    _passwordController.text = 'demo1234';
    setState(() => _error = null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido de nuevo',
            style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Ingresa con tu correo institucional para continuar.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 24),
          const _FieldLabel('Correo institucional'),
          const SizedBox(height: 8),
          _AuthTextField(controller: _emailController, hint: 'nombre@mail.escuelaing.edu.co'),
          const SizedBox(height: 18),
          const _FieldLabel('Contraseña'),
          const SizedBox(height: 8),
          _AuthTextField(
            controller: _passwordController,
            hint: '••••••••',
            obscureText: _obscure,
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textMuted,
                size: 18,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.coral.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, size: 15, color: AppColors.coral),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: AppColors.coral, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(color: AppColors.mintDeep, fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mint,
                foregroundColor: AppColors.deepGreenDarker,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Entrar  →', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'CUENTAS DE PRUEBA',
            style: TextStyle(color: AppColors.textMuted, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          for (final account in DemoAuth.accounts)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: AppColors.blueAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(9),
                child: InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: () => _fillDemo(account),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.mint.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            account.roleLabel,
                            style: TextStyle(color: AppColors.mintDeep, fontSize: 10.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            account.email,
                            style: TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 550.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic);
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(color: AppColors.textMuted, fontSize: 12.5, fontWeight: FontWeight.w600),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const _AuthTextField({
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: AppColors.textDark, fontSize: 13.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
        filled: true,
        fillColor: AppColors.bg,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.mint, width: 1.5),
        ),
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  static const _badgeColors = [AppColors.blueAccent, AppColors.mintDark, AppColors.amber];
  static const _illustrations = [
    'assets/illustrations/step_register.svg',
    'assets/illustrations/step_match.svg',
    'assets/illustrations/step_ride.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(eyebrow: 'Cómo funciona', title: 'Tres pasos para tu primer viaje'),
        const SizedBox(height: 36),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 860;
          final cards = List.generate(
            MockData.howItWorks.length,
            (i) => _StepCard(
              step: MockData.howItWorks[i],
              color: _badgeColors[i],
              illustration: _illustrations[i],
            ).animate(delay: (200 * i).ms).fadeIn(duration: 420.ms).slideY(begin: 0.12, curve: Curves.easeOutCubic),
          );
          if (isMobile) {
            return Column(
              children: [
                for (final c in cards) Padding(padding: const EdgeInsets.only(bottom: 16), child: c),
              ],
            );
          }
          return Row(
            children: [
              for (final c in cards) Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: c)),
            ],
          );
        }),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final HowItWorksStep step;
  final Color color;
  final String illustration;

  const _StepCard({required this.step, required this.color, required this.illustration});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
            child: SvgPicture.asset(illustration, width: 46, height: 46),
          ),
          const SizedBox(height: 18),
          Text(
            '${step.number}. ${step.title}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(step.description, style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _SostenibilidadSection extends StatelessWidget {
  const _SostenibilidadSection();

  static const _features = [
    (Icons.eco_outlined, 'Ahorro de CO2 medido', 'Cada viaje compartido calcula cuánto CO2 evitas emitir frente a ir en carro solo, con tu histórico acumulado.'),
    (Icons.bar_chart_rounded, 'Estadísticas en tiempo real', 'Consulta tu participación, viajes realizados y el ahorro colectivo de la comunidad por semana, mes o semestre.'),
    (Icons.picture_as_pdf_outlined, 'Reportes descargables', 'Exporta tus indicadores de sostenibilidad en PDF o Excel cuando los necesites para tus registros.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionHeader(
              eyebrow: 'Sostenibilidad',
              title: 'Tu impacto ambiental, medido',
              icon: Icons.eco_outlined,
            ),
            const SizedBox(height: 36),
            LayoutBuilder(builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 860;
              final cards = [
                for (final f in _features) _FeatureCard(icon: f.$1, title: f.$2, description: f.$3, iconColor: AppColors.mintDark)
              ];
              if (isMobile) {
                return Column(children: [for (final c in cards) Padding(padding: const EdgeInsets.only(bottom: 16), child: c)]);
              }
              return Row(
                children: [for (final c in cards) Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: c))],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SeguridadSection extends StatelessWidget {
  const _SeguridadSection();

  static const _features = [
    (Icons.chat_bubble_outline, 'Chat integrado', 'Coordina el punto de encuentro con tu conductor o pasajeros sin salir de la app.'),
    (Icons.sos_rounded, 'Botón de emergencia', 'Comparte tu ubicación en tiempo real con tu contacto de confianza y con seguridad institucional en un toque.'),
    (Icons.alt_route, 'Alertas por desvío de ruta', 'Si el trayecto se desvía del plan, el sistema notifica automáticamente al conductor y a los pasajeros.'),
    (Icons.verified_user_outlined, 'Conductores verificados', 'Todos los conductores pasan por validación institucional antes de poder publicar un viaje.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: ResponsiveContainer(
        child: Column(
          children: [
            SectionHeader(
              eyebrow: 'Seguridad',
              title: 'Viaja acompañado, siempre',
              icon: Icons.shield_outlined,
              eyebrowColor: AppColors.coralDeep,
            ),
            const SizedBox(height: 36),
            LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              int columns = 4;
              if (width < 860) columns = 2;
              if (width < 480) columns = 1;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final f in _features)
                    SizedBox(
                      width: (width - (columns - 1) * 16) / columns,
                      child: _FeatureCard(icon: f.$1, title: f.$2, description: f.$3, iconColor: AppColors.coral),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor = AppColors.mintDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.blueAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _CommunitySection extends StatelessWidget {
  const _CommunitySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionHeader(
              eyebrow: 'Para toda la comunidad',
              title: 'Un rol para cada miembro',
              icon: Icons.groups_outlined,
              eyebrowColor: AppColors.blueAccentDark,
            ),
            const SizedBox(height: 36),
            LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              int columns = 4;
              if (width < 860) columns = 2;
              if (width < 480) columns = 1;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final role in MockData.communityRoles)
                    SizedBox(
                      width: (width - (columns - 1) * 16) / columns,
                      child: _RoleCard(role: role),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final CommunityRole role;
  const _RoleCard({required this.role});

  static const _icons = {
    'Pasajero': Icons.person_outline,
    'Conductor': Icons.directions_car_outlined,
    'Acompañante': Icons.group_outlined,
    'Profesor': Icons.school_outlined,
  };

  static const _accents = {
    'Pasajero': AppColors.blueAccent,
    'Conductor': AppColors.mintDark,
    'Acompañante': AppColors.blueAccent,
    'Profesor': AppColors.mintDark,
  };

  @override
  Widget build(BuildContext context) {
    final accent = _accents[role.title] ?? AppColors.mintDark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(_icons[role.title] ?? Icons.person_outline, size: 18, color: accent),
          ),
          const SizedBox(height: 18),
          Text(role.title, style: TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            role.description,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12.5, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ImpactSection extends StatelessWidget {
  const _ImpactSection();

  static List<(Color, Color)> get _statStyles => [
    (AppColors.mintDeep, const Color(0x142ED9A8)),
    (AppColors.blueAccentDark, const Color(0x144F7CFF)),
    (AppColors.mintDeep, const Color(0x142ED9A8)),
    (AppColors.blueAccentDark, const Color(0x144F7CFF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionHeader(
              eyebrow: 'Impacto colectivo',
              title: 'Menos autos, más comunidad',
              icon: Icons.public_rounded,
            ),
            const SizedBox(height: 36),
            LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              int columns = 4;
              if (width < 700) columns = 2;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final entry in MockData.impactStatsFooter.indexed)
                    SizedBox(
                      width: (width - (columns - 1) * 16) / columns,
                      child: StatTile(
                        value: entry.$2.value,
                        label: entry.$2.label,
                        valueColor: _statStyles[entry.$1 % _statStyles.length].$1,
                        background: _statStyles[entry.$1 % _statStyles.length].$2,
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Center(
        child: Text(
          'RidECI — Escuela Colombiana de Ingeniería Julio Garavito · acceso restringido a correos '
          '@escuelaing.edu.co / @mail.escuelaing.edu.co',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
