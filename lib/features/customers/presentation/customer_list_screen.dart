import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../../families/application/family_notifier.dart';
import '../../families/data/family.dart';
import '../../families/presentation/family_detail_screen.dart';
import '../../families/presentation/family_form_dialog.dart';
import '../../settings/presentation/settings_screen.dart';
import '../application/customer_notifier.dart';
import '../data/customer.dart';
import 'customer_detail_screen.dart';
import 'customer_form_dialog.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final result = await showAppleConfirmDialog(
      context,
      title: 'Exit Tailor Records?',
      message: 'Are you sure you want to close the app?',
      cancel: 'Stay',
      confirm: 'Exit',
      destructive: true,
    );
    return result ?? false;
  }

  Future<void> _showAddMenu() async {
    final choice = await showAppleActionSheet<String>(
      context,
      title: 'Add',
      options: [
        (label: 'New Customer', value: 'customer', destructive: false),
        (label: 'New Family', value: 'family', destructive: false),
      ],
    );
    if (!mounted) return;
    if (choice == 'customer') showCustomerFormDialog(context);
    if (choice == 'family') showFamilyFormDialog(context);
  }

  String? _familyNameFor(WidgetRef ref, int customerId) {
    return ref.read(familyProvider.notifier).familyForCustomer(customerId)?.familyName;
  }

  void _openCustomer(Customer customer) {
    Navigator.of(context).push(
      appPageRoute((_) => CustomerDetailScreen(customerId: customer.id)),
    );
  }

  void _openFamily(Family family) {
    Navigator.of(context).push(
      appPageRoute((_) => FamilyDetailScreen(familyId: family.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeSectionsProvider);
    final allCustomers = ref.watch(customerProvider);
    final families = ref.watch(familyProvider);
    final customers = ref.watch(customerProvider);
    final searchQuery = ref.watch(customerSearchQueryProvider).trim().toLowerCase();
    final isSearching = searchQuery.isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmationDialog(context);
        if (shouldPop && context.mounted) SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.groupedBackground(context),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/logo.png', width: 36, height: 36),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  'Tailor Records',
                                  style: appleLargeTitle(context).copyWith(fontSize: 26, height: 1.15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.all(8),
                          onPressed: () {
                            Navigator.of(context).push(
                              appPageRoute((_) => const SettingsScreen()),
                            );
                          },
                          child: Icon(CupertinoIcons.gear_alt, color: AppColors.secondaryLabel(context), size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AppleSearchField(
                      controller: _searchController,
                      hintText: 'Search',
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      onChanged: (val) => ref.read(customerSearchQueryProvider.notifier).state = val,
                      onClear: () {
                        _searchController.clear();
                        ref.read(customerSearchQueryProvider.notifier).state = '';
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: homeData.isEmpty
                    ? AppleEmptyState(
                        icon: CupertinoIcons.person_2,
                        title: 'No clients yet',
                        message: 'Add a customer to start recording measurements.',
                        actionLabel: 'Add Customer',
                        onAction: () => showCustomerFormDialog(context),
                      )
                    : !homeData.hasSearchResults
                        ? AppleEmptyState(
                            icon: CupertinoIcons.search,
                            title: 'No results',
                            message: 'Try a different name.',
                          )
                        : isSearching
                            ? _buildSearchResults(searchQuery, families, customers)
                            : _buildBrowseList(homeData),
              ),
            ],
          ),
        ),
        floatingActionButton: allCustomers.isEmpty
            ? null
            : FloatingActionButton(
                heroTag: 'home_fab',
                onPressed: _showAddMenu,
                child: const Icon(CupertinoIcons.add, size: 28),
              ),
      ),
    );
  }

  Widget _buildBrowseList(HomeListData homeData) {
    final showFamilySection = homeData.familySections.isNotEmpty;
    final showClientSection = homeData.ungroupedCustomers.isNotEmpty;
    final showBothHeaders = showFamilySection && showClientSection;

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        if (showFamilySection) ...[
          if (showBothHeaders) const AppleSectionLabel('Families', isFirstSection: true),
          AppleInsetGroup(
            children: homeData.familySections
                .map((section) => _familyRow(section.family, memberCount: section.members.length))
                .toList(),
          ),
        ],
        if (showClientSection) ...[
          if (showBothHeaders)
            AppleSectionLabel('Clients', isFirstSection: !showFamilySection),
          AppleInsetGroup(
            children: homeData.ungroupedCustomers.map((c) => _customerRow(c)).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchResults(String query, List<Family> families, List<Customer> customers) {
    final rows = <Widget>[];

    for (final family in families) {
      if (family.familyName.toLowerCase().contains(query)) {
        rows.add(_familyRow(family, memberCount: family.members.length));
      }
    }

    for (final customer in customers) {
      if (customer.name.toLowerCase().contains(query)) {
        rows.add(_customerRow(customer, subtitle: _familyNameFor(ref, customer.id)));
      }
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        AppleInsetGroup(children: rows),
      ],
    );
  }

  Widget _familyRow(Family family, {required int memberCount}) {
    final countLabel = memberCount == 1 ? '1 member' : '$memberCount members';
    return AppleListRow(
      title: family.familyName,
      subtitle: countLabel,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.systemBlue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(CupertinoIcons.house_fill, color: AppColors.systemBlue, size: 20),
      ),
      onTap: () => _openFamily(family),
    );
  }

  Widget _customerRow(Customer customer, {String? subtitle}) {
    return AppleListRow(
      title: customer.name,
      subtitle: subtitle,
      leading: AppleAvatar(name: customer.name, radius: 18),
      onTap: () => _openCustomer(customer),
    );
  }
}
