import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/customers/data/customer.dart';
import '../../features/families/data/family.dart';
import '../../features/templates/data/measurement_template.dart';

class IsarDb {
  IsarDb._();

  static const _instanceName = 'default';

  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    try {
      return await _open(dir.path);
    } catch (_) {
      await _deleteIsarFiles(dir.path);
      return _open(dir.path);
    }
  }

  static Future<Isar> _open(String directory) {
    return Isar.open(
      [
        MeasurementTemplateSchema,
        CustomerSchema,
        FamilySchema,
      ],
      directory: directory,
      name: _instanceName,
    );
  }

  static Future<void> _deleteIsarFiles(String directory) async {
    final existing = Isar.getInstance(_instanceName);
    if (existing != null && existing.isOpen) {
      await existing.close(deleteFromDisk: true);
      return;
    }

    for (final fileName in [
      '$_instanceName.isar',
      '$_instanceName.isar.lock',
    ]) {
      final file = File('$directory${Platform.pathSeparator}$fileName');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
