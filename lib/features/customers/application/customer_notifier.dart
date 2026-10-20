import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/db/isar_provider.dart';
import '../../families/data/family.dart';
import '../data/customer.dart';

class CustomerNotifier extends StateNotifier<List<Customer>> {
  final Isar _isar;

  CustomerNotifier(this._isar) : super([]) {
    _loadCustomers();
  }

  void _loadCustomers() {
    final customers = _isar.customers.where().findAllSync();
    customers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    state = customers;
  }

  void reload() => _loadCustomers();

  Future<Customer> addCustomer({
    required String name,
  }) async {
    final existingCustomer = _isar.customers.filter().nameEqualTo(name, caseSensitive: false).findFirstSync();
    if (existingCustomer != null) {
      throw Exception('Customer already exists');
    }

    final customer = Customer()
      ..name = name
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.customers.put(customer);
    });

    _loadCustomers();
    return customer;
  }

  Future<void> updateCustomer({
    required int id,
    required String name,
  }) async {
    final existing = _isar.customers.getSync(id);
    if (existing != null) {
      if (existing.name.toLowerCase() != name.toLowerCase()) {
        final duplicate = _isar.customers.filter().nameEqualTo(name, caseSensitive: false).findFirstSync();
        if (duplicate != null) {
          throw Exception('Customer already exists');
        }
      }

      existing.name = name;
      existing.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.customers.put(existing);
      });
      _loadCustomers();
    }
  }

  Future<void> deleteCustomer(int id) async {
    await _isar.writeTxn(() async {
      // Use async queries inside writeTxn — sync reads throw while a txn is active.
      final families = await _isar.familys.where().findAll();
      for (final family in families) {
        if (family.members.any((m) => m.customerId == id)) {
          family.members = family.members.where((m) => m.customerId != id).toList();
          family.updatedAt = DateTime.now();
          await _isar.familys.put(family);
        }
      }
      await _isar.customers.delete(id);
    });
    _loadCustomers();
  }

  Future<void> updateMeasurements({
    required int customerId,
    required String templateName,
    required Map<String, String> values,
  }) async {
    final customer = _isar.customers.getSync(customerId);
    if (customer != null) {
      final current = customer.measurements;
      current[templateName] = values;
      customer.measurements = current;
      customer.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.customers.put(customer);
      });
      _loadCustomers();
    }
  }

  Future<void> deleteMeasurementTemplate({
    required int customerId,
    required String templateName,
  }) async {
    final customer = _isar.customers.getSync(customerId);
    if (customer != null) {
      final current = customer.measurements;
      current.remove(templateName);
      customer.measurements = current;
      customer.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.customers.put(customer);
      });
      _loadCustomers();
    }
  }

  Future<void> removeTemplateFromAllCustomers(String templateName) async {
    final customersToUpdate = _isar.customers
        .where()
        .findAllSync()
        .where((c) => c.measurements.containsKey(templateName))
        .toList();
    if (customersToUpdate.isEmpty) return;

    await _isar.writeTxn(() async {
      for (final customer in customersToUpdate) {
        final current = customer.measurements;
        current.remove(templateName);
        customer.measurements = current;
        customer.updatedAt = DateTime.now();
        await _isar.customers.put(customer);
      }
    });
    _loadCustomers();
  }
}

final customerProvider = StateNotifierProvider<CustomerNotifier, List<Customer>>((ref) {
  final isar = ref.watch(isarProvider);
  return CustomerNotifier(isar);
});

final customerSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCustomersProvider = Provider<List<Customer>>((ref) {
  final customers = ref.watch(customerProvider);
  final query = ref.watch(customerSearchQueryProvider).trim().toLowerCase();

  if (query.isEmpty) return customers;

  return customers.where((c) => c.name.toLowerCase().contains(query)).toList();
});
