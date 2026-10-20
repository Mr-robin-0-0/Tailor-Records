import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../../families/application/family_notifier.dart';
import '../../families/data/family.dart';
import '../../families/presentation/customer_family_actions.dart';
import '../../templates/application/template_notifier.dart';
import '../application/customer_notifier.dart';
import '../data/customer.dart';
import 'customer_form_dialog.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final int customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  bool _isEditing = false;
  String? _selectedTemplateName; // When set, we show the measurement detail page
  
  // Controllers and Undo/Redo stacks
  final Map<String, TextEditingController> _controllers = {};
  final List<Map<String, String>> _undoStack = [];
  final List<Map<String, String>> _redoStack = [];
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  void _initializeControllers(Customer customer, String templateName, List<String> fields) {
    _disposeControllers();
    final currentValues = customer.measurements[templateName] ?? {};
    
    for (final field in fields) {
      final value = currentValues[field] ?? '';
      final controller = TextEditingController(text: value);
      controller.addListener(() {
        _onFieldChanged();
      });
      _controllers[field] = controller;
    }
    
    _undoStack.clear();
    _redoStack.clear();
    _undoStack.add(_getCurrentValuesMap());
  }

  Map<String, String> _getCurrentValuesMap() {
    return _controllers.map((key, value) => MapEntry(key, value.text));
  }

  void _onFieldChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final currentMap = _getCurrentValuesMap();
      if (_undoStack.isEmpty || !_mapsEqual(_undoStack.last, currentMap)) {
        setState(() {
          _undoStack.add(currentMap);
          _redoStack.clear();
        });
      }
    });
  }

  bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  void _undo() {
    if (_undoStack.length > 1) {
      setState(() {
        final current = _undoStack.removeLast();
        _redoStack.add(current);
        final previous = _undoStack.last;
        _applyValuesMap(previous);
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        final next = _redoStack.removeLast();
        _undoStack.add(next);
        _applyValuesMap(next);
      });
    }
  }

  void _applyValuesMap(Map<String, String> map) {
    _debounceTimer?.cancel();
    map.forEach((field, val) {
      if (_controllers.containsKey(field)) {
        _controllers[field]!.value = TextEditingValue(
          text: val,
          selection: TextSelection.collapsed(offset: val.length),
        );
      }
    });
  }

  bool _hasUnsavedMeasurementEdits(Customer customer, String templateName) {
    if (!_isEditing) return false;
    final saved = customer.measurements[templateName] ?? {};
    final current = _getCurrentValuesMap();
    final keys = {...saved.keys, ...current.keys};
    for (final key in keys) {
      if ((saved[key] ?? '').trim() != (current[key] ?? '').trim()) {
        return true;
      }
    }
    return false;
  }

  void _exitEditMode(Customer customer) {
    setState(() {
      _isEditing = false;
      if (_selectedTemplateName != null) {
        final savedValues = customer.measurements[_selectedTemplateName];
        if (savedValues == null || savedValues.isEmpty) {
          _selectedTemplateName = null;
        }
      }
      _disposeControllers();
    });
  }

  Future<void> _handleBackNavigation(Customer customer) async {
    if (_isEditing && _selectedTemplateName != null) {
      if (_hasUnsavedMeasurementEdits(customer, _selectedTemplateName!)) {
        final discard = await showDiscardUnsavedDialog(context);
        if (discard != true) return;
      }
      _exitEditMode(customer);
      return;
    }

    if (_selectedTemplateName != null) {
      setState(() => _selectedTemplateName = null);
      return;
    }

    if (mounted) Navigator.of(context).pop();
  }

  String _formatUpdatedAt(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }

  void _saveMeasurements(Customer customer, String templateName) async {
    final values = _getCurrentValuesMap();
    
    // Check if all measurement values are empty
    final bool allEmpty = values.values.every((v) => v.trim().isEmpty);

    if (allEmpty) {
      if (!mounted) return;
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white, width: 0.5),
          ),
          title: const Text('Empty Measurements'),
          content: Text(
            'All measurement fields for "$templateName" are empty. Would you like to remove this template from this profile?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      );

      if (shouldDelete == true) {
        await ref.read(customerProvider.notifier).deleteMeasurementTemplate(
              customerId: customer.id,
              templateName: templateName,
            );
        setState(() {
          _isEditing = false;
          _selectedTemplateName = null; // Go back to template list
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"$templateName" removed from profile')),
          );
        }
      }
      return;
    }

    await ref.read(customerProvider.notifier).updateMeasurements(
          customerId: customer.id,
          templateName: templateName,
          values: values,
        );

    setState(() {
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Measurements saved for $templateName')),
      );
    }
  }

  void _shareMeasurements(Customer customer, String templateName) {
    final values = customer.measurements[templateName] ?? {};
    if (values.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No measurements recorded to share')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('${customer.name} - Measurements ($templateName)');
    buffer.writeln('-----------------------------------');
    values.forEach((key, val) {
      buffer.writeln('$key: ${val.isEmpty ? '—' : val}');
    });
    buffer.writeln('-----------------------------------');
    buffer.writeln('Generated via Tailor Records');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Measurements copied to clipboard!')),
    );
  }

  Future<void> _confirmDeleteCustomer(Customer customer) async {
    final confirmed = await showAppleConfirmDialog(
      context,
      title: 'Delete Profile?',
      message:
          'Delete ${customer.name}? All measurement records for this client will be removed permanently.',
      cancel: 'Cancel',
      confirm: 'Delete',
      destructive: true,
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref.read(customerProvider.notifier).deleteCustomer(customer.id);
      ref.read(familyProvider.notifier).reload();
      if (!mounted) return;
      Navigator.of(context).pop();
      showAppleSnackBar(context, '${customer.name} deleted');
    } catch (e) {
      if (!mounted) return;
      showAppleSnackBar(context, e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> _confirmDeleteMeasurements(Customer customer, String templateName) async {
    final confirmed = await showAppleConfirmDialog(
      context,
      title: 'Delete Measurements?',
      message:
          'Delete all "$templateName" measurements for ${customer.name}? This cannot be undone.',
      confirm: 'Delete',
      destructive: true,
    );
    if (confirmed != true || !mounted) return;

    await ref.read(customerProvider.notifier).deleteMeasurementTemplate(
          customerId: customer.id,
          templateName: templateName,
        );
    setState(() {
      _isEditing = false;
      _selectedTemplateName = null;
    });
    if (mounted) {
      showAppleSnackBar(context, '"$templateName" measurements deleted');
    }
  }

  void _selectTemplateToAdd(Customer customer) {
    final allTemplates = ref.read(templateProvider);
    if (allTemplates.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white, width: 0.5),
          ),
          title: const Text('No Templates'),
          content: const Text('Please create a measurement template in the Template Manager first.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Only show templates NOT yet recorded for this customer
    final templates = allTemplates.where((t) => !customer.measurements.containsKey(t.templateName)).toList();

    if (templates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All templates have already been added to this profile.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Choose a Template',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final t = templates[index];
                  return ListTile(
                    leading: const Icon(Icons.architecture_outlined),
                    title: Text(t.templateName),
                    subtitle: Text('${t.fieldNames.length} fields'),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _selectedTemplateName = t.templateName;
                        _isEditing = true;
                        _initializeControllers(customer, t.templateName, t.fieldNames);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerList = ref.watch(customerProvider);
    final customer = customerList.where((c) => c.id == widget.customerId).firstOrNull;

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Customer not found.')),
      );
    }

    final templates = ref.watch(templateProvider);
    final bool showingDetail = _selectedTemplateName != null;

    // Resolve fields for the selected template
    List<String> fields = [];
    if (_selectedTemplateName != null) {
      final templateMatch = templates.where((t) => t.templateName == _selectedTemplateName).firstOrNull;
      if (templateMatch != null) {
        fields = templateMatch.fieldNames;
      } else {
        fields = customer.measurements[_selectedTemplateName]?.keys.toList() ?? [];
      }
    }

    final canPopScreen = !_isEditing && _selectedTemplateName == null;

    return PopScope(
      canPop: canPopScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation(customer);
      },
      child: Scaffold(
      backgroundColor: AppColors.groupedBackground(context),
      appBar: appleAppBar(
        context,
        title: customer.name,
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.systemBlue,
          onPressed: () => _handleBackNavigation(customer),
        ),
        actions: _buildAppBarActions(customer, showingDetail, fields),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            children: <Widget>[
              ...previousChildren.map((child) => Positioned.fill(child: child)),
              if (currentChild != null) Positioned.fill(child: currentChild),
            ],
          );
        },
        transitionBuilder: (child, animation) {
          // Slide from right when entering detail, slide from left when going back
          final isDetail = child.key == const ValueKey('detail');
          final offset = isDetail
              ? Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              : Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero);
          return SlideTransition(
            position: offset.animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
        child: showingDetail
            ? _buildMeasurementDetailPage(
                key: const ValueKey('detail'),
                customer: customer,
                templateName: _selectedTemplateName!,
                fields: fields,
              )
            : _buildTemplateListPage(
                key: const ValueKey('list'),
                customer: customer,
              ),
      ),
    ),
    );
  }

  List<Widget> _buildAppBarActions(Customer customer, bool showingDetail, List<String> fields) {
    if (_isEditing) {
      return [
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: _undoStack.length > 1 ? _undo : null,
        ),
        IconButton(
          icon: const Icon(Icons.redo),
          onPressed: _redoStack.isNotEmpty ? _redo : null,
        ),
        TextButton(
          onPressed: () => _saveMeasurements(customer, _selectedTemplateName!),
          child: Text(
            'Done',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.systemBlue,
            ),
          ),
        ),
      ];
    }

    if (showingDetail) {
      // Detail view: edit and delete icons
      return [
        IconButton(
          icon: const Icon(CupertinoIcons.pencil, color: AppColors.systemBlue),
          tooltip: 'Edit Measurements',
          onPressed: () {
            setState(() {
              _isEditing = true;
              _initializeControllers(customer, _selectedTemplateName!, fields);
            });
          },
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.delete, color: AppColors.systemRed),
          tooltip: 'Delete Measurements',
          onPressed: () => _confirmDeleteMeasurements(customer, _selectedTemplateName!),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          tooltip: 'Share',
          onPressed: () => _shareMeasurements(customer, _selectedTemplateName!),
        ),
      ];
    }

    return [
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white, width: 0.5),
        ),
        onSelected: (choice) {
          Future.microtask(() async {
            if (!mounted) return;
            if (choice == 'edit') {
              showCustomerFormDialog(context, customerToEdit: customer);
            } else if (choice == 'add_family') {
              await showAddCustomerToFamilyPicker(context, ref, customer);
            } else if (choice == 'remove_family') {
              await removeCustomerFromFamily(context, ref, customer);
            } else if (choice == 'delete') {
              await _confirmDeleteCustomer(customer);
            }
          });
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 8),
                  const Text('Edit Profile'),
                ],
              ),
            ),
            ...customerFamilyMenuItems(ref, customer),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(CupertinoIcons.delete, size: 18, color: AppColors.systemRed),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.systemRed)),
                ],
              ),
            ),
          ];
        },
      ),
    ];
  }

  Family? _familyForCustomer(int customerId) {
    final families = ref.watch(familyProvider);
    for (final family in families) {
      if (family.members.any((m) => m.customerId == customerId)) {
        return family;
      }
    }
    return null;
  }

  // ─── PAGE 1: Template List ───────────────────────────────────────────
  Widget _buildTemplateListPage({Key? key, required Customer customer}) {
    final allTemplates = ref.watch(templateProvider);
    final savedTemplateNames = customer.measurements.keys.toList();
    final hasUnadded = allTemplates.any((t) => !customer.measurements.containsKey(t.templateName));
    final family = _familyForCustomer(customer.id);

    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildProfileSummary(customer, family),
          const AppleSectionLabel('Measurements'),
          _buildMeasurementsGroup(
            customer: customer,
            savedTemplateNames: savedTemplateNames,
            hasUnadded: hasUnadded,
            hasAnyTemplates: allTemplates.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSummary(Customer customer, Family? family) {
    return AppleInsetGroup(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppleAvatar(name: customer.name, radius: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name, style: appleRowTitle(context).copyWith(fontSize: 20)),
                    if (family != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        family.familyName,
                        style: appleRowSubtitle(context).copyWith(color: AppColors.systemBlue),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      'Updated ${_formatUpdatedAt(customer.updatedAt)}',
                      style: appleRowSubtitle(context).copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementsGroup({
    required Customer customer,
    required List<String> savedTemplateNames,
    required bool hasUnadded,
    required bool hasAnyTemplates,
  }) {
    final children = <Widget>[];

    if (savedTemplateNames.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Column(
            children: [
              Icon(
                CupertinoIcons.arrow_up_down_square,
                size: 36,
                color: AppColors.secondaryLabel(context),
              ),
              const SizedBox(height: 10),
              Text('No measurements yet', style: appleRowTitle(context)),
              const SizedBox(height: 4),
              Text(
                hasAnyTemplates
                    ? 'Choose a template below to record sizes.'
                    : 'Create a measurement template first, then add it here.',
                textAlign: TextAlign.center,
                style: appleRowSubtitle(context),
              ),
            ],
          ),
        ),
      );
    } else {
      for (final templateName in savedTemplateNames) {
        final values = customer.measurements[templateName] ?? {};
        final filledCount = values.values.where((v) => v.trim().isNotEmpty).length;
        final totalCount = values.length;
        children.add(
          AppleListRow(
            title: templateName,
            subtitle: '$filledCount of $totalCount fields filled',
            leading: Icon(CupertinoIcons.arrow_up_down_square, color: AppColors.systemBlue, size: 22),
            onTap: () {
              setState(() {
                _selectedTemplateName = templateName;
                _isEditing = false;
              });
            },
          ),
        );
      }
    }

    if (hasUnadded) {
      children.add(_AddMeasurementRow(onTap: () => _selectTemplateToAdd(customer)));
    }

    if (children.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
        child: Text(
          'Create a measurement template in Templates to get started.',
          style: appleRowSubtitle(context),
        ),
      );
    }

    return AppleInsetGroup(children: children);
  }

  // ─── PAGE 2: Measurement Detail ──────────────────────────────────────
  Widget _buildMeasurementDetailPage({
    Key? key,
    required Customer customer,
    required String templateName,
    required List<String> fields,
  }) {

    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(templateName, style: appleLargeTitle(context).copyWith(fontSize: 28)),
                const SizedBox(height: 4),
                Text('${customer.name} · ${fields.length} fields', style: appleRowSubtitle(context)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (fields.isEmpty)
            AppleInsetGroup(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('No fields in this template.', style: appleRowSubtitle(context)),
                ),
              ],
            )
          else
            _buildMeasurementsTable(customer, templateName, fields),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMeasurementsTable(Customer customer, String templateName, List<String> fieldList) {
    final currentValues = customer.measurements[templateName] ?? {};

    return AppleInsetGroup(
      children: fieldList.map((field) {
        final val = currentValues[field] ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(child: Text(field, style: appleRowTitle(context))),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: _isEditing
                    ? TextFormField(
                        controller: _controllers[field],
                        textAlign: TextAlign.end,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        style: appleRowTitle(context).copyWith(fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '—',
                        ),
                      )
                    : Text(
                        val.isEmpty ? '—' : val,
                        textAlign: TextAlign.end,
                        style: appleRowTitle(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.systemBlue,
                        ),
                      ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AddMeasurementRow extends StatelessWidget {
  const _AddMeasurementRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ApplePressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.plus_circle_fill, color: AppColors.systemBlue, size: 22),
            const SizedBox(width: 8),
            Text(
              'Add Measurements',
              style: appleRowTitle(context).copyWith(
                color: AppColors.systemBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
