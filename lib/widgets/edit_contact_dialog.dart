import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';

/// Edits a trusted contact's name, relation and phone. Returns the updated
/// contact, or null if the user cancels.
Future<EmergencyContact?> showEditContactDialog(BuildContext context, {required EmergencyContact contact}) {
  return showDialog<EmergencyContact>(
    context: context,
    builder: (context) => _EditContactDialog(contact: contact),
  );
}

class _EditContactDialog extends StatefulWidget {
  final EmergencyContact contact;
  const _EditContactDialog({required this.contact});

  @override
  State<_EditContactDialog> createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<_EditContactDialog> {
  late final _nameController = TextEditingController(text: widget.contact.name);
  late final _relationController = TextEditingController(text: widget.contact.relation);
  late final _phoneController = TextEditingController(text: widget.contact.phone);

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _nameController.text.trim().isNotEmpty && _phoneController.text.trim().isNotEmpty;
    return StatefulBuilder(builder: (context, setLocalState) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Editar contacto de confianza', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              onChanged: (_) => setLocalState(() {}),
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _relationController,
              decoration: const InputDecoration(labelText: 'Parentesco'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              onChanged: (_) => setLocalState(() {}),
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: !canSave
                ? null
                : () => Navigator.of(context).pop(
                      EmergencyContact(
                        name: _nameController.text.trim(),
                        relation: _relationController.text.trim(),
                        phone: _phoneController.text.trim(),
                      ),
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mint,
              foregroundColor: AppColors.deepGreenDarker,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      );
    });
  }
}
