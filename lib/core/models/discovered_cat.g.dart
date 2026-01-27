// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_cat.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiscoveredCatCollection on Isar {
  IsarCollection<DiscoveredCat> get discoveredCats => this.collection();
}

const DiscoveredCatSchema = CollectionSchema(
  name: r'DiscoveredCat',
  id: -8281191594324548146,
  properties: {
    r'assetPath': PropertySchema(
      id: 0,
      name: r'assetPath',
      type: IsarType.string,
    ),
    r'catId': PropertySchema(
      id: 1,
      name: r'catId',
      type: IsarType.string,
    ),
    r'discoveredAt': PropertySchema(
      id: 2,
      name: r'discoveredAt',
      type: IsarType.dateTime,
    ),
    r'reportDate': PropertySchema(
      id: 3,
      name: r'reportDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _discoveredCatEstimateSize,
  serialize: _discoveredCatSerialize,
  deserialize: _discoveredCatDeserialize,
  deserializeProp: _discoveredCatDeserializeProp,
  idName: r'id',
  indexes: {
    r'catId': IndexSchema(
      id: -4437248163412783789,
      name: r'catId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'catId',
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
  getId: _discoveredCatGetId,
  getLinks: _discoveredCatGetLinks,
  attach: _discoveredCatAttach,
  version: '3.1.0+1',
);

int _discoveredCatEstimateSize(
  DiscoveredCat object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetPath.length * 3;
  bytesCount += 3 + object.catId.length * 3;
  return bytesCount;
}

void _discoveredCatSerialize(
  DiscoveredCat object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetPath);
  writer.writeString(offsets[1], object.catId);
  writer.writeDateTime(offsets[2], object.discoveredAt);
  writer.writeDateTime(offsets[3], object.reportDate);
}

DiscoveredCat _discoveredCatDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiscoveredCat(
    catId: reader.readString(offsets[1]),
    discoveredAt: reader.readDateTime(offsets[2]),
    reportDate: reader.readDateTime(offsets[3]),
  );
  object.id = id;
  return object;
}

P _discoveredCatDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _discoveredCatGetId(DiscoveredCat object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _discoveredCatGetLinks(DiscoveredCat object) {
  return [];
}

void _discoveredCatAttach(
    IsarCollection<dynamic> col, Id id, DiscoveredCat object) {
  object.id = id;
}

extension DiscoveredCatByIndex on IsarCollection<DiscoveredCat> {
  Future<DiscoveredCat?> getByCatId(String catId) {
    return getByIndex(r'catId', [catId]);
  }

  DiscoveredCat? getByCatIdSync(String catId) {
    return getByIndexSync(r'catId', [catId]);
  }

  Future<bool> deleteByCatId(String catId) {
    return deleteByIndex(r'catId', [catId]);
  }

  bool deleteByCatIdSync(String catId) {
    return deleteByIndexSync(r'catId', [catId]);
  }

  Future<List<DiscoveredCat?>> getAllByCatId(List<String> catIdValues) {
    final values = catIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'catId', values);
  }

  List<DiscoveredCat?> getAllByCatIdSync(List<String> catIdValues) {
    final values = catIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'catId', values);
  }

  Future<int> deleteAllByCatId(List<String> catIdValues) {
    final values = catIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'catId', values);
  }

  int deleteAllByCatIdSync(List<String> catIdValues) {
    final values = catIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'catId', values);
  }

  Future<Id> putByCatId(DiscoveredCat object) {
    return putByIndex(r'catId', object);
  }

  Id putByCatIdSync(DiscoveredCat object, {bool saveLinks = true}) {
    return putByIndexSync(r'catId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCatId(List<DiscoveredCat> objects) {
    return putAllByIndex(r'catId', objects);
  }

  List<Id> putAllByCatIdSync(List<DiscoveredCat> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'catId', objects, saveLinks: saveLinks);
  }
}

extension DiscoveredCatQueryWhereSort
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QWhere> {
  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhere> anyReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reportDate'),
      );
    });
  }
}

