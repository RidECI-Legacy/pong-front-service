import 'package:flutter/material.dart';

import 'components/buttons.dart';
import 'components/glass_card.dart';
import 'theme.dart';

/// Small shared feedback helpers (snackbar, emergency confirm, chat) kept
/// in one place and styled with the dark passenger/landing design system,
/// so we don't pull in the app-wide (light/dark toggle) dialogs used by
/// the rest of the app and break visual consistency.
void showActionSnack(BuildContext context, String message, {IconData icon = Icons.check_circle_rounded, SnackBarAction? action}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: LandingColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: LandingColors.glassBorder)),
        duration: action != null ? const Duration(seconds: 4) : const Duration(seconds: 3),
        action: action,
        content: Row(
          children: [
            Icon(icon, size: 18, color: LandingColors.success),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 12.5))),
          ],
        ),
      ),
    );
}

Future<void> showEmergencyDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: LandingEffects.glassChild(
          radius: 20,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: LandingEffects.glassDecoration(radius: 20, tint: LandingColors.bgSurface.withValues(alpha: 0.94)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.sos_rounded, color: LandingColors.danger, size: 32),
                const SizedBox(height: 14),
                Text('¿Enviar alerta de emergencia?', style: LandingType.cardTitle(size: 17)),
                const SizedBox(height: 8),
                Text(
                  'Se compartirá tu ubicación en tiempo real con tu contacto de confianza y con seguridad institucional.',
                  style: LandingType.body(size: 12.5),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: SecondaryButton(label: 'Cancelar', onTap: () => Navigator.of(context).pop(false))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(label: 'Confirmar', onTap: () => Navigator.of(context).pop(true)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  if (confirmed == true && context.mounted) {
    showActionSnack(context, 'Alerta enviada con tu ubicación a tu contacto y a seguridad institucional.', icon: Icons.sos_rounded);
  }
}

class _ChatMessage {
  final String text;
  final bool fromMe;
  _ChatMessage(this.text, this.fromMe);
}

Future<void> showTripChatDialog(BuildContext context, {required String withName}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) => _ChatDialog(withName: withName),
  );
}

class _ChatDialog extends StatefulWidget {
  final String withName;
  const _ChatDialog({required this.withName});

  @override
  State<_ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<_ChatDialog> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final List<_ChatMessage> _messages = [
    _ChatMessage('Hola! Ya voy en camino, llego en unos minutos 🚗', false),
    _ChatMessage('Perfecto, te espero en la entrada del portal.', true),
    _ChatMessage('Listo, cualquier cosa me avisas por aquí.', false),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _messages.add(_ChatMessage(text, true)));
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: LandingEffects.glassChild(
          radius: 20,
          child: Container(
            decoration: LandingEffects.glassDecoration(radius: 20, tint: LandingColors.bgSurface.withValues(alpha: 0.95)),
            height: 460,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: LandingColors.glassBorder))),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: LandingColors.primary,
                        child: Text(widget.withName.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.withName, style: LandingType.cardTitle(size: 13.5)),
                            Text('Viaje activo', style: LandingType.body(size: 11, color: LandingColors.success)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: LandingColors.textTertiary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final m = _messages[i];
                      return Align(
                        alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          constraints: const BoxConstraints(maxWidth: 260),
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                          decoration: BoxDecoration(
                            gradient: m.fromMe ? LandingColors.buttonGradient : null,
                            color: m.fromMe ? null : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(m.text, style: const TextStyle(fontSize: 12.5, height: 1.4, color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: LandingColors.glassBorder))),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _send(),
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Escribe un mensaje…',
                            hintStyle: const TextStyle(color: LandingColors.textTertiary),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: Colors.transparent,
                        child: DecoratedBox(
                          decoration: BoxDecoration(gradient: LandingColors.buttonGradient, borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: _send,
                            child: const Padding(
                              padding: EdgeInsets.all(11),
                              child: Icon(Icons.send_rounded, size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
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
