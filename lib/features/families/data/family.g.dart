// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFamilyCollection on Isar {
  IsarCollection<Family> get familys => this.collection();
}

const FamilySchema = CollectionSchema(
  name: r'Family',
  id: 7440285828654831432,
  properties: {
    r'familyName': PropertySchema(
      id: 0,
      name: r'familyName',
      type: IsarType.string,
    ),
    r'members': PropertySchema(
      id: 1,
      name: r'members',
      type: IsarType.objectList,
      target: r'FamilyMember',
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _familyEstimateSize,
  serialize: _familySerialize,
  deserialize: _familyDeserialize,
  deserializeProp: _familyDeserializeProp,
  idName: r'id',
  indexes: {
    r'familyName': IndexSchema(
      id: -1447516994366636577,
      name: r'familyName',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'familyName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'FamilyMember': FamilyMemberSchema},
  getId: _familyGetId,
  getLinks: _familyGetLinks,
  attach: _familyAttach,
  version: '3.1.0+1',
);

int _familyEstimateSize(
  Family object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.familyName.length * 3;
  bytesCount += 3 + object.members.length * 3;
  {
    final offsets = allOffsets[FamilyMember]!;
    for (var i = 0; i < object.members.length; i++) {
      final value = object.members[i];
      bytesCount += FamilyMemberSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _familySerialize(
  Family object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.familyName);
  writer.writeObjectList<FamilyMember>(
    offsets[1],
    allOffsets,
    FamilyMemberSchema.serialize,
    object.members,
  );
  writer.writeDateTime(offsets[2], object.updatedAt);
}

Family _familyDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Family();
  object.familyName = reader.readString(offsets[0]);
  object.id = id;
  object.members = reader.readObjectList<FamilyMember>(
        offsets[1],
        FamilyMemberSchema.deserialize,
        allOffsets,
        FamilyMember(),
      ) ??
      [];
  object.updatedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _familyDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readObjectList<FamilyMember>(
            offset,
            FamilyMemberSchema.deserialize,
            allOffsets,
            FamilyMember(),
          ) ??
          []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _familyGetId(Family object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _familyGetLinks(Family object) {
  return [];
}

void _familyAttach(IsarCollection<dynamic> col, Id id, Family object) {
  object.id = id;
}

extension FamilyByIndex on IsarCollection<Family> {
  Future<Family?> getByFamilyName(String familyName) {
    return getByIndex(r'familyName', [familyName]);
  }

  Family? getByFamilyNameSync(String familyName) {
    return getByIndexSync(r'familyName', [familyName]);
  }

  Future<bool> deleteByFamilyName(String familyName) {
    return deleteByIndex(r'familyName', [familyName]);
  }

  bool deleteByFamilyNameSync(String familyName) {
    return deleteByIndexSync(r'familyName', [familyName]);
  }

  Future<List<Family?>> getAllByFamilyName(List<String> familyNameValues) {
    final values = familyNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'familyName', values);
  }

  List<Family?> getAllByFamilyNameSync(List<String> familyNameValues) {
    final values = familyNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'familyName', values);
  }

  Future<int> deleteAllByFamilyName(List<String> familyNameValues) {
    final values = familyNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'familyName', values);
  }

  int deleteAllByFamilyNameSync(List<String> familyNameValues) {
    final values = familyNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'familyName', values);
  }

  Future<Id> putByFamilyName(Family object) {
    return putByIndex(r'familyName', object);
  }

  Id putByFamilyNameSync(Family object, {bool saveLinks = true}) {
    return putByIndexSync(r'familyName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFamilyName(List<Family> objects) {
    return putAllByIndex(r'familyName', objects);
  }

  List<Id> putAllByFamilyNameSync(List<Family> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'familyName', objects, saveLinks: saveLinks);
  }
}

extension FamilyQueryWhereSort on QueryBuilder<Family, Family, QWhere> {
  QueryBuilder<Family, Family, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FamilyQueryWhere on QueryBuilder<Family, Family, QWhereClause> {
  QueryBuilder<Family, Family, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Family, Family, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Family, Family, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Family, Family, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterWhereClause> familyNameEqualTo(
      String familyName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'familyName',
        value: [familyName],
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterWhereClause> familyNameNotEqualTo(
      String familyName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'familyName',
              lower: [],
              upper: [familyName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'familyName',
              lower: [familyName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'familyName',
              lower: [familyName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'familyName',
              lower: [],
              upper: [familyName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FamilyQueryFilter on QueryBuilder<Family, Family, QFilterCondition> {
  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'familyName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'familyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familyName',
        value: '',
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> familyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'familyName',
        value: '',
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> membersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> membersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> membersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> membersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> membersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> membersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Family, Family, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FamilyQueryObject on QueryBuilder<Family, Family, QFilterCondition> {
  QueryBuilder<Family, Family, QAfterFilterCondition> membersElement(
      FilterQuery<FamilyMember> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'members');
    });
  }
}

extension FamilyQueryLinks on QueryBuilder<Family, Family, QFilterCondition> {}

extension FamilyQuerySortBy on QueryBuilder<Family, Family, QSortBy> {
  QueryBuilder<Family, Family, QAfterSortBy> sortByFamilyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.asc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> sortByFamilyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.desc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FamilyQuerySortThenBy on QueryBuilder<Family, Family, QSortThenBy> {
  QueryBuilder<Family, Family, QAfterSortBy> thenByFamilyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.asc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> thenByFamilyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.desc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Family, Family, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FamilyQueryWhereDistinct on QueryBuilder<Family, Family, QDistinct> {
  QueryBuilder<Family, Family, QDistinct> distinctByFamilyName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'familyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Family, Family, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FamilyQueryProperty on QueryBuilder<Family, Family, QQueryProperty> {
  QueryBuilder<Family, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Family, String, QQueryOperations> familyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'familyName');
    });
  }

  QueryBuilder<Family, List<FamilyMember>, QQueryOperations> membersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'members');
    });
  }

  QueryBuilder<Family, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FamilyMemberSchema = Schema(
  name: r'FamilyMember',
  id: -347717217211941561,
  properties: {
    r'customerId': PropertySchema(
      id: 0,
      name: r'customerId',
      type: IsarType.long,
    ),
    r'relation': PropertySchema(
      id: 1,
      name: r'relation',
      type: IsarType.string,
    )
  },
  estimateSize: _familyMemberEstimateSize,
  serialize: _familyMemberSerialize,
  deserialize: _familyMemberDeserialize,
  deserializeProp: _familyMemberDeserializeProp,
);

int _familyMemberEstimateSize(
  FamilyMember object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.relation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _familyMemberSerialize(
  FamilyMember object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.customerId);
  writer.writeString(offsets[1], object.relation);
}

FamilyMember _familyMemberDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FamilyMember();
  object.customerId = reader.readLong(offsets[0]);
  object.relation = reader.readStringOrNull(offsets[1]);
  return object;
}

P _familyMemberDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FamilyMemberQueryFilter
    on QueryBuilder<FamilyMember, FamilyMember, QFilterCondition> {
  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      customerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      customerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      customerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      customerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relation',
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relation',
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relation',
        value: '',
      ));
    });
  }

  QueryBuilder<FamilyMember, FamilyMember, QAfterFilterCondition>
      relationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relation',
        value: '',
      ));
    });
  }
}

extension FamilyMemberQueryObject
    on QueryBuilder<FamilyMember, FamilyMember, QFilterCondition> {}