extension DiscoveredCatQueryWhere
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QWhereClause> {
  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause> idBetween(
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause> catIdEqualTo(
      String catId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'catId',
        value: [catId],
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause> catIdNotEqualTo(
      String catId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'catId',
              lower: [],
              upper: [catId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'catId',
              lower: [catId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'catId',
              lower: [catId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'catId',
              lower: [],
              upper: [catId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause>
      reportDateEqualTo(DateTime reportDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reportDate',
        value: [reportDate],
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterWhereClause>
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

extension DiscoveredCatQueryFilter
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QFilterCondition> {
  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      assetPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      assetPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      assetPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      assetPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      catIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      discoveredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discoveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
      reportDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterFilterCondition>
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

extension DiscoveredCatQueryObject
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QFilterCondition> {}

extension DiscoveredCatQueryLinks
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QFilterCondition> {}

extension DiscoveredCatQuerySortBy
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QSortBy> {
  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> sortByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      sortByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> sortByCatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> sortByCatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      sortByDiscoveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      sortByDiscoveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> sortByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      sortByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }
}

extension DiscoveredCatQuerySortThenBy
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QSortThenBy> {
  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> thenByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      thenByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> thenByCatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> thenByCatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      thenByDiscoveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      thenByDiscoveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discoveredAt', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy> thenByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QAfterSortBy>
      thenByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }
}

extension DiscoveredCatQueryWhereDistinct
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QDistinct> {
  QueryBuilder<DiscoveredCat, DiscoveredCat, QDistinct> distinctByAssetPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QDistinct> distinctByCatId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QDistinct>
      distinctByDiscoveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discoveredAt');
    });
  }

  QueryBuilder<DiscoveredCat, DiscoveredCat, QDistinct> distinctByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportDate');
    });
  }
}

extension DiscoveredCatQueryProperty
    on QueryBuilder<DiscoveredCat, DiscoveredCat, QQueryProperty> {
  QueryBuilder<DiscoveredCat, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiscoveredCat, String, QQueryOperations> assetPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetPath');
    });
  }

  QueryBuilder<DiscoveredCat, String, QQueryOperations> catIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catId');
    });
  }

  QueryBuilder<DiscoveredCat, DateTime, QQueryOperations>
      discoveredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discoveredAt');
    });
  }

  QueryBuilder<DiscoveredCat, DateTime, QQueryOperations> reportDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportDate');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCatDrawRecordCollection on Isar {
  IsarCollection<CatDrawRecord> get catDrawRecords => this.collection();
}

const CatDrawRecordSchema = CollectionSchema(
  name: r'CatDrawRecord',
  id: -5492067185654247521,
  properties: {
    r'drawnAt': PropertySchema(
      id: 0,
      name: r'drawnAt',
      type: IsarType.dateTime,
    ),
    r'drawnCatId': PropertySchema(
      id: 1,
      name: r'drawnCatId',
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
  estimateSize: _catDrawRecordEstimateSize,
  serialize: _catDrawRecordSerialize,
  deserialize: _catDrawRecordDeserialize,
  deserializeProp: _catDrawRecordDeserializeProp,
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
  getId: _catDrawRecordGetId,
  getLinks: _catDrawRecordGetLinks,
  attach: _catDrawRecordAttach,
  version: '3.1.0+1',
);

int _catDrawRecordEstimateSize(
  CatDrawRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.drawnCatId.length * 3;
  return bytesCount;
}

void _catDrawRecordSerialize(
  CatDrawRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.drawnAt);
  writer.writeString(offsets[1], object.drawnCatId);
  writer.writeDateTime(offsets[2], object.reportDate);
  writer.writeBool(offsets[3], object.wasDuplicate);
}

CatDrawRecord _catDrawRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CatDrawRecord(
    drawnAt: reader.readDateTime(offsets[0]),
    drawnCatId: reader.readString(offsets[1]),
    reportDate: reader.readDateTime(offsets[2]),
    wasDuplicate: reader.readBool(offsets[3]),
  );
  object.id = id;
  return object;
}

