// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pain_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPainEventCollection on Isar {
  IsarCollection<PainEvent> get painEvents => this.collection();
}

const PainEventSchema = CollectionSchema(
  name: r'PainEvent',
  id: 7439142611807898418,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateTime': PropertySchema(
      id: 1,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'delayFromMealFormatted': PropertySchema(
      id: 2,
      name: r'delayFromMealFormatted',
      type: IsarType.string,
    ),
    r'delayFromMealMinutes': PropertySchema(
      id: 3,
      name: r'delayFromMealMinutes',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 4,
      name: r'description',
      type: IsarType.string,
    ),
    r'digestiveState': PropertySchema(
      id: 5,
      name: r'digestiveState',
      type: IsarType.byte,
      enumMap: _PainEventdigestiveStateEnumValueMap,
    ),
    r'digestiveStateName': PropertySchema(
      id: 6,
      name: r'digestiveStateName',
      type: IsarType.string,
    ),
    r'intensity': PropertySchema(
      id: 7,
      name: r'intensity',
      type: IsarType.long,
    ),
    r'intensityColorValue': PropertySchema(
      id: 8,
      name: r'intensityColorValue',
      type: IsarType.long,
    ),
    r'intensityEmoji': PropertySchema(
      id: 9,
      name: r'intensityEmoji',
      type: IsarType.string,
    ),
    r'intensityName': PropertySchema(
      id: 10,
      name: r'intensityName',
      type: IsarType.string,
    ),
    r'isUsual': PropertySchema(
      id: 11,
      name: r'isUsual',
      type: IsarType.bool,
    ),
    r'linkedMealId': PropertySchema(
      id: 12,
      name: r'linkedMealId',
      type: IsarType.long,
    ),
    r'location': PropertySchema(
      id: 13,
      name: r'location',
      type: IsarType.byte,
      enumMap: _PainEventlocationEnumValueMap,
    ),
    r'locationName': PropertySchema(
      id: 14,
      name: r'locationName',
      type: IsarType.string,
    ),
    r'otherMomentDescription': PropertySchema(
      id: 15,
      name: r'otherMomentDescription',
      type: IsarType.string,
    ),
    r'symptomsIndexes': PropertySchema(
      id: 16,
      name: r'symptomsIndexes',
      type: IsarType.longList,
    ),
    r'updatedAt': PropertySchema(
      id: 17,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _painEventEstimateSize,
  serialize: _painEventSerialize,
  deserialize: _painEventDeserialize,
  deserializeProp: _painEventDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateTime': IndexSchema(
      id: -138851979697481250,
      name: r'dateTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _painEventGetId,
  getLinks: _painEventGetLinks,
  attach: _painEventAttach,
  version: '3.1.0+1',
);

int _painEventEstimateSize(
  PainEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.delayFromMealFormatted.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.digestiveStateName.length * 3;
  bytesCount += 3 + object.intensityEmoji.length * 3;
  bytesCount += 3 + object.intensityName.length * 3;
  bytesCount += 3 + object.locationName.length * 3;
  {
    final value = object.otherMomentDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.symptomsIndexes.length * 8;
  return bytesCount;
}

void _painEventSerialize(
  PainEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.dateTime);
  writer.writeString(offsets[2], object.delayFromMealFormatted);
  writer.writeLong(offsets[3], object.delayFromMealMinutes);
  writer.writeString(offsets[4], object.description);
  writer.writeByte(offsets[5], object.digestiveState.index);
  writer.writeString(offsets[6], object.digestiveStateName);
  writer.writeLong(offsets[7], object.intensity);
  writer.writeLong(offsets[8], object.intensityColorValue);
  writer.writeString(offsets[9], object.intensityEmoji);
  writer.writeString(offsets[10], object.intensityName);
  writer.writeBool(offsets[11], object.isUsual);
  writer.writeLong(offsets[12], object.linkedMealId);
  writer.writeByte(offsets[13], object.location.index);
  writer.writeString(offsets[14], object.locationName);
  writer.writeString(offsets[15], object.otherMomentDescription);
  writer.writeLongList(offsets[16], object.symptomsIndexes);
  writer.writeDateTime(offsets[17], object.updatedAt);
}

PainEvent _painEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PainEvent(
    dateTime: reader.readDateTime(offsets[1]),
    delayFromMealMinutes: reader.readLongOrNull(offsets[3]),
    description: reader.readStringOrNull(offsets[4]),
    digestiveState: _PainEventdigestiveStateValueEnumMap[
            reader.readByteOrNull(offsets[5])] ??
        DigestiveState.hungry,
    intensity: reader.readLong(offsets[7]),
    isUsual: reader.readBoolOrNull(offsets[11]) ?? true,
    linkedMealId: reader.readLongOrNull(offsets[12]),
    location:
        _PainEventlocationValueEnumMap[reader.readByteOrNull(offsets[13])] ??
            PainLocation.diffuse,
    otherMomentDescription: reader.readStringOrNull(offsets[15]),
    symptomsIndexes: reader.readLongList(offsets[16]) ?? const [],
  );
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[17]);
  return object;
}

