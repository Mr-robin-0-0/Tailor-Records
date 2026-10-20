import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:isar/isar.dart';
import '../../../core/db/isar_provider.dart';
import '../../customers/application/customer_notifier.dart';
import '../../customers/data/customer.dart';
import '../data/family.dart';

class FamilyNotifier extends StateNotifier<List<Family>> {
  final Isar _isar;

  FamilyNotifier(this._isar) : super([]) {
    _loadFamilies();
  }

  void _loadFamilies() {
    final families = _isar.familys.where().findAllSync();
    families.sort((a, b) => a.familyName.toLowerCase().compareTo(b.familyName.toLowerCase()));
    state = families;
  }

  void reload() => _loadFamilies();

  Family? familyForCustomer(int customerId) {
    for (final family in state) {
      if (family.members.any((m) => m.customerId == customerId)) {
        return family;
      }
    }
    return null;
  }

  int? familyIdForCustomer(int customerId) {
    return familyForCustomer(customerId)?.id;
  }

  Set<int> get assignedCustomerIds {
    final ids = <int>{};
    for (final family in state) {
      for (final member in family.members) {
        ids.add(member.customerId);
      }
    }
    return ids;
  }

  Future<Family> addFamily({required String familyName}) async {
    final name = familyName.trim();
    final existing = _isar.familys
        .filter()
        .familyNameMatches(name, caseSensitive: false)
        .findFirstSync();
    if (existing != null) {
      throw Exception('A family with this name already exists.');
    }

    final family = Family()
      ..familyName = name
      ..members = []
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.familys.put(family);
    });

    _loadFamilies();
    return family;
  }

  Future<void> updateFamilyName({required int id, required String familyName}) async {
    final name = familyName.trim();
    final duplicate = _isar.familys
        .filter()
        .familyNameMatches(name, caseSensitive: false)
        .findFirstSync();
    if (duplicate != null && duplicate.id != id) {
      throw Exception('A family with this name already exists.');
    }

    final existing = _isar.familys.getSync(id);
    if (existing == null) return;

    existing.familyName = name;
    existing.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.familys.put(existing);
    });
    _loadFamilies();
  }

  Future<void> deleteFamily(int id, {bool deleteMembers = false}) async {
    final family = await _isar.familys.get(id);
    if (family == null) return;

    final memberIds = family.members.map((m) => m.customerId).toList();

    await _isar.writeTxn(() async {
      await _isar.familys.delete(id);
      if (deleteMembers) {
        for (final customerId in memberIds) {
          await _isar.customers.delete(customerId);
        }
      }
    });
    _loadFamilies();
  }

  Future<void> addMember({
    required int familyId,
    required int customerId,
    String? relation,
  }) async {
    if (familyIdForCustomer(customerId) != null) {
      throw Exception('This customer is already in a family.');
    }

    final family = _isar.familys.getSync(familyId);
    if (family == null) return;

    final members = List<FamilyMember>.from(family.members);
    if (members.any((m) => m.customerId == customerId)) return;

    members.add(
      FamilyMember()
        ..customerId = customerId
        ..relation = relation?.trim().isEmpty == true ? null : relation?.trim(),
    );

    family.members = members;
    family.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.familys.put(family);
    });
    _loadFamilies();
  }

  Future<void> updateMemberRelation({
    required int familyId,
    required int customerId,
    String? relation,
  }) async {
    final family = _isar.familys.getSync(familyId);
    if (family == null) return;

    final members = List<FamilyMember>.from(family.members);
    final index = members.indexWhere((m) => m.customerId == customerId);
    if (index == -1) return;

    members[index].relation = relation?.trim().isEmpty == true ? null : relation?.trim();
    family.members = members;
    family.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.familys.put(family);
    });
    _loadFamilies();
  }

  Future<void> removeMember({
    required int familyId,
    required int customerId,
  }) async {
    final family = _isar.familys.getSync(familyId);
    if (family == null) return;

    family.members = family.members.where((m) => m.customerId != customerId).toList();
    family.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.familys.put(family);
    });
    _loadFamilies();
  }

  Future<void> removeCustomerFromAllFamilies(int customerId) async {
    final familiesToUpdate = state.where((f) => f.members.any((m) => m.customerId == customerId)).toList();
    if (familiesToUpdate.isEmpty) return;

    await _isar.writeTxn(() async {
      for (final family in familiesToUpdate) {
        family.members = family.members.where((m) => m.customerId != customerId).toList();
        family.updatedAt = DateTime.now();
        await _isar.familys.put(family);
      }
    });
    _loadFamilies();
  }
}

final familyProvider = StateNotifierProvider<FamilyNotifier, List<Family>>((ref) {
  final isar = ref.watch(isarProvider);
  return FamilyNotifier(isar);
});

class HomeFamilySection {
  const HomeFamilySection({
    required this.family,
    required this.members,
  });

  final Family family;
  final List<({Customer customer, String? relation})> members;
}

class HomeListData {
  const HomeListData({
    required this.familySections,
    required this.ungroupedCustomers,
    required this.hasFamilies,
    required this.isEmpty,
    required this.hasSearchResults,
  });

  final List<HomeFamilySection> familySections;
  final List<Customer> ungroupedCustomers;
  final bool hasFamilies;
  final bool isEmpty;
  final bool hasSearchResults;
}

final homeSectionsProvider = Provider<HomeListData>((ref) {
  final families = ref.watch(familyProvider);
  final customers = ref.watch(customerProvider);
  final query = ref.watch(customerSearchQueryProvider).trim().toLowerCase();

  final customerById = {for (final c in customers) c.id: c};
  final assignedIds = <int>{};
  for (final family in families) {
    for (final member in family.members) {
      assignedIds.add(member.customerId);
    }
  }

  bool familyMatches(Family family) {
    if (query.isEmpty) return true;
    if (family.familyName.toLowerCase().contains(query)) return true;
    for (final member in family.members) {
      final customer = customerById[member.customerId];
      if (customer != null && customer.name.toLowerCase().contains(query)) {
        return true;
      }
    }
    return false;
  }

  final familySections = <HomeFamilySection>[];
  for (final family in families) {
    if (!familyMatches(family)) continue;

    final members = <({Customer customer, String? relation})>[];
    for (final member in family.members) {
      final customer = customerById[member.customerId];
      if (customer == null) continue;
      if (query.isNotEmpty &&
          !family.familyName.toLowerCase().contains(query) &&
          !customer.name.toLowerCase().contains(query)) {
        continue;
      }
      members.add((customer: customer, relation: member.relation));
    }

    members.sort((a, b) => a.customer.name.toLowerCase().compareTo(b.customer.name.toLowerCase()));

    if (query.isEmpty || members.isNotEmpty || family.familyName.toLowerCase().contains(query)) {
      familySections.add(HomeFamilySection(family: family, members: members));
    }
  }

  final ungrouped = customers.where((c) => !assignedIds.contains(c.id)).toList();
  final ungroupedCustomers = query.isEmpty
      ? ungrouped
      : ungrouped.where((c) => c.name.toLowerCase().contains(query)).toList();

  final hasSearchResults = familySections.isNotEmpty || ungroupedCustomers.isNotEmpty;

  return HomeListData(
    familySections: familySections,
    ungroupedCustomers: ungroupedCustomers,
    hasFamilies: families.isNotEmpty,
    isEmpty: customers.isEmpty && families.isEmpty,
    hasSearchResults: hasSearchResults,
  );
});
