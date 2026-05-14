// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_food_card.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiscoveredFoodCardCollection on Isar {
  IsarCollection<DiscoveredFoodCard> get discoveredFoodCards =>
      this.collection();
}

const DiscoveredFoodCardSchema = CollectionSchema(
  name: r'DiscoveredFoodCard',
  id: 4408129084216477934,
  properties: {
    r'assetPath': PropertySchema(
      id: 0,
      name: r'assetPath',
      type: IsarType.string,
    ),
    r'discoveredAt': PropertySchema(
      id: 1,
      name: r'discoveredAt',
      type: IsarType.dateTime,
    ),
    r'foodCardId': PropertySchema(
      id: 2,
      name: r'foodCardId',
      type: IsarType.string,
    ),
    r'reportDate': PropertySchema(
      id: 3,
      name: r'reportDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _discoveredFoodCardEstimateSize,
  serialize: _discoveredFoodCardSerialize,
  deserialize: _discoveredFoodCardDeserialize,
  deserializeProp: _discoveredFoodCardDeserializeProp,
  idName: r'id',
  indexes: {
    r'foodCardId': IndexSchema(
      id: 6579665983728025874,
      name: r'foodCardId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'foodCardId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'reportDate': IndexSchema(
      id: -3469995908724995165,
      name: r'reportDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reportDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _discoveredFoodCardGetId,
  getLinks: _discoveredFoodCardGetLinks,
  attach: _discoveredFoodCardAttach,
  version: '3.1.0+1',
);

int _discoveredFoodCardEstimateSize(
  DiscoveredFoodCard object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetPath.length * 3;
  bytesCount += 3 + object.foodCardId.length * 3;
  return bytesCount;
}

void _discoveredFoodCardSerialize(
  DiscoveredFoodCard object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetPath);
  writer.writeDateTime(offsets[1], object.discoveredAt);
  writer.writeString(offsets[2], object.foodCardId);
  writer.writeDateTime(offsets[3], object.reportDate);
}

DiscoveredFoodCard _discoveredFoodCardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiscoveredFoodCard(
    discoveredAt: reader.readDateTime(offsets[1]),
    foodCardId: reader.readString(offsets[2]),
    reportDate: reader.readDateTime(offsets[3]),
  );
  object.id = id;
  return object;
}

P _discoveredFoodCardDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _discoveredFoodCardGetId(DiscoveredFoodCard object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _discoveredFoodCardGetLinks(
    DiscoveredFoodCard object) {
  return [];
}

void _discoveredFoodCardAttach(
    IsarCollection<dynamic> col, Id id, DiscoveredFoodCard object) {
  object.id = id;
}

extension DiscoveredFoodCardByIndex on IsarCollection<DiscoveredFoodCard> {
  Future<DiscoveredFoodCard?> getByFoodCardId(String foodCardId) {
    return getByIndex(r'foodCardId', [foodCardId]);
  }

  DiscoveredFoodCard? getByFoodCardIdSync(String foodCardId) {
    return getByIndexSync(r'foodCardId', [foodCardId]);
  }

  Future<bool> deleteByFoodCardId(String foodCardId) {
    return deleteByIndex(r'foodCardId', [foodCardId]);
  }

  bool deleteByFoodCardIdSync(String foodCardId) {
    return deleteByIndexSync(r'foodCardId', [foodCardId]);
  }

  Future<List<DiscoveredFoodCard?>> getAllByFoodCardId(
      List<String> foodCardIdValues) {
    final values = foodCardIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'foodCardId', values);
  }

  List<DiscoveredFoodCard?> getAllByFoodCardIdSync(
      List<String> foodCardIdValues) {
    final values = foodCardIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'foodCardId', values);
  }

  Future<int> deleteAllByFoodCardId(List<String> foodCardIdValues) {
    final values = foodCardIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'foodCardId', values);
  }

  int deleteAllByFoodCardIdSync(List<String> foodCardIdValues) {
    final values = foodCardIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'foodCardId', values);
  }

  Future<Id> putByFoodCardId(DiscoveredFoodCard object) {
    return putByIndex(r'foodCardId', object);
  }

  Id putByFoodCardIdSync(DiscoveredFoodCard object, {bool saveLinks = true}) {
    return putByIndexSync(r'foodCardId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFoodCardId(List<DiscoveredFoodCard> objects) {
    return putAllByIndex(r'foodCardId', objects);
  }

  List<Id> putAllByFoodCardIdSync(List<DiscoveredFoodCard> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'foodCardId', objects, saveLinks: saveLinks);
  }
}

