// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAchievementCollection on Isar {
  IsarCollection<Achievement> get achievements => this.collection();
}

const AchievementSchema = CollectionSchema(
  name: r'Achievement',
  id: -1511299366265280024,
  properties: {
    r'badgeType': PropertySchema(
      id: 0,
      name: r'badgeType',
      type: IsarType.byte,
      enumMap: _AchievementbadgeTypeEnumValueMap,
    ),
    r'seen': PropertySchema(
      id: 1,
      name: r'seen',
      type: IsarType.bool,
    ),
    r'unlockedAt': PropertySchema(
      id: 2,
      name: r'unlockedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _achievementEstimateSize,
  serialize: _achievementSerialize,
  deserialize: _achievementDeserialize,
  deserializeProp: _achievementDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _achievementGetId,
  getLinks: _achievementGetLinks,
  attach: _achievementAttach,
  version: '3.1.0+1',
);

int _achievementEstimateSize(
  Achievement object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _achievementSerialize(
  Achievement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.badgeType.index);
  writer.writeBool(offsets[1], object.seen);
  writer.writeDateTime(offsets[2], object.unlockedAt);
}

Achievement _achievementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Achievement();
  object.badgeType =
      _AchievementbadgeTypeValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          BadgeType.streak3;
  object.id = id;
  object.seen = reader.readBool(offsets[1]);
  object.unlockedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _achievementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_AchievementbadgeTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BadgeType.streak3) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AchievementbadgeTypeEnumValueMap = {
  'streak3': 0,
  'streak7': 1,
  'streak14': 2,
  'streak30': 3,
  'streak60': 4,
  'streak100': 5,
  'journal10': 6,
  'journal30': 7,
  'journal60': 8,
  'journal100': 9,
  'meals50': 10,
  'meals100': 11,
  'meals250': 12,
  'meals500': 13,
  'painTracking7': 14,
  'painTracking30': 15,
  'painTracking60': 16,
  'firstWeek': 17,
  'firstMonth': 18,
  'consistent': 19,
  'explorer': 20,
  'champion': 21,
};
const _AchievementbadgeTypeValueEnumMap = {
  0: BadgeType.streak3,
  1: BadgeType.streak7,
  2: BadgeType.streak14,
  3: BadgeType.streak30,
  4: BadgeType.streak60,
  5: BadgeType.streak100,
  6: BadgeType.journal10,
  7: BadgeType.journal30,
  8: BadgeType.journal60,
  9: BadgeType.journal100,
  10: BadgeType.meals50,
  11: BadgeType.meals100,
  12: BadgeType.meals250,
  13: BadgeType.meals500,
  14: BadgeType.painTracking7,
  15: BadgeType.painTracking30,
  16: BadgeType.painTracking60,
  17: BadgeType.firstWeek,
  18: BadgeType.firstMonth,
  19: BadgeType.consistent,
  20: BadgeType.explorer,
  21: BadgeType.champion,
};

Id _achievementGetId(Achievement object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _achievementGetLinks(Achievement object) {
  return [];
}

void _achievementAttach(
    IsarCollection<dynamic> col, Id id, Achievement object) {
  object.id = id;
}

extension AchievementQueryWhereSort
    on QueryBuilder<Achievement, Achievement, QWhere> {
  QueryBuilder<Achievement, Achievement, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AchievementQueryWhere
    on QueryBuilder<Achievement, Achievement, QWhereClause> {
  QueryBuilder<Achievement, Achievement, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<Achievement, Achievement, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterWhereClause> idBetween(
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
}

extension AchievementQueryFilter
    on QueryBuilder<Achievement, Achievement, QFilterCondition> {
  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      badgeTypeEqualTo(BadgeType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgeType',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      badgeTypeGreaterThan(
    BadgeType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badgeType',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      badgeTypeLessThan(
    BadgeType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badgeType',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      badgeTypeBetween(
    BadgeType lower,
    BadgeType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badgeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition> seenEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seen',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      unlockedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      unlockedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      unlockedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterFilterCondition>
      unlockedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unlockedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AchievementQueryObject
    on QueryBuilder<Achievement, Achievement, QFilterCondition> {}

extension AchievementQueryLinks
    on QueryBuilder<Achievement, Achievement, QFilterCondition> {}

extension AchievementQuerySortBy
    on QueryBuilder<Achievement, Achievement, QSortBy> {
  QueryBuilder<Achievement, Achievement, QAfterSortBy> sortByBadgeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeType', Sort.asc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> sortByBadgeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeType', Sort.desc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> sortBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.asc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> sortBySeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.desc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> sortByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> sortByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AchievementQuerySortThenBy
    on QueryBuilder<Achievement, Achievement, QSortThenBy> {
  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenByBadgeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeType', Sort.asc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenByBadgeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeType', Sort.desc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.asc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenBySeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.desc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<Achievement, Achievement, QAfterSortBy> thenByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AchievementQueryWhereDistinct
    on QueryBuilder<Achievement, Achievement, QDistinct> {
  QueryBuilder<Achievement, Achievement, QDistinct> distinctByBadgeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badgeType');
    });
  }

  QueryBuilder<Achievement, Achievement, QDistinct> distinctBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seen');
    });
  }

  QueryBuilder<Achievement, Achievement, QDistinct> distinctByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedAt');
    });
  }
}

extension AchievementQueryProperty
    on QueryBuilder<Achievement, Achievement, QQueryProperty> {
  QueryBuilder<Achievement, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Achievement, BadgeType, QQueryOperations> badgeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badgeType');
    });
  }

  QueryBuilder<Achievement, bool, QQueryOperations> seenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seen');
    });
  }

  QueryBuilder<Achievement, DateTime, QQueryOperations> unlockedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedAt');
    });
  }
}
