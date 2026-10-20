import 'dart:convert';
import 'package:isar/isar.dart';

part 'customer.g.dart';

@collection
class Customer {
  Id id = Isar.autoIncrement;

  late String name;

  // Kept for schema compatibility with existing local databases.
  String? phone;

  String? email;

  // Isar does not support nested maps, so measurements are stored as JSON.
  String? measurementsJson;

  String? measurementHistoryJson;

  late DateTime updatedAt;

  @ignore
  Map<String, Map<String, String>> get measurements {
    if (measurementsJson == null || measurementsJson!.isEmpty) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(measurementsJson!);
      return decoded.map((key, value) {
        final Map<String, dynamic> fieldMap = value as Map<String, dynamic>;
        return MapEntry(key, Map<String, String>.from(fieldMap));
      });
    } catch (_) {
      return {};
    }
  }

  set measurements(Map<String, Map<String, String>> value) {
    measurementsJson = jsonEncode(value);
  }
}
