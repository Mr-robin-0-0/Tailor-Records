import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/db/isar_provider.dart';
import '../data/measurement_template.dart';

class TemplateNotifier extends StateNotifier<List<MeasurementTemplate>> {
  final Isar _isar;

  TemplateNotifier(this._isar) : super([]) {
    _loadTemplates();
  }

  void _loadTemplates() {
    state = _isar.measurementTemplates.where().sortByCreatedAtDesc().findAllSync();
  }

  Future<void> addTemplate(String name, List<String> fields) async {
    final existing = _isar.measurementTemplates
        .filter()
        .templateNameMatches(name, caseSensitive: false)
        .findFirstSync();
    if (existing != null) {
      throw Exception('A template with this name already exists.');
    }

    final template = MeasurementTemplate()
      ..templateName = name
      ..fieldNames = fields
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.measurementTemplates.put(template);
    });

    _loadTemplates();
  }

  Future<void> deleteTemplate(int id) async {
    await _isar.writeTxn(() async {
      await _isar.measurementTemplates.delete(id);
    });
    _loadTemplates();
  }

  Future<void> updateTemplate(int id, String name, List<String> fields) async {
    final duplicate = _isar.measurementTemplates
        .filter()
        .templateNameMatches(name, caseSensitive: false)
        .findFirstSync();
    if (duplicate != null && duplicate.id != id) {
      throw Exception('A template with this name already exists.');
    }

    final existing = _isar.measurementTemplates.getSync(id);
    if (existing != null) {
      existing.templateName = name;
      existing.fieldNames = fields;

      await _isar.writeTxn(() async {
        await _isar.measurementTemplates.put(existing);
      });
      _loadTemplates();
    }
  }
}

final templateProvider = StateNotifierProvider<TemplateNotifier, List<MeasurementTemplate>>((ref) {
  final isar = ref.watch(isarProvider);
  return TemplateNotifier(isar);
});