P _catDrawRecordDeserializeProp<P>(
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

Id _catDrawRecordGetId(CatDrawRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _catDrawRecordGetLinks(CatDrawRecord object) {
  return [];
}

void _catDrawRecordAttach(
    IsarCollection<dynamic> col, Id id, CatDrawRecord object) {
  object.id = id;
}

extension CatDrawRecordByIndex on IsarCollection<CatDrawRecord> {
  Future<CatDrawRecord?> getByReportDate(DateTime reportDate) {
    return getByIndex(r'reportDate', [reportDate]);
  }

  CatDrawRecord? getByReportDateSync(DateTime reportDate) {
    return getByIndexSync(r'reportDate', [reportDate]);
  }

  Future<bool> deleteByReportDate(DateTime reportDate) {
    return deleteByIndex(r'reportDate', [reportDate]);
  }

  bool deleteByReportDateSync(DateTime reportDate) {
    return deleteByIndexSync(r'reportDate', [reportDate]);
  }

  Future<List<CatDrawRecord?>> getAllByReportDate(
      List<DateTime> reportDateValues) {
    final values = reportDateValues.map((e) => [e]).toList();
    return getAllByIndex(r'reportDate', values);
  }

  List<CatDrawRecord?> getAllByReportDateSync(List<DateTime> reportDateValues) {
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

  Future<Id> putByReportDate(CatDrawRecord object) {
    return putByIndex(r'reportDate', object);
  }

  Id putByReportDateSync(CatDrawRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'reportDate', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReportDate(List<CatDrawRecord> objects) {
    return putAllByIndex(r'reportDate', objects);
  }

  List<Id> putAllByReportDateSync(List<CatDrawRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reportDate', objects, saveLinks: saveLinks);
  }
}

extension CatDrawRecordQueryWhereSort
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QWhere> {
  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhere> anyReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reportDate'),
      );
    });
  }
}

extension CatDrawRecordQueryWhere
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QWhereClause> {
  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause>
      reportDateEqualTo(DateTime reportDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reportDate',
        value: [reportDate],
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterWhereClause>
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

extension CatDrawRecordQueryFilter
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QFilterCondition> {
  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawnAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawnCatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'drawnCatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'drawnCatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'drawnCatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'drawnCatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'drawnCatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'drawnCatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'drawnCatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawnCatId',
        value: '',
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      drawnCatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'drawnCatId',
        value: '',
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      reportDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
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

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterFilterCondition>
      wasDuplicateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasDuplicate',
        value: value,
      ));
    });
  }
}

extension CatDrawRecordQueryObject
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QFilterCondition> {}

extension CatDrawRecordQueryLinks
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QFilterCondition> {}

extension CatDrawRecordQuerySortBy
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QSortBy> {
  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> sortByDrawnAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> sortByDrawnAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.desc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> sortByDrawnCatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnCatId', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      sortByDrawnCatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnCatId', Sort.desc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> sortByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      sortByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      sortByWasDuplicate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      sortByWasDuplicateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.desc);
    });
  }
}

extension CatDrawRecordQuerySortThenBy
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QSortThenBy> {
  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> thenByDrawnAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> thenByDrawnAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnAt', Sort.desc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> thenByDrawnCatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnCatId', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      thenByDrawnCatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawnCatId', Sort.desc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy> thenByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      thenByReportDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportDate', Sort.desc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      thenByWasDuplicate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.asc);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QAfterSortBy>
      thenByWasDuplicateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasDuplicate', Sort.desc);
    });
  }
}

extension CatDrawRecordQueryWhereDistinct
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QDistinct> {
  QueryBuilder<CatDrawRecord, CatDrawRecord, QDistinct> distinctByDrawnAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'drawnAt');
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QDistinct> distinctByDrawnCatId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'drawnCatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QDistinct> distinctByReportDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportDate');
    });
  }

  QueryBuilder<CatDrawRecord, CatDrawRecord, QDistinct>
      distinctByWasDuplicate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasDuplicate');
    });
  }
}

extension CatDrawRecordQueryProperty
    on QueryBuilder<CatDrawRecord, CatDrawRecord, QQueryProperty> {
  QueryBuilder<CatDrawRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CatDrawRecord, DateTime, QQueryOperations> drawnAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'drawnAt');
    });
  }

  QueryBuilder<CatDrawRecord, String, QQueryOperations> drawnCatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'drawnCatId');
    });
  }

  QueryBuilder<CatDrawRecord, DateTime, QQueryOperations> reportDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportDate');
    });
  }

  QueryBuilder<CatDrawRecord, bool, QQueryOperations> wasDuplicateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasDuplicate');
    });
  }
}
