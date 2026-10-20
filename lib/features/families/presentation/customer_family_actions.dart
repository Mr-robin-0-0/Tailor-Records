import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import '../../customers/data/customer.dart';
import '../application/family_notifier.dart';
import '../data/family.dart';

Future<void> showAddCustomerToFamilyPicker(BuildContext context, WidgetRef ref, Customer customer) async {
  final families = ref.read(familyProvider);
  final currentFamilyId = ref.read(familyProvider.notifier).familyIdForCustomer(customer.id);

  if (currentFamilyId != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Remove this customer from their current family first.')),
    );
    return;
  }

  if (families.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create a family first from the home screen.')),
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Add ${customer.name} to family', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: families.length,
              itemBuilder: (context, index) {
                final family = families[index];
                return ListTile(
                  leading: const Icon(Icons.family_restroom_outlined),
                  title: Text(family.familyName),
                  subtitle: Text('${family.members.length} members'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _addWithOptionalRelation(context, ref, customer: customer, family: family);
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

Future<void> _addWithOptionalRelation(
  BuildContext context,
  WidgetRef ref, {
  required Customer customer,
  required Family family,
}) async {
  final relationController = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add to ${family.familyName}'),
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
          familyId: family.id,
          customerId: customer.id,
          relation: relationController.text.trim(),
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${customer.name} added to ${family.familyName}')),
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

Future<void> removeCustomerFromFamily(BuildContext context, WidgetRef ref, Customer customer) async {
  final family = ref.read(familyProvider.notifier).familyForCustomer(customer.id);
  if (family == null) return;

  await ref.read(familyProvider.notifier).removeMember(
        familyId: family.id,
        customerId: customer.id,
      );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${customer.name} removed from ${family.familyName}')),
    );
  }
}

Family? _familyForCustomer(List<Family> families, int customerId) {
  for (final family in families) {
    if (family.members.any((m) => m.customerId == customerId)) {
      return family;
    }
  }
  return null;
}

List<PopupMenuEntry<String>> customerFamilyMenuItems(WidgetRef ref, Customer customer) {
  final family = _familyForCustomer(ref.watch(familyProvider), customer.id);
  if (family == null) {
    return [
      const PopupMenuItem(
        value: 'add_family',
        child: Row(
          children: [
            Icon(Icons.family_restroom_outlined, size: 18),
            SizedBox(width: 8),
            Text('Add to family…'),
          ],
        ),
      ),
    ];
  }

  return [
    PopupMenuItem(
      value: 'remove_family',
      child: Row(
        children: [
          const Icon(Icons.link_off_outlined, size: 18),
          const SizedBox(width: 8),
          Text('Remove from ${family.familyName}'),
        ],
      ),
    ),
  ];
}
