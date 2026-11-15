// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_piece.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScenePieceCollection on Isar {
  IsarCollection<ScenePiece> get scenePieces => this.collection();
}

const ScenePieceSchema = CollectionSchema(
  name: r'ScenePiece',
  id: 4504542037985915592,
  properties: {
    r'acquiredAt': PropertySchema(
      id: 0,
      name: r'acquiredAt',
      type: IsarType.dateTime,
    ),
    r'isPlaced': PropertySchema(
      id: 1,
      name: r'isPlaced',
      type: IsarType.bool,
    ),
    r'modelId': PropertySchema(
      id: 2,
      name: r'modelId',
      type: IsarType.string,
    ),
    r'refKey': PropertySchema(
      id: 3,
      name: r'refKey',
      type: IsarType.string,
    ),
    r'sceneId': PropertySchema(
      id: 4,
      name: r'sceneId',
      type: IsarType.string,
    ),
    r'slotId': PropertySchema(
      id: 5,
      name: r'slotId',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 6,
      name: r'source',
      type: IsarType.byte,
      enumMap: _ScenePiecesourceEnumValueMap,
    )
  },
  estimateSize: _scenePieceEstimateSize,
  serialize: _scenePieceSerialize,
  deserialize: _scenePieceDeserialize,
  deserializeProp: _scenePieceDeserializeProp,
  idName: r'id',
  indexes: {
    r'sceneId': IndexSchema(
      id: -2132069569599388541,
      name: r'sceneId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sceneId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'refKey': IndexSchema(
      id: -628560800936737020,
      name: r'refKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'refKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _scenePieceGetId,
  getLinks: _scenePieceGetLinks,
  attach: _scenePieceAttach,
  version: '3.1.0+1',
);

int _scenePieceEstimateSize(
  ScenePiece object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.modelId.length * 3;
  bytesCount += 3 + object.refKey.length * 3;
  bytesCount += 3 + object.sceneId.length * 3;
  {
    final value = object.slotId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _scenePieceSerialize(
  ScenePiece object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.acquiredAt);
  writer.writeBool(offsets[1], object.isPlaced);
  writer.writeString(offsets[2], object.modelId);
  writer.writeString(offsets[3], object.refKey);
  writer.writeString(offsets[4], object.sceneId);
  writer.writeString(offsets[5], object.slotId);
  writer.writeByte(offsets[6], object.source.index);
}

ScenePiece _scenePieceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScenePiece(
    acquiredAt: reader.readDateTime(offsets[0]),
    modelId: reader.readString(offsets[2]),
    refKey: reader.readString(offsets[3]),
    sceneId: reader.readString(offsets[4]),
    slotId: reader.readStringOrNull(offsets[5]),
    source: _ScenePiecesourceValueEnumMap[reader.readByteOrNull(offsets[6])] ??
        ScenePieceSource.starter,
  );
  object.id = id;
  return object;
}

P _scenePieceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (_ScenePiecesourceValueEnumMap[reader.readByteOrNull(offset)] ??
          ScenePieceSource.starter) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ScenePiecesourceEnumValueMap = {
  'starter': 0,
  'journal': 1,
  'shop': 2,
  'reward': 3,
};
const _ScenePiecesourceValueEnumMap = {
  0: ScenePieceSource.starter,
  1: ScenePieceSource.journal,
  2: ScenePieceSource.shop,
  3: ScenePieceSource.reward,
};

Id _scenePieceGetId(ScenePiece object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scenePieceGetLinks(ScenePiece object) {
  return [];
}

void _scenePieceAttach(IsarCollection<dynamic> col, Id id, ScenePiece object) {
  object.id = id;
}

extension ScenePieceByIndex on IsarCollection<ScenePiece> {
  Future<ScenePiece?> getByRefKey(String refKey) {
    return getByIndex(r'refKey', [refKey]);
  }

  ScenePiece? getByRefKeySync(String refKey) {
    return getByIndexSync(r'refKey', [refKey]);
  }

  Future<bool> deleteByRefKey(String refKey) {
    return deleteByIndex(r'refKey', [refKey]);
  }

  bool deleteByRefKeySync(String refKey) {
    return deleteByIndexSync(r'refKey', [refKey]);
  }

  Future<List<ScenePiece?>> getAllByRefKey(List<String> refKeyValues) {
    final values = refKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'refKey', values);
  }

  List<ScenePiece?> getAllByRefKeySync(List<String> refKeyValues) {
    final values = refKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'refKey', values);
  }

  Future<int> deleteAllByRefKey(List<String> refKeyValues) {
    final values = refKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'refKey', values);
  }

  int deleteAllByRefKeySync(List<String> refKeyValues) {
    final values = refKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'refKey', values);
  }

  Future<Id> putByRefKey(ScenePiece object) {
    return putByIndex(r'refKey', object);
  }

  Id putByRefKeySync(ScenePiece object, {bool saveLinks = true}) {
    return putByIndexSync(r'refKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRefKey(List<ScenePiece> objects) {
    return putAllByIndex(r'refKey', objects);
  }

  List<Id> putAllByRefKeySync(List<ScenePiece> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'refKey', objects, saveLinks: saveLinks);
  }
}