P _painEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (_PainEventdigestiveStateValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DigestiveState.hungry) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (_PainEventlocationValueEnumMap[reader.readByteOrNull(offset)] ??
          PainLocation.diffuse) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readLongList(offset) ?? const []) as P;
    case 17:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PainEventdigestiveStateEnumValueMap = {
  'hungry': 0,
  'postMeal': 1,
  'other': 2,
};
const _PainEventdigestiveStateValueEnumMap = {
  0: DigestiveState.hungry,
  1: DigestiveState.postMeal,
  2: DigestiveState.other,
};
const _PainEventlocationEnumValueMap = {
  'upperAbdomen': 0,
  'lowerAbdomen': 1,
  'leftSide': 2,
  'rightSide': 3,
  'central': 4,
  'diffuse': 5,
};
const _PainEventlocationValueEnumMap = {
  0: PainLocation.upperAbdomen,
  1: PainLocation.lowerAbdomen,
  2: PainLocation.leftSide,
  3: PainLocation.rightSide,
  4: PainLocation.central,
  5: PainLocation.diffuse,
};

Id _painEventGetId(PainEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _painEventGetLinks(PainEvent object) {
  return [];
}

void _painEventAttach(IsarCollection<dynamic> col, Id id, PainEvent object) {
  object.id = id;
}

extension PainEventQueryWhereSort
    on QueryBuilder<PainEvent, PainEvent, QWhere> {
  QueryBuilder<PainEvent, PainEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhere> anyDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateTime'),
      );
    });
  }
}

