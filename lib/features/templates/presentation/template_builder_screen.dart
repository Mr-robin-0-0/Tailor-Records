import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../application/template_notifier.dart';
import '../data/measurement_template.dart';

class TemplateBuilderScreen extends ConsumerStatefulWidget {
  final MeasurementTemplate? templateToEdit;

  const TemplateBuilderScreen({super.key, this.templateToEdit});

  @override
  ConsumerState<TemplateBuilderScreen> createState() => _TemplateBuilderScreenState();
}

class _TemplateBuilderScreenState extends ConsumerState<TemplateBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final TextEditingController _fieldController = TextEditingController();
  final List<String> _fields = [];
  String? _errorMessage;
  late String _initialName;
  late List<String> _initialFields;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.templateToEdit?.templateName ?? '');
    if (widget.templateToEdit != null) {
      _fields.addAll(widget.templateToEdit!.fieldNames);
    }
    _initialName = _nameController.text;
    _initialFields = List<String>.from(_fields);
  }

  bool get _hasUnsavedChanges {
    if (_nameController.text.trim() != _initialName.trim()) return true;
    if (_fields.length != _initialFields.length) return true;
    for (var i = 0; i < _fields.length; i++) {
      if (_fields[i] != _initialFields[i]) return true;
    }
    return false;
  }

  Future<void> _handleBack() async {
    if (_hasUnsavedChanges) {
      final discard = await showDiscardUnsavedDialog(context);
      if (discard != true) return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fieldController.dispose();
    super.dispose();
  }

  void _addField() {
    final fieldName = _fieldController.text.trim();
    if (fieldName.isEmpty) return;

    if (_fields.any((f) => f.toLowerCase() == fieldName.toLowerCase())) {
      showAppleSnackBar(context, 'Field already exists');
      return;
    }

    setState(() {
      _fields.add(fieldName);
      _fieldController.clear();
    });
  }

  void _removeField(int index) {
    setState(() => _fields.removeAt(index));
  }

  Future<void> _saveTemplate() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    if (_fields.isEmpty) {
      showAppleSnackBar(context, 'Add at least one field');
      return;
    }

    final name = _nameController.text.trim();
    final notifier = ref.read(templateProvider.notifier);

    try {
      if (widget.templateToEdit == null) {
        await notifier.addTemplate(name, _fields);
        if (mounted) Navigator.of(context).pop('created');
      } else {
        await notifier.updateTemplate(widget.templateToEdit!.id, name, _fields);
        if (mounted) Navigator.of(context).pop('saved');
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
    final isEditing = widget.templateToEdit != null;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
      backgroundColor: AppColors.groupedBackground(context),
      appBar: appleAppBar(
        context,
        title: isEditing ? 'Edit Template' : 'New Template',
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.systemBlue,
          onPressed: _handleBack,
        ),
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: _saveTemplate,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const AppleSectionLabel('Details'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Template name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Name required';
                  return null;
                },
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Text(_errorMessage!, style: const TextStyle(color: AppColors.systemRed)),
              ),
            const AppleSectionLabel('Fields'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fieldController,
                      decoration: const InputDecoration(hintText: 'Chest, Waist, Sleeve…'),
                      onFieldSubmitted: (_) => _addField(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.all(12),
                    onPressed: _addField,
                    child: const Icon(CupertinoIcons.add, size: 22),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_fields.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
                child: AppleEmptyState(
                  icon: CupertinoIcons.list_bullet,
                  title: 'No fields',
                  message: 'Add measurement field names above.',
                ),
              )
            else
              AppleInsetGroup(
                children: _fields.asMap().entries.map((entry) {
                  final index = entry.key;
                  final field = entry.value;
                  return AppleListRow(
                    title: field,
                    showChevron: false,
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () => _removeField(index),
                      child: const Icon(CupertinoIcons.minus_circle, color: AppColors.systemRed, size: 22),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    ),
    );
  }
}
