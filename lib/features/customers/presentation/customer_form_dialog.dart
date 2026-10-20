import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../application/customer_notifier.dart';
import '../data/customer.dart';

class CustomerFormDialog extends ConsumerStatefulWidget {
  final Customer? customerToEdit;

  const CustomerFormDialog({super.key, this.customerToEdit});

  @override
  ConsumerState<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends ConsumerState<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customerToEdit?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final notifier = ref.read(customerProvider.notifier);

    try {
      if (widget.customerToEdit == null) {
        await notifier.addCustomer(name: name);
        if (mounted) {
          showAppleSnackBar(context, 'Customer added');
          Navigator.of(context).pop();
        }
      } else {
        await notifier.updateCustomer(id: widget.customerToEdit!.id, name: name);
        if (mounted) {
          showAppleSnackBar(context, 'Profile updated');
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
    final isEditing = widget.customerToEdit != null;

    return CupertinoAlertDialog(
      title: Text(isEditing ? 'Edit Customer' : 'New Customer'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: _nameController,
              placeholder: 'Full name',
              textCapitalization: TextCapitalization.words,
              padding: const EdgeInsets.all(12),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.systemRed, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: _saveCustomer,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

void showCustomerFormDialog(BuildContext context, {Customer? customerToEdit}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CustomerFormDialog(customerToEdit: customerToEdit),
  );
}