extension PainEventQueryWhere
    on QueryBuilder<PainEvent, PainEvent, QWhereClause> {
  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> idBetween(
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

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> dateTimeEqualTo(
      DateTime dateTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateTime',
        value: [dateTime],
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> dateTimeNotEqualTo(
      DateTime dateTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [],
              upper: [dateTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [dateTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [dateTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [],
              upper: [dateTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> dateTimeGreaterThan(
    DateTime dateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateTime',
        lower: [dateTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> dateTimeLessThan(
    DateTime dateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateTime',
        lower: [],
        upper: [dateTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterWhereClause> dateTimeBetween(
    DateTime lowerDateTime,
    DateTime upperDateTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateTime',
        lower: [lowerDateTime],
        includeLower: includeLower,
        upper: [upperDateTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PainEventQueryFilter
    on QueryBuilder<PainEvent, PainEvent, QFilterCondition> {
  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> dateTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> dateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> dateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> dateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delayFromMealFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'delayFromMealFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'delayFromMealFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'delayFromMealFormatted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'delayFromMealFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'delayFromMealFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'delayFromMealFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'delayFromMealFormatted',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delayFromMealFormatted',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealFormattedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'delayFromMealFormatted',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'delayFromMealMinutes',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'delayFromMealMinutes',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delayFromMealMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'delayFromMealMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'delayFromMealMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      delayFromMealMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'delayFromMealMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateEqualTo(DigestiveState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'digestiveState',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateGreaterThan(
    DigestiveState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'digestiveState',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateLessThan(
    DigestiveState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'digestiveState',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateBetween(
    DigestiveState lower,
    DigestiveState upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'digestiveState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'digestiveStateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'digestiveStateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'digestiveStateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'digestiveStateName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'digestiveStateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'digestiveStateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'digestiveStateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'digestiveStateName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'digestiveStateName',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      digestiveStateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'digestiveStateName',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> intensityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensity',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intensity',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> intensityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intensity',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> intensityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intensity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intensityColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intensityColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intensityColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intensityEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intensityEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intensityEmoji',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'intensityEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'intensityEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'intensityEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'intensityEmoji',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityEmoji',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityEmojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'intensityEmoji',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intensityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intensityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intensityName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'intensityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'intensityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'intensityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'intensityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityName',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      intensityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'intensityName',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> isUsualEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isUsual',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      linkedMealIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedMealId',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      linkedMealIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedMealId',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> linkedMealIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedMealId',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      linkedMealIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedMealId',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      linkedMealIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedMealId',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> linkedMealIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedMealId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> locationEqualTo(
      PainLocation value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> locationGreaterThan(
    PainLocation value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> locationLessThan(
    PainLocation value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> locationBetween(
    PainLocation lower,
    PainLocation upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> locationNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      locationNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      locationNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> locationNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      locationNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      locationNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      locationNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> locationNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locationName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      locationNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationName',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      locationNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locationName',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'otherMomentDescription',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'otherMomentDescription',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherMomentDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'otherMomentDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'otherMomentDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'otherMomentDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'otherMomentDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'otherMomentDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'otherMomentDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'otherMomentDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherMomentDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      otherMomentDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'otherMomentDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symptomsIndexes',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'symptomsIndexes',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'symptomsIndexes',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'symptomsIndexes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptomsIndexes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptomsIndexes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptomsIndexes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptomsIndexes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptomsIndexes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      symptomsIndexesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptomsIndexes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<PainEvent, PainEvent, QAfterFilterCondition> updatedAtBetween(
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

extension PainEventQueryObject
    on QueryBuilder<PainEvent, PainEvent, QFilterCondition> {}

extension PainEventQueryLinks
    on QueryBuilder<PainEvent, PainEvent, QFilterCondition> {}

extension PainEventQuerySortBy on QueryBuilder<PainEvent, PainEvent, QSortBy> {
  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByDelayFromMealFormatted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealFormatted', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByDelayFromMealFormattedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealFormatted', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByDelayFromMealMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealMinutes', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByDelayFromMealMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealMinutes', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByDigestiveState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveState', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByDigestiveStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveState', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByDigestiveStateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveStateName', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByDigestiveStateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveStateName', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIntensityColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityColorValue', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByIntensityColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityColorValue', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIntensityEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityEmoji', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIntensityEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityEmoji', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIntensityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityName', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIntensityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityName', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIsUsual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsual', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByIsUsualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsual', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByLinkedMealId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedMealId', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByLinkedMealIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedMealId', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByLocationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationName', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByLocationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationName', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByOtherMomentDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherMomentDescription', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      sortByOtherMomentDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherMomentDescription', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PainEventQuerySortThenBy
    on QueryBuilder<PainEvent, PainEvent, QSortThenBy> {
  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByDelayFromMealFormatted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealFormatted', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByDelayFromMealFormattedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealFormatted', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByDelayFromMealMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealMinutes', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByDelayFromMealMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayFromMealMinutes', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByDigestiveState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveState', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByDigestiveStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveState', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByDigestiveStateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveStateName', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByDigestiveStateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestiveStateName', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIntensityColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityColorValue', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByIntensityColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityColorValue', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIntensityEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityEmoji', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIntensityEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityEmoji', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIntensityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityName', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIntensityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensityName', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIsUsual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsual', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByIsUsualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsual', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByLinkedMealId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedMealId', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByLinkedMealIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedMealId', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByLocationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationName', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByLocationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationName', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByOtherMomentDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherMomentDescription', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy>
      thenByOtherMomentDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherMomentDescription', Sort.desc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PainEventQueryWhereDistinct
    on QueryBuilder<PainEvent, PainEvent, QDistinct> {
  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct>
      distinctByDelayFromMealFormatted({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delayFromMealFormatted',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct>
      distinctByDelayFromMealMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delayFromMealMinutes');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByDigestiveState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'digestiveState');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByDigestiveStateName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'digestiveStateName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intensity');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct>
      distinctByIntensityColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intensityColorValue');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByIntensityEmoji(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intensityEmoji',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByIntensityName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intensityName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByIsUsual() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUsual');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByLinkedMealId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedMealId');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByLocationName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct>
      distinctByOtherMomentDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'otherMomentDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctBySymptomsIndexes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'symptomsIndexes');
    });
  }

  QueryBuilder<PainEvent, PainEvent, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PainEventQueryProperty
    on QueryBuilder<PainEvent, PainEvent, QQueryProperty> {
  QueryBuilder<PainEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PainEvent, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PainEvent, DateTime, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<PainEvent, String, QQueryOperations>
      delayFromMealFormattedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delayFromMealFormatted');
    });
  }

  QueryBuilder<PainEvent, int?, QQueryOperations>
      delayFromMealMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delayFromMealMinutes');
    });
  }

  QueryBuilder<PainEvent, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<PainEvent, DigestiveState, QQueryOperations>
      digestiveStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'digestiveState');
    });
  }

  QueryBuilder<PainEvent, String, QQueryOperations>
      digestiveStateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'digestiveStateName');
    });
  }

  QueryBuilder<PainEvent, int, QQueryOperations> intensityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intensity');
    });
  }

  QueryBuilder<PainEvent, int, QQueryOperations> intensityColorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intensityColorValue');
    });
  }

  QueryBuilder<PainEvent, String, QQueryOperations> intensityEmojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intensityEmoji');
    });
  }

  QueryBuilder<PainEvent, String, QQueryOperations> intensityNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intensityName');
    });
  }

  QueryBuilder<PainEvent, bool, QQueryOperations> isUsualProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUsual');
    });
  }

  QueryBuilder<PainEvent, int?, QQueryOperations> linkedMealIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedMealId');
    });
  }

  QueryBuilder<PainEvent, PainLocation, QQueryOperations> locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<PainEvent, String, QQueryOperations> locationNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationName');
    });
  }

  QueryBuilder<PainEvent, String?, QQueryOperations>
      otherMomentDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'otherMomentDescription');
    });
  }

  QueryBuilder<PainEvent, List<int>, QQueryOperations>
      symptomsIndexesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'symptomsIndexes');
    });
  }

  QueryBuilder<PainEvent, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