extension ScenePieceQueryWhereSort
    on QueryBuilder<ScenePiece, ScenePiece, QWhere> {
  QueryBuilder<ScenePiece, ScenePiece, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScenePieceQueryWhere
    on QueryBuilder<ScenePiece, ScenePiece, QWhereClause> {
  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> idBetween(
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

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> sceneIdEqualTo(
      String sceneId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sceneId',
        value: [sceneId],
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> sceneIdNotEqualTo(
      String sceneId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sceneId',
              lower: [],
              upper: [sceneId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sceneId',
              lower: [sceneId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sceneId',
              lower: [sceneId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sceneId',
              lower: [],
              upper: [sceneId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> refKeyEqualTo(
      String refKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'refKey',
        value: [refKey],
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterWhereClause> refKeyNotEqualTo(
      String refKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refKey',
              lower: [],
              upper: [refKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refKey',
              lower: [refKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refKey',
              lower: [refKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refKey',
              lower: [],
              upper: [refKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ScenePieceQueryFilter
    on QueryBuilder<ScenePiece, ScenePiece, QFilterCondition> {
  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> acquiredAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'acquiredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      acquiredAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'acquiredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      acquiredAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'acquiredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> acquiredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'acquiredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> isPlacedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPlaced',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      modelIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> modelIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      modelIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'refKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'refKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'refKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'refKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'refKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'refKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'refKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> refKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      refKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'refKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sceneId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      sceneIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sceneId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sceneId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sceneId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sceneId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sceneId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sceneId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sceneId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sceneIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sceneId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      sceneIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sceneId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'slotId',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      slotIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'slotId',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> slotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slotId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition>
      slotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slotId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sourceEqualTo(
      ScenePieceSource value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sourceGreaterThan(
    ScenePieceSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sourceLessThan(
    ScenePieceSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterFilterCondition> sourceBetween(
    ScenePieceSource lower,
    ScenePieceSource upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScenePieceQueryObject
    on QueryBuilder<ScenePiece, ScenePiece, QFilterCondition> {}

extension ScenePieceQueryLinks
    on QueryBuilder<ScenePiece, ScenePiece, QFilterCondition> {}

extension ScenePieceQuerySortBy
    on QueryBuilder<ScenePiece, ScenePiece, QSortBy> {
  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByAcquiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByAcquiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByIsPlaced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPlaced', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByIsPlacedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPlaced', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByRefKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortByRefKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortBySceneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sceneId', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortBySceneIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sceneId', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortBySlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotId', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortBySlotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotId', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }
}

extension ScenePieceQuerySortThenBy
    on QueryBuilder<ScenePiece, ScenePiece, QSortThenBy> {
  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByAcquiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByAcquiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByIsPlaced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPlaced', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByIsPlacedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPlaced', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByRefKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenByRefKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenBySceneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sceneId', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenBySceneIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sceneId', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenBySlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotId', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenBySlotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotId', Sort.desc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }
}

extension ScenePieceQueryWhereDistinct
    on QueryBuilder<ScenePiece, ScenePiece, QDistinct> {
  QueryBuilder<ScenePiece, ScenePiece, QDistinct> distinctByAcquiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'acquiredAt');
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QDistinct> distinctByIsPlaced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPlaced');
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QDistinct> distinctByModelId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QDistinct> distinctByRefKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QDistinct> distinctBySceneId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sceneId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QDistinct> distinctBySlotId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScenePiece, ScenePiece, QDistinct> distinctBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source');
    });
  }
}

extension ScenePieceQueryProperty
    on QueryBuilder<ScenePiece, ScenePiece, QQueryProperty> {
  QueryBuilder<ScenePiece, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScenePiece, DateTime, QQueryOperations> acquiredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'acquiredAt');
    });
  }

  QueryBuilder<ScenePiece, bool, QQueryOperations> isPlacedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPlaced');
    });
  }

  QueryBuilder<ScenePiece, String, QQueryOperations> modelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelId');
    });
  }

  QueryBuilder<ScenePiece, String, QQueryOperations> refKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refKey');
    });
  }

  QueryBuilder<ScenePiece, String, QQueryOperations> sceneIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sceneId');
    });
  }

  QueryBuilder<ScenePiece, String?, QQueryOperations> slotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slotId');
    });
  }

  QueryBuilder<ScenePiece, ScenePieceSource, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }
}
