// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMeasurementTemplateCollection on Isar {
  IsarCollection<MeasurementTemplate> get measurementTemplates =>
      this.collection();
}

const MeasurementTemplateSchema = CollectionSchema(
  name: r'MeasurementTemplate',
  id: -8698014811715521195,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'fieldNames': PropertySchema(
      id: 1,
      name: r'fieldNames',
      type: IsarType.stringList,
    ),
    r'templateName': PropertySchema(
      id: 2,
      name: r'templateName',
      type: IsarType.string,
    )
  },
  estimateSize: _measurementTemplateEstimateSize,
  serialize: _measurementTemplateSerialize,
  deserialize: _measurementTemplateDeserialize,
  deserializeProp: _measurementTemplateDeserializeProp,
  idName: r'id',
  indexes: {
    r'templateName': IndexSchema(
      id: -879412639570306553,
      name: r'templateName',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'templateName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _measurementTemplateGetId,
  getLinks: _measurementTemplateGetLinks,
  attach: _measurementTemplateAttach,
  version: '3.1.0+1',
);

int _measurementTemplateEstimateSize(
  MeasurementTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fieldNames.length * 3;
  {
    for (var i = 0; i < object.fieldNames.length; i++) {
      final value = object.fieldNames[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.templateName.length * 3;
  return bytesCount;
}

void _measurementTemplateSerialize(
  MeasurementTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeStringList(offsets[1], object.fieldNames);
  writer.writeString(offsets[2], object.templateName);
}

MeasurementTemplate _measurementTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MeasurementTemplate();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.fieldNames = reader.readStringList(offsets[1]) ?? [];
  object.id = id;
  object.templateName = reader.readString(offsets[2]);
  return object;
}

P _measurementTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _measurementTemplateGetId(MeasurementTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _measurementTemplateGetLinks(
    MeasurementTemplate object) {
  return [];
}

void _measurementTemplateAttach(
    IsarCollection<dynamic> col, Id id, MeasurementTemplate object) {
  object.id = id;
}

extension MeasurementTemplateByIndex on IsarCollection<MeasurementTemplate> {
  Future<MeasurementTemplate?> getByTemplateName(String templateName) {
    return getByIndex(r'templateName', [templateName]);
  }

  MeasurementTemplate? getByTemplateNameSync(String templateName) {
    return getByIndexSync(r'templateName', [templateName]);
  }

  Future<bool> deleteByTemplateName(String templateName) {
    return deleteByIndex(r'templateName', [templateName]);
  }

  bool deleteByTemplateNameSync(String templateName) {
    return deleteByIndexSync(r'templateName', [templateName]);
  }

  Future<List<MeasurementTemplate?>> getAllByTemplateName(
      List<String> templateNameValues) {
    final values = templateNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'templateName', values);
  }

  List<MeasurementTemplate?> getAllByTemplateNameSync(
      List<String> templateNameValues) {
    final values = templateNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'templateName', values);
  }

  Future<int> deleteAllByTemplateName(List<String> templateNameValues) {
    final values = templateNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'templateName', values);
  }

  int deleteAllByTemplateNameSync(List<String> templateNameValues) {
    final values = templateNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'templateName', values);
  }

  Future<Id> putByTemplateName(MeasurementTemplate object) {
    return putByIndex(r'templateName', object);
  }

  Id putByTemplateNameSync(MeasurementTemplate object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'templateName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTemplateName(List<MeasurementTemplate> objects) {
    return putAllByIndex(r'templateName', objects);
  }

  List<Id> putAllByTemplateNameSync(List<MeasurementTemplate> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'templateName', objects, saveLinks: saveLinks);
  }
}

extension MeasurementTemplateQueryWhereSort
    on QueryBuilder<MeasurementTemplate, MeasurementTemplate, QWhere> {
  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MeasurementTemplateQueryWhere
    on QueryBuilder<MeasurementTemplate, MeasurementTemplate, QWhereClause> {
  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhereClause>
      templateNameEqualTo(String templateName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'templateName',
        value: [templateName],
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterWhereClause>
      templateNameNotEqualTo(String templateName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateName',
              lower: [],
              upper: [templateName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateName',
              lower: [templateName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateName',
              lower: [templateName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateName',
              lower: [],
              upper: [templateName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MeasurementTemplateQueryFilter on QueryBuilder<MeasurementTemplate,
    MeasurementTemplate, QFilterCondition> {
  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fieldNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fieldNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fieldNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fieldNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fieldNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fieldNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fieldNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fieldNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fieldNames',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fieldNames',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fieldNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fieldNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fieldNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fieldNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fieldNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      fieldNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fieldNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'templateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'templateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'templateName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'templateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'templateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'templateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'templateName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateName',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterFilterCondition>
      templateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'templateName',
        value: '',
      ));
    });
  }
}

extension MeasurementTemplateQueryObject on QueryBuilder<MeasurementTemplate,
    MeasurementTemplate, QFilterCondition> {}

extension MeasurementTemplateQueryLinks on QueryBuilder<MeasurementTemplate,
    MeasurementTemplate, QFilterCondition> {}

extension MeasurementTemplateQuerySortBy
    on QueryBuilder<MeasurementTemplate, MeasurementTemplate, QSortBy> {
  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      sortByTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.asc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      sortByTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.desc);
    });
  }
}

extension MeasurementTemplateQuerySortThenBy
    on QueryBuilder<MeasurementTemplate, MeasurementTemplate, QSortThenBy> {
  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      thenByTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.asc);
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QAfterSortBy>
      thenByTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateName', Sort.desc);
    });
  }
}

extension MeasurementTemplateQueryWhereDistinct
    on QueryBuilder<MeasurementTemplate, MeasurementTemplate, QDistinct> {
  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QDistinct>
      distinctByFieldNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fieldNames');
    });
  }

  QueryBuilder<MeasurementTemplate, MeasurementTemplate, QDistinct>
      distinctByTemplateName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'templateName', caseSensitive: caseSensitive);
    });
  }
}

extension MeasurementTemplateQueryProperty
    on QueryBuilder<MeasurementTemplate, MeasurementTemplate, QQueryProperty> {
  QueryBuilder<MeasurementTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MeasurementTemplate, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MeasurementTemplate, List<String>, QQueryOperations>
      fieldNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fieldNames');
    });
  }

  QueryBuilder<MeasurementTemplate, String, QQueryOperations>
      templateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'templateName');
    });
  }
}
