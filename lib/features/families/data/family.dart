import 'package:isar/isar.dart';

part 'family.g.dart';

@embedded
class FamilyMember {
  late int customerId;

  String? relation;
}

@collection
class Family {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String familyName;

  late List<FamilyMember> members;

  late DateTime updatedAt;
}
