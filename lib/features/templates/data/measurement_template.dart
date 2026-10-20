import 'package:isar/isar.dart';

part 'measurement_template.g.dart';

@collection
class MeasurementTemplate {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String templateName;

  late List<String> fieldNames;

  late DateTime createdAt;
}
