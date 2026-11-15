// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCoinTransactionCollection on Isar {
  IsarCollection<CoinTransaction> get coinTransactions => this.collection();
}

const CoinTransactionSchema = CollectionSchema(
  name: r'CoinTransaction',
  id: 4803987341470907652,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'reason': PropertySchema(
      id: 2,
      name: r'reason',
      type: IsarType.byte,
      enumMap: _CoinTransactionreasonEnumValueMap,
    ),
    r'refKey': PropertySchema(
      id: 3,
      name: r'refKey',
      type: IsarType.string,
    )
  },
  estimateSize: _coinTransactionEstimateSize,
  serialize: _coinTransactionSerialize,
  deserialize: _coinTransactionDeserialize,
  deserializeProp: _coinTransactionDeserializeProp,
  idName: r'id',
  indexes: {
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
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _coinTransactionGetId,
  getLinks: _coinTransactionGetLinks,
  attach: _coinTransactionAttach,
  version: '3.1.0+1',
);

int _coinTransactionEstimateSize(
  CoinTransaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.refKey.length * 3;
  return bytesCount;
}

void _coinTransactionSerialize(
  CoinTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeByte(offsets[2], object.reason.index);
  writer.writeString(offsets[3], object.refKey);
}

CoinTransaction _coinTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoinTransaction(
    amount: reader.readLong(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    reason:
        _CoinTransactionreasonValueEnumMap[reader.readByteOrNull(offsets[2])] ??
            CoinReason.dailyJournal,
    refKey: reader.readString(offsets[3]),
  );
  object.id = id;
  return object;
}

P _coinTransactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_CoinTransactionreasonValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CoinReason.dailyJournal) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CoinTransactionreasonEnumValueMap = {
  'dailyJournal': 0,
  'duplicateCard': 1,
  'memoryGame': 2,
  'monthlyRecap': 3,
  'purchase': 4,
};
const _CoinTransactionreasonValueEnumMap = {
  0: CoinReason.dailyJournal,
  1: CoinReason.duplicateCard,
  2: CoinReason.memoryGame,
  3: CoinReason.monthlyRecap,
  4: CoinReason.purchase,
};

Id _coinTransactionGetId(CoinTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _coinTransactionGetLinks(CoinTransaction object) {
  return [];
}

void _coinTransactionAttach(
    IsarCollection<dynamic> col, Id id, CoinTransaction object) {
  object.id = id;
}

extension CoinTransactionByIndex on IsarCollection<CoinTransaction> {
  Future<CoinTransaction?> getByRefKey(String refKey) {
    return getByIndex(r'refKey', [refKey]);
  }

  CoinTransaction? getByRefKeySync(String refKey) {
    return getByIndexSync(r'refKey', [refKey]);
  }

  Future<bool> deleteByRefKey(String refKey) {
    return deleteByIndex(r'refKey', [refKey]);
  }

  bool deleteByRefKeySync(String refKey) {
    return deleteByIndexSync(r'refKey', [refKey]);
  }

  Future<List<CoinTransaction?>> getAllByRefKey(List<String> refKeyValues) {
    final values = refKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'refKey', values);
  }

  List<CoinTransaction?> getAllByRefKeySync(List<String> refKeyValues) {
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

  Future<Id> putByRefKey(CoinTransaction object) {
    return putByIndex(r'refKey', object);
  }

  Id putByRefKeySync(CoinTransaction object, {bool saveLinks = true}) {
    return putByIndexSync(r'refKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRefKey(List<CoinTransaction> objects) {
    return putAllByIndex(r'refKey', objects);
  }

  List<Id> putAllByRefKeySync(List<CoinTransaction> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'refKey', objects, saveLinks: saveLinks);
  }
}

extension CoinTransactionQueryWhereSort
    on QueryBuilder<CoinTransaction, CoinTransaction, QWhere> {
  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension CoinTransactionQueryWhere
    on QueryBuilder<CoinTransaction, CoinTransaction, QWhereClause> {
  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause> idBetween(
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      refKeyEqualTo(String refKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'refKey',
        value: [refKey],
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      refKeyNotEqualTo(String refKey) {
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CoinTransactionQueryFilter
    on QueryBuilder<CoinTransaction, CoinTransaction, QFilterCondition> {
  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      amountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      amountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      reasonEqualTo(CoinReason value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      reasonGreaterThan(
    CoinReason value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reason',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      reasonLessThan(
    CoinReason value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reason',
        value: value,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      reasonBetween(
    CoinReason lower,
    CoinReason upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyEqualTo(
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyGreaterThan(
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyLessThan(
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyBetween(
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyStartsWith(
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyEndsWith(
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

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'refKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'refKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refKey',
        value: '',
      ));
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterFilterCondition>
      refKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'refKey',
        value: '',
      ));
    });
  }
}

extension CoinTransactionQueryObject
    on QueryBuilder<CoinTransaction, CoinTransaction, QFilterCondition> {}

extension CoinTransactionQueryLinks
    on QueryBuilder<CoinTransaction, CoinTransaction, QFilterCondition> {}

extension CoinTransactionQuerySortBy
    on QueryBuilder<CoinTransaction, CoinTransaction, QSortBy> {
  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> sortByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      sortByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> sortByRefKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      sortByRefKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.desc);
    });
  }
}

extension CoinTransactionQuerySortThenBy
    on QueryBuilder<CoinTransaction, CoinTransaction, QSortThenBy> {
  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> thenByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      thenByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy> thenByRefKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.asc);
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QAfterSortBy>
      thenByRefKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refKey', Sort.desc);
    });
  }
}

extension CoinTransactionQueryWhereDistinct
    on QueryBuilder<CoinTransaction, CoinTransaction, QDistinct> {
  QueryBuilder<CoinTransaction, CoinTransaction, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QDistinct> distinctByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reason');
    });
  }

  QueryBuilder<CoinTransaction, CoinTransaction, QDistinct> distinctByRefKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refKey', caseSensitive: caseSensitive);
    });
  }
}

extension CoinTransactionQueryProperty
    on QueryBuilder<CoinTransaction, CoinTransaction, QQueryProperty> {
  QueryBuilder<CoinTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CoinTransaction, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<CoinTransaction, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CoinTransaction, CoinReason, QQueryOperations> reasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reason');
    });
  }

  QueryBuilder<CoinTransaction, String, QQueryOperations> refKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refKey');
    });
  }
}