extension DiscoveredFoodCardQueryWhereSort
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QWhere> {
  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhere>
      anyReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reportDate'),
      );
    });
  }
}

extension DiscoveredFoodCardQueryWhere
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QWhereClause> {
  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
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

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
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

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      foodCardIdEqualTo(String foodCardId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'foodCardId',
        value: [foodCardId],
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      foodCardIdNotEqualTo(String foodCardId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodCardId',
              lower: [],
              upper: [foodCardId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodCardId',
              lower: [foodCardId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodCardId',
              lower: [foodCardId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodCardId',
              lower: [],
              upper: [foodCardId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      reportDateEqualTo(DateTime reportDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reportDate',
        value: [reportDate],
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      reportDateNotEqualTo(DateTime reportDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [],
              upper: [reportDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [reportDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [reportDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [],
              upper: [reportDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      reportDateGreaterThan(
    DateTime reportDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reportDate',
        lower: [reportDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      reportDateLessThan(
    DateTime reportDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reportDate',
        lower: [],
        upper: [reportDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterWhereClause>
      reportDateBetween(
    DateTime lowerReportDate,
    DateTime upperReportDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reportDate',
        lower: [lowerReportDate],
        includeLower: includeLower,
        upper: [upperReportDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DiscoveredFoodCardQueryFilter
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QFilterCondition> {
  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      assetPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      discoveredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discoveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      discoveredAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discoveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      discoveredAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discoveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      discoveredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discoveredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foodCardId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foodCardId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodCardId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      foodCardIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foodCardId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      reportDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      reportDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      reportDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterFilterCondition>
      reportDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DiscoveredFoodCardQueryObject
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QFilterCondition> {}

extension DiscoveredFoodCardQueryLinks
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QFilterCondition> {}

extension DiscoveredFoodCardQuerySortBy
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QSortBy> {
  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByDiscoveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByDiscoveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByFoodCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodCardId', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByFoodCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodCardId', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      sortByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }
}

extension DiscoveredFoodCardQuerySortThenBy
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QSortThenBy> {
  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByDiscoveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByDiscoveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByFoodCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodCardId', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByFoodCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodCardId', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QAfterSortBy>
      thenByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }
}

extension DiscoveredFoodCardQueryWhereDistinct
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QDistinct> {
  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QDistinct>
      distinctByAssetPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QDistinct>
      distinctByDiscoveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discoveredAt');
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QDistinct>
      distinctByFoodCardId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodCardId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QDistinct>
      distinctByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportDate');
    });
  }
}

extension DiscoveredFoodCardQueryProperty
    on QueryBuilder<DiscoveredFoodCard, DiscoveredFoodCard, QQueryProperty> {
  QueryBuilder<DiscoveredFoodCard, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiscoveredFoodCard, String, QQueryOperations>
      assetPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetPath');
    });
  }

  QueryBuilder<DiscoveredFoodCard, DateTime, QQueryOperations>
      discoveredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discoveredAt');
    });
  }

  QueryBuilder<DiscoveredFoodCard, String, QQueryOperations>
      foodCardIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodCardId');
    });
  }

  QueryBuilder<DiscoveredFoodCard, DateTime, QQueryOperations>
      reportDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportDate');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFoodCardDrawRecordCollection on Isar {
  IsarCollection<FoodCardDrawRecord> get foodCardDrawRecords =>
      this.collection();
}

const FoodCardDrawRecordSchema = CollectionSchema(
  name: r'FoodCardDrawRecord',
  id: -3615025848107082474,
  properties: {
    r'drawnAt': PropertySchema(
      id: 0,
      name: r'drawnAt',
      type: IsarType.dateTime,
    ),
    r'drawnFoodCardId': PropertySchema(
      id: 1,
      name: r'drawnFoodCardId',
      type: IsarType.string,
    ),
    r'reportDate': PropertySchema(
      id: 2,
      name: r'reportDate',
      type: IsarType.dateTime,
    ),
    r'wasDuplicate': PropertySchema(
      id: 3,
      name: r'wasDuplicate',
      type: IsarType.bool,
    )
  },
  estimateSize: _foodCardDrawRecordEstimateSize,
  serialize: _foodCardDrawRecordSerialize,
  deserialize: _foodCardDrawRecordDeserialize,
  deserializeProp: _foodCardDrawRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'reportDate': IndexSchema(
      id: -3469995908724995165,
      name: r'reportDate',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reportDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _foodCardDrawRecordGetId,
  getLinks: _foodCardDrawRecordGetLinks,
  attach: _foodCardDrawRecordAttach,
  version: '3.1.0+1',
);

int _foodCardDrawRecordEstimateSize(
  FoodCardDrawRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.drawnFoodCardId.length * 3;
  return bytesCount;
}

void _foodCardDrawRecordSerialize(
  FoodCardDrawRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.drawnAt);
  writer.writeString(offsets[1], object.drawnFoodCardId);
  writer.writeDateTime(offsets[2], object.reportDate);
  writer.writeBool(offsets[3], object.wasDuplicate);
}

FoodCardDrawRecord _foodCardDrawRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FoodCardDrawRecord(
    drawnAt: reader.readDateTime(offsets[0]),
    drawnFoodCardId: reader.readString(offsets[1]),
    reportDate: reader.readDateTime(offsets[2]),
    wasDuplicate: reader.readBool(offsets[3]),
  );
  object.id = id;
  return object;
}

P _foodCardDrawRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _foodCardDrawRecordGetId(FoodCardDrawRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _foodCardDrawRecordGetLinks(
    FoodCardDrawRecord object) {
  return [];
}

void _foodCardDrawRecordAttach(
    IsarCollection<dynamic> col, Id id, FoodCardDrawRecord object) {
  object.id = id;
}

extension FoodCardDrawRecordByIndex on IsarCollection<FoodCardDrawRecord> {
  Future<FoodCardDrawRecord?> getByReportDate(DateTime reportDate) {
    return getByIndex(r'reportDate', [reportDate]);
  }

  FoodCardDrawRecord? getByReportDateSync(DateTime reportDate) {
    return getByIndexSync(r'reportDate', [reportDate]);
  }

  Future<bool> deleteByReportDate(DateTime reportDate) {
    return deleteByIndex(r'reportDate', [reportDate]);
  }

  bool deleteByReportDateSync(DateTime reportDate) {
    return deleteByIndexSync(r'reportDate', [reportDate]);
  }

  Future<List<FoodCardDrawRecord?>> getAllByReportDate(
      List<DateTime> reportDateValues) {
    final values = reportDateValues.map((e) => [e]).toList();
    return getAllByIndex(r'reportDate', values);
  }

  List<FoodCardDrawRecord?> getAllByReportDateSync(
      List<DateTime> reportDateValues) {
    final values = reportDateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'reportDate', values);
  }

  Future<int> deleteAllByReportDate(List<DateTime> reportDateValues) {
    final values = reportDateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'reportDate', values);
  }

  int deleteAllByReportDateSync(List<DateTime> reportDateValues) {
    final values = reportDateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'reportDate', values);
  }

  Future<Id> putByReportDate(FoodCardDrawRecord object) {
    return putByIndex(r'reportDate', object);
  }

  Id putByReportDateSync(FoodCardDrawRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'reportDate', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReportDate(List<FoodCardDrawRecord> objects) {
    return putAllByIndex(r'reportDate', objects);
  }

  List<Id> putAllByReportDateSync(List<FoodCardDrawRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reportDate', objects, saveLinks: saveLinks);
  }
}

extension FoodCardDrawRecordQueryWhereSort
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QWhere> {
  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhere>
      anyReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reportDate'),
      );
    });
  }
}

