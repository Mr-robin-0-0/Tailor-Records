import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import '../../customers/application/customer_notifier.dart';
import '../../customers/data/customer.dart';
import '../application/family_notifier.dart';

Future<void> showAddFamilyMemberSheet(BuildContext context, {required int familyId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => AddFamilyMemberSheet(familyId: familyId),
  );
}

class AddFamilyMemberSheet extends ConsumerWidget {
  const AddFamilyMemberSheet({super.key, required this.familyId});

  final int familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedIds = ref.read(familyProvider.notifier).assignedCustomerIds;
    final ungrouped = ref
        .watch(customerProvider)
        .where((c) => !assignedIds.contains(c.id))
        .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Add Family Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('New member'),
              subtitle: const Text('Create a customer and add to this family'),
              onTap: () async {
                Navigator.of(context).pop();
                await showDialog<void>(
                  context: context,
                  builder: (dialogContext) => _CreateAndAddMemberDialog(familyId: familyId),
                );
              },
            ),
            if (ungrouped.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No ungrouped customers available.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ungrouped.length,
                  itemBuilder: (context, index) {
                    final customer = ungrouped[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?'),
                      ),
                      title: Text(customer.name),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _promptRelationAndAdd(context, ref, familyId: familyId, customer: customer);
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
}

class _CreateAndAddMemberDialog extends ConsumerStatefulWidget {
  const _CreateAndAddMemberDialog({required this.familyId});

  final int familyId;

  @override
  ConsumerState<_CreateAndAddMemberDialog> createState() => _CreateAndAddMemberDialogState();
}

class _CreateAndAddMemberDialogState extends ConsumerState<_CreateAndAddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final customer = await ref.read(customerProvider.notifier).addCustomer(
            name: _nameController.text.trim(),
          );
      await ref.read(familyProvider.notifier).addMember(
            familyId: widget.familyId,
            customerId: customer.id,
            relation: _relationController.text.trim(),
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member added to family')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Family Member'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _relationController,
              decoration: const InputDecoration(labelText: 'Relation (optional)', hintText: 'Father, Son, etc.'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}

Future<void> _promptRelationAndAdd(
  BuildContext context,
  WidgetRef ref, {
  required int familyId,
  required Customer customer,
}) async {
  final relationController = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add ${customer.name}'),
      content: TextField(
        controller: relationController,
        decoration: const InputDecoration(
          labelText: 'Relation (optional)',
          hintText: 'Father, Mother, Son...',
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Add')),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    await ref.read(familyProvider.notifier).addMember(
          familyId: familyId,
          customerId: customer.id,
          relation: relationController.text.trim(),
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${customer.name} added to family')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }
}
