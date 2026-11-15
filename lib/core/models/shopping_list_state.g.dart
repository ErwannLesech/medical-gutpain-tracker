// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_state.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShoppingListItemStateCollection on Isar {
  IsarCollection<ShoppingListItemState> get shoppingListItemStates =>
      this.collection();
}

const ShoppingListItemStateSchema = CollectionSchema(
  name: r'ShoppingListItemState',
  id: 1664632793652662842,
  properties: {
    r'foodName': PropertySchema(
      id: 0,
      name: r'foodName',
      type: IsarType.string,
    ),
    r'isChecked': PropertySchema(
      id: 1,
      name: r'isChecked',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _shoppingListItemStateEstimateSize,
  serialize: _shoppingListItemStateSerialize,
  deserialize: _shoppingListItemStateDeserialize,
  deserializeProp: _shoppingListItemStateDeserializeProp,
  idName: r'id',
  indexes: {
    r'foodName': IndexSchema(
      id: -2163334474423597395,
      name: r'foodName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'foodName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _shoppingListItemStateGetId,
  getLinks: _shoppingListItemStateGetLinks,
  attach: _shoppingListItemStateAttach,
  version: '3.1.0+1',
);

int _shoppingListItemStateEstimateSize(
  ShoppingListItemState object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.foodName.length * 3;
  return bytesCount;
}

void _shoppingListItemStateSerialize(
  ShoppingListItemState object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.foodName);
  writer.writeBool(offsets[1], object.isChecked);
  writer.writeDateTime(offsets[2], object.updatedAt);
}

ShoppingListItemState _shoppingListItemStateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ShoppingListItemState(
    foodName: reader.readString(offsets[0]),
    isChecked: reader.readBoolOrNull(offsets[1]) ?? false,
  );
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _shoppingListItemStateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _shoppingListItemStateGetId(ShoppingListItemState object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _shoppingListItemStateGetLinks(
    ShoppingListItemState object) {
  return [];
}

void _shoppingListItemStateAttach(
    IsarCollection<dynamic> col, Id id, ShoppingListItemState object) {
  object.id = id;
}

extension ShoppingListItemStateByIndex
    on IsarCollection<ShoppingListItemState> {
  Future<ShoppingListItemState?> getByFoodName(String foodName) {
    return getByIndex(r'foodName', [foodName]);
  }

  ShoppingListItemState? getByFoodNameSync(String foodName) {
    return getByIndexSync(r'foodName', [foodName]);
  }

  Future<bool> deleteByFoodName(String foodName) {
    return deleteByIndex(r'foodName', [foodName]);
  }

  bool deleteByFoodNameSync(String foodName) {
    return deleteByIndexSync(r'foodName', [foodName]);
  }

  Future<List<ShoppingListItemState?>> getAllByFoodName(
      List<String> foodNameValues) {
    final values = foodNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'foodName', values);
  }

  List<ShoppingListItemState?> getAllByFoodNameSync(
      List<String> foodNameValues) {
    final values = foodNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'foodName', values);
  }

  Future<int> deleteAllByFoodName(List<String> foodNameValues) {
    final values = foodNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'foodName', values);
  }

  int deleteAllByFoodNameSync(List<String> foodNameValues) {
    final values = foodNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'foodName', values);
  }

  Future<Id> putByFoodName(ShoppingListItemState object) {
    return putByIndex(r'foodName', object);
  }

  Id putByFoodNameSync(ShoppingListItemState object, {bool saveLinks = true}) {
    return putByIndexSync(r'foodName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFoodName(List<ShoppingListItemState> objects) {
    return putAllByIndex(r'foodName', objects);
  }

  List<Id> putAllByFoodNameSync(List<ShoppingListItemState> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'foodName', objects, saveLinks: saveLinks);
  }
}

extension ShoppingListItemStateQueryWhereSort
    on QueryBuilder<ShoppingListItemState, ShoppingListItemState, QWhere> {
  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ShoppingListItemStateQueryWhere on QueryBuilder<ShoppingListItemState,
    ShoppingListItemState, QWhereClause> {
  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhereClause>
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

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhereClause>
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

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhereClause>
      foodNameEqualTo(String foodName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'foodName',
        value: [foodName],
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterWhereClause>
      foodNameNotEqualTo(String foodName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodName',
              lower: [],
              upper: [foodName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodName',
              lower: [foodName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodName',
              lower: [foodName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'foodName',
              lower: [],
              upper: [foodName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ShoppingListItemStateQueryFilter on QueryBuilder<
    ShoppingListItemState, ShoppingListItemState, QFilterCondition> {
  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foodName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
          QAfterFilterCondition>
      foodNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
          QAfterFilterCondition>
      foodNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foodName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodName',
        value: '',
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> foodNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foodName',
        value: '',
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> isCheckedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isChecked',
        value: value,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<ShoppingListItemState, ShoppingListItemState,
      QAfterFilterCondition> updatedAtBetween(
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

extension ShoppingListItemStateQueryObject on QueryBuilder<
    ShoppingListItemState, ShoppingListItemState, QFilterCondition> {}

extension ShoppingListItemStateQueryLinks on QueryBuilder<ShoppingListItemState,
    ShoppingListItemState, QFilterCondition> {}

extension ShoppingListItemStateQuerySortBy
    on QueryBuilder<ShoppingListItemState, ShoppingListItemState, QSortBy> {
  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      sortByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      sortByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      sortByIsChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChecked', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      sortByIsCheckedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChecked', Sort.desc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ShoppingListItemStateQuerySortThenBy
    on QueryBuilder<ShoppingListItemState, ShoppingListItemState, QSortThenBy> {
  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenByIsChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChecked', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenByIsCheckedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChecked', Sort.desc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ShoppingListItemStateQueryWhereDistinct
    on QueryBuilder<ShoppingListItemState, ShoppingListItemState, QDistinct> {
  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QDistinct>
      distinctByFoodName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QDistinct>
      distinctByIsChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isChecked');
    });
  }

  QueryBuilder<ShoppingListItemState, ShoppingListItemState, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ShoppingListItemStateQueryProperty on QueryBuilder<
    ShoppingListItemState, ShoppingListItemState, QQueryProperty> {
  QueryBuilder<ShoppingListItemState, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ShoppingListItemState, String, QQueryOperations>
      foodNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodName');
    });
  }

  QueryBuilder<ShoppingListItemState, bool, QQueryOperations>
      isCheckedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isChecked');
    });
  }

  QueryBuilder<ShoppingListItemState, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
