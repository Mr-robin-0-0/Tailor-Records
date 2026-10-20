import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../../customers/application/customer_notifier.dart';
import '../../customers/data/customer.dart';
import '../../customers/presentation/customer_detail_screen.dart';
import '../application/family_notifier.dart';
import '../data/family.dart';
import 'add_family_member_sheet.dart';
import 'family_form_dialog.dart';

class FamilyDetailScreen extends ConsumerWidget {
  const FamilyDetailScreen({super.key, required this.familyId});

  final int familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final family = ref.watch(familyProvider).where((f) => f.id == familyId).firstOrNull;
    final customers = ref.watch(customerProvider);
    final customerById = {for (final c in customers) c.id: c};

    if (family == null) {
      return Scaffold(
        appBar: appleAppBar(context, title: 'Family'),
        body: const Center(child: Text('Family not found.')),
      );
    }

    final members = <({Customer customer, String? relation})>[];
    for (final member in family.members) {
      final customer = customerById[member.customerId];
      if (customer != null) {
        members.add((customer: customer, relation: member.relation));
      }
    }
    members.sort((a, b) => a.customer.name.toLowerCase().compareTo(b.customer.name.toLowerCase()));

    return Scaffold(
      backgroundColor: AppColors.groupedBackground(context),
      appBar: appleAppBar(
        context,
        title: family.familyName,
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.systemBlue,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.only(right: 8),
            onPressed: () => showFamilyFormDialog(context, familyToEdit: family),
            child: const Icon(CupertinoIcons.pencil),
          ),
        ],
      ),
      body: members.isEmpty
          ? ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              children: [
                AppleEmptyState(
                  icon: CupertinoIcons.person_2,
                  title: 'No members',
                  message: 'Add existing customers or create someone new for this family.',
                  actionLabel: 'Add Member',
                  onAction: () => showAddFamilyMemberSheet(context, familyId: family.id),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
                  child: CupertinoButton(
                    color: AppColors.systemRed.withValues(alpha: 0.12),
                    onPressed: () => _confirmDeleteFamily(context, ref, family),
                    child: const Text('Delete Family', style: TextStyle(color: AppColors.systemRed)),
                  ),
                ),
              ],
            )
          : ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              children: [
                AppleInsetGroup(
                  children: members
                      .map(
                        (entry) => AppleListRow(
                          title: entry.customer.name,
                          subtitle: entry.relation,
                          leading: AppleAvatar(name: entry.customer.name),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(CupertinoIcons.ellipsis, color: AppColors.secondaryLabel(context)),
                            onSelected: (value) async {
                              if (value == 'relation') {
                                await _editRelation(context, ref, family: family, customerId: entry.customer.id, current: entry.relation);
                              } else if (value == 'remove') {
                                await ref.read(familyProvider.notifier).removeMember(
                                      familyId: family.id,
                                      customerId: entry.customer.id,
                                    );
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'relation', child: Text('Edit relation')),
                              PopupMenuItem(value: 'remove', child: Text('Remove from family')),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              appPageRoute(
                                (_) => CustomerDetailScreen(customerId: entry.customer.id),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
                  child: CupertinoButton(
                    color: AppColors.systemRed.withValues(alpha: 0.12),
                    onPressed: () => _confirmDeleteFamily(context, ref, family),
                    child: const Text('Delete Family', style: TextStyle(color: AppColors.systemRed)),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'family_member_fab_$familyId',
        onPressed: () => showAddFamilyMemberSheet(context, familyId: family.id),
        child: const Icon(CupertinoIcons.person_add),
      ),
    );
  }

  Future<void> _confirmDeleteFamily(BuildContext context, WidgetRef ref, Family family) async {
    final memberCount = family.members.length;

    if (memberCount == 0) {
      final confirmed = await showAppleConfirmDialog(
        context,
        title: 'Delete Family?',
        message: 'Delete "${family.familyName}"? This cannot be undone.',
        confirm: 'Delete',
        destructive: true,
      );
      if (confirmed != true) return;
      await _performDeleteFamily(context, ref, family, deleteMembers: false);
      return;
    }

    final choice = await showAppleActionSheet<String>(
      context,
      title: 'Delete "${family.familyName}"?',
      options: [
        (label: 'Delete family, keep members', value: 'keep', destructive: false),
        (
          label: 'Delete family and all members',
          value: 'all',
          destructive: true,
        ),
      ],
    );
    if (choice == null) return;

    if (choice == 'all') {
      final countLabel = memberCount == 1 ? '1 member' : '$memberCount members';
      final confirmed = await showAppleConfirmDialog(
        context,
        title: 'Delete All Members?',
        message:
            'This permanently deletes $countLabel and all their measurements. This cannot be undone.',
        confirm: 'Delete All',
        destructive: true,
      );
      if (confirmed != true) return;
    }

    await _performDeleteFamily(context, ref, family, deleteMembers: choice == 'all');
  }

  Future<void> _performDeleteFamily(
    BuildContext context,
    WidgetRef ref,
    Family family, {
    required bool deleteMembers,
  }) async {
    await ref.read(familyProvider.notifier).deleteFamily(
          family.id,
          deleteMembers: deleteMembers,
        );
    if (deleteMembers) {
      ref.read(customerProvider.notifier).reload();
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
    if (deleteMembers) {
      showAppleSnackBar(context, '${family.familyName} and members deleted');
    } else {
      showAppleSnackBar(context, '${family.familyName} deleted');
    }
  }

  Future<void> _editRelation(
    BuildContext context,
    WidgetRef ref, {
    required Family family,
    required int customerId,
    String? current,
  }) async {
    final controller = TextEditingController(text: current ?? '');
    final saved = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Relation'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(controller: controller, placeholder: 'Father, Son…'),
        ),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (saved != true) return;

    await ref.read(familyProvider.notifier).updateMemberRelation(
          familyId: family.id,
          customerId: customerId,
          relation: controller.text.trim(),
        );
  }
}
