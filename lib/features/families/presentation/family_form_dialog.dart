import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../application/family_notifier.dart';
import '../data/family.dart';

class FamilyFormDialog extends ConsumerStatefulWidget {
  const FamilyFormDialog({super.key, this.familyToEdit});

  final Family? familyToEdit;

  @override
  ConsumerState<FamilyFormDialog> createState() => _FamilyFormDialogState();
}

class _FamilyFormDialogState extends ConsumerState<FamilyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.familyToEdit?.familyName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final notifier = ref.read(familyProvider.notifier);

    try {
      if (widget.familyToEdit == null) {
        await notifier.addFamily(familyName: name);
        if (mounted) {
          showAppleSnackBar(context, 'Family created');
          Navigator.of(context).pop();
        }
      } else {
        await notifier.updateFamilyName(id: widget.familyToEdit!.id, familyName: name);
        if (mounted) {
          showAppleSnackBar(context, 'Family renamed');
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.familyToEdit != null;

    return CupertinoAlertDialog(
      title: Text(isEditing ? 'Rename Family' : 'New Family'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: _nameController,
              placeholder: 'Family name',
              textCapitalization: TextCapitalization.words,
              padding: const EdgeInsets.all(12),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_errorMessage!, style: const TextStyle(color: AppColors.systemRed, fontSize: 13)),
              ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        CupertinoDialogAction(isDefaultAction: true, onPressed: _save, child: Text(isEditing ? 'Save' : 'Create')),
      ],
    );
  }
}

void showFamilyFormDialog(BuildContext context, {Family? familyToEdit}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => FamilyFormDialog(familyToEdit: familyToEdit),
  );
}