extension FoodCardDrawRecordQueryWhere
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QWhereClause> {
  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
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

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
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

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      reportDateEqualTo(DateTime reportDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reportDate',
        value: [reportDate],
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      reportDateNotEqualTo(DateTime reportDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [],
              upper: [reportDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [reportDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [reportDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportDate',
              lower: [],
              upper: [reportDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      reportDateGreaterThan(
    DateTime reportDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reportDate',
        lower: [reportDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      reportDateLessThan(
    DateTime reportDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reportDate',
        lower: [],
        upper: [reportDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterWhereClause>
      reportDateBetween(
    DateTime lowerReportDate,
    DateTime upperReportDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reportDate',
        lower: [lowerReportDate],
        includeLower: includeLower,
        upper: [upperReportDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FoodCardDrawRecordQueryFilter
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QFilterCondition> {
  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawnAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'drawnAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'drawnAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'drawnAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawnFoodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'drawnFoodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'drawnFoodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'drawnFoodCardId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'drawnFoodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'drawnFoodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'drawnFoodCardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'drawnFoodCardId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawnFoodCardId',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      drawnFoodCardIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'drawnFoodCardId',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      reportDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      reportDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      reportDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      reportDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterFilterCondition>
      wasDuplicateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasDuplicate',
        value: value,
      ));
    });
  }
}

extension FoodCardDrawRecordQueryObject
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QFilterCondition> {}

extension FoodCardDrawRecordQueryLinks
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QFilterCondition> {}

extension FoodCardDrawRecordQuerySortBy
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QSortBy> {
  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByDrawnAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByDrawnAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.desc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByDrawnFoodCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnFoodCardId', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByDrawnFoodCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnFoodCardId', Sort.desc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByWasDuplicate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      sortByWasDuplicateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.desc);
    });
  }
}

extension FoodCardDrawRecordQuerySortThenBy
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QSortThenBy> {
  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByDrawnAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByDrawnAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.desc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByDrawnFoodCardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnFoodCardId', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByDrawnFoodCardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnFoodCardId', Sort.desc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByWasDuplicate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.asc);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QAfterSortBy>
      thenByWasDuplicateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.desc);
    });
  }
}

extension FoodCardDrawRecordQueryWhereDistinct
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QDistinct> {
  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QDistinct>
      distinctByDrawnAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'drawnAt');
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QDistinct>
      distinctByDrawnFoodCardId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'drawnFoodCardId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QDistinct>
      distinctByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportDate');
    });
  }

  QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QDistinct>
      distinctByWasDuplicate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasDuplicate');
    });
  }
}

extension FoodCardDrawRecordQueryProperty
    on QueryBuilder<FoodCardDrawRecord, FoodCardDrawRecord, QQueryProperty> {
  QueryBuilder<FoodCardDrawRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FoodCardDrawRecord, DateTime, QQueryOperations>
      drawnAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'drawnAt');
    });
  }

  QueryBuilder<FoodCardDrawRecord, String, QQueryOperations>
      drawnFoodCardIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'drawnFoodCardId');
    });
  }

  QueryBuilder<FoodCardDrawRecord, DateTime, QQueryOperations>
      reportDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportDate');
    });
  }

  QueryBuilder<FoodCardDrawRecord, bool, QQueryOperations>
      wasDuplicateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasDuplicate');
    });
  }
}
