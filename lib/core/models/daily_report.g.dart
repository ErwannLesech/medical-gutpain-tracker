// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_report.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyReportCollection on Isar {
  IsarCollection<DailyReport> get dailyReports => this.collection();
}

const DailyReportSchema = CollectionSchema(
  name: r'DailyReport',
  id: -3611253067269952573,
  properties: {
    r'bowelMovements': PropertySchema(
      id: 0,
      name: r'bowelMovements',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'fatigueLevel': PropertySchema(
      id: 3,
      name: r'fatigueLevel',
      type: IsarType.long,
    ),
    r'hoursSlept': PropertySchema(
      id: 4,
      name: r'hoursSlept',
      type: IsarType.double,
    ),
    r'medications': PropertySchema(
      id: 5,
      name: r'medications',
      type: IsarType.stringList,
    ),
    r'notes': PropertySchema(
      id: 6,
      name: r'notes',
      type: IsarType.string,
    ),
    r'sleepQuality': PropertySchema(
      id: 7,
      name: r'sleepQuality',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.byte,
      enumMap: _DailyReportstatusEnumValueMap,
    ),
    r'statusColorValue': PropertySchema(
      id: 9,
      name: r'statusColorValue',
      type: IsarType.long,
    ),
    r'statusEmoji': PropertySchema(
      id: 10,
      name: r'statusEmoji',
      type: IsarType.string,
    ),
    r'statusName': PropertySchema(
      id: 11,
      name: r'statusName',
      type: IsarType.string,
    ),
    r'stressLevel': PropertySchema(
      id: 12,
      name: r'stressLevel',
      type: IsarType.long,
    ),
    r'transitQuality': PropertySchema(
      id: 13,
      name: r'transitQuality',
      type: IsarType.byte,
      enumMap: _DailyReporttransitQualityEnumValueMap,
    ),
    r'transitQualityName': PropertySchema(
      id: 14,
      name: r'transitQualityName',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dailyReportEstimateSize,
  serialize: _dailyReportSerialize,
  deserialize: _dailyReportDeserialize,
  deserializeProp: _dailyReportDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyReportGetId,
  getLinks: _dailyReportGetLinks,
  attach: _dailyReportAttach,
  version: '3.1.0+1',
);

int _dailyReportEstimateSize(
  DailyReport object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.medications.length * 3;
  {
    for (var i = 0; i < object.medications.length; i++) {
      final value = object.medications[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.statusEmoji.length * 3;
  bytesCount += 3 + object.statusName.length * 3;
  bytesCount += 3 + object.transitQualityName.length * 3;
  return bytesCount;
}

void _dailyReportSerialize(
  DailyReport object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bowelMovements);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.fatigueLevel);
  writer.writeDouble(offsets[4], object.hoursSlept);
  writer.writeStringList(offsets[5], object.medications);
  writer.writeString(offsets[6], object.notes);
  writer.writeLong(offsets[7], object.sleepQuality);
  writer.writeByte(offsets[8], object.status.index);
  writer.writeLong(offsets[9], object.statusColorValue);
  writer.writeString(offsets[10], object.statusEmoji);
  writer.writeString(offsets[11], object.statusName);
  writer.writeLong(offsets[12], object.stressLevel);
  writer.writeByte(offsets[13], object.transitQuality.index);
  writer.writeString(offsets[14], object.transitQualityName);
  writer.writeDateTime(offsets[15], object.updatedAt);
}

DailyReport _dailyReportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyReport(
    bowelMovements: reader.readLongOrNull(offsets[0]) ?? 1,
    date: reader.readDateTime(offsets[2]),
    fatigueLevel: reader.readLongOrNull(offsets[3]) ?? 3,
    hoursSlept: reader.readDoubleOrNull(offsets[4]) ?? 7,
    medications: reader.readStringList(offsets[5]) ?? const [],
    notes: reader.readStringOrNull(offsets[6]),
    sleepQuality: reader.readLongOrNull(offsets[7]) ?? 3,
    status: _DailyReportstatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
        DayStatus.average,
    stressLevel: reader.readLongOrNull(offsets[12]) ?? 3,
    transitQuality: _DailyReporttransitQualityValueEnumMap[
            reader.readByteOrNull(offsets[13])] ??
        TransitQuality.normal,
  );
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[15]);
  return object;
}

P _dailyReportDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 4:
      return (reader.readDoubleOrNull(offset) ?? 7) as P;
    case 5:
      return (reader.readStringList(offset) ?? const []) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 8:
      return (_DailyReportstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          DayStatus.average) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 13:
      return (_DailyReporttransitQualityValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransitQuality.normal) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DailyReportstatusEnumValueMap = {
  'excellent': 0,
  'good': 1,
  'average': 2,
  'difficult': 3,
  'terrible': 4,
};
const _DailyReportstatusValueEnumMap = {
  0: DayStatus.excellent,
  1: DayStatus.good,
  2: DayStatus.average,
  3: DayStatus.difficult,
  4: DayStatus.terrible,
};
const _DailyReporttransitQualityEnumValueMap = {
  'normal': 0,
  'diarrhea': 1,
  'constipation': 2,
  'mixed': 3,
  'none': 4,
};
const _DailyReporttransitQualityValueEnumMap = {
  0: TransitQuality.normal,
  1: TransitQuality.diarrhea,
  2: TransitQuality.constipation,
  3: TransitQuality.mixed,
  4: TransitQuality.none,
};

Id _dailyReportGetId(DailyReport object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyReportGetLinks(DailyReport object) {
  return [];
}

void _dailyReportAttach(
    IsarCollection<dynamic> col, Id id, DailyReport object) {
  object.id = id;
}

extension DailyReportByIndex on IsarCollection<DailyReport> {
  Future<DailyReport?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyReport? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyReport?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyReport?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyReport object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyReport object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyReport> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyReport> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyReportQueryWhereSort
    on QueryBuilder<DailyReport, DailyReport, QWhere> {
  QueryBuilder<DailyReport, DailyReport, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyReportQueryWhere
    on QueryBuilder<DailyReport, DailyReport, QWhereClause> {
  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyReportQueryFilter
    on QueryBuilder<DailyReport, DailyReport, QFilterCondition> {
  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      bowelMovementsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bowelMovements',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      bowelMovementsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bowelMovements',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      bowelMovementsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bowelMovements',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      bowelMovementsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bowelMovements',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      fatigueLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatigueLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      fatigueLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatigueLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      fatigueLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatigueLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      fatigueLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatigueLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      hoursSleptEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hoursSlept',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      hoursSleptGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hoursSlept',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      hoursSleptLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hoursSlept',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      hoursSleptBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hoursSlept',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medications',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medications',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medications',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medications',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      medicationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      sleepQualityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepQuality',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      sleepQualityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepQuality',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      sleepQualityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepQuality',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      sleepQualityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepQuality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> statusEqualTo(
      DayStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusGreaterThan(
    DayStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> statusLessThan(
    DayStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition> statusBetween(
    DayStatus lower,
    DayStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusEmoji',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statusEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statusEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusEmoji',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusEmoji',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusEmojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusEmoji',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statusName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statusName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusName',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      statusNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusName',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      stressLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stressLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      stressLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stressLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      stressLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stressLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      stressLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stressLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityEqualTo(TransitQuality value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transitQuality',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityGreaterThan(
    TransitQuality value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transitQuality',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityLessThan(
    TransitQuality value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transitQuality',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityBetween(
    TransitQuality lower,
    TransitQuality upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transitQuality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transitQualityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transitQualityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transitQualityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transitQualityName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transitQualityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transitQualityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transitQualityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transitQualityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transitQualityName',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      transitQualityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transitQualityName',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<DailyReport, DailyReport, QAfterFilterCondition>
      updatedAtBetween(
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

extension DailyReportQueryObject
    on QueryBuilder<DailyReport, DailyReport, QFilterCondition> {}

extension DailyReportQueryLinks
    on QueryBuilder<DailyReport, DailyReport, QFilterCondition> {}

extension DailyReportQuerySortBy
    on QueryBuilder<DailyReport, DailyReport, QSortBy> {
  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByBowelMovements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bowelMovements', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortByBowelMovementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bowelMovements', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByFatigueLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortByFatigueLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByHoursSleptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortBySleepQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortBySleepQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortByStatusColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusColorValue', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortByStatusColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusColorValue', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStatusEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusEmoji', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStatusEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusEmoji', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStatusName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusName', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStatusNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusName', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStressLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByStressLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByTransitQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQuality', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortByTransitQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQuality', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortByTransitQualityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQualityName', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      sortByTransitQualityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQualityName', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DailyReportQuerySortThenBy
    on QueryBuilder<DailyReport, DailyReport, QSortThenBy> {
  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByBowelMovements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bowelMovements', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenByBowelMovementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bowelMovements', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByFatigueLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenByFatigueLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByHoursSleptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenBySleepQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenBySleepQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenByStatusColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusColorValue', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenByStatusColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusColorValue', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStatusEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusEmoji', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStatusEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusEmoji', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStatusName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusName', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStatusNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusName', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStressLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByStressLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByTransitQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQuality', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenByTransitQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQuality', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenByTransitQualityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQualityName', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy>
      thenByTransitQualityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitQualityName', Sort.desc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DailyReportQueryWhereDistinct
    on QueryBuilder<DailyReport, DailyReport, QDistinct> {
  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByBowelMovements() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bowelMovements');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByFatigueLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatigueLevel');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursSlept');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByMedications() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medications');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctBySleepQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepQuality');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct>
      distinctByStatusColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusColorValue');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByStatusEmoji(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusEmoji', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByStatusName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByStressLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stressLevel');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByTransitQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transitQuality');
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct>
      distinctByTransitQualityName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transitQualityName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyReport, DailyReport, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DailyReportQueryProperty
    on QueryBuilder<DailyReport, DailyReport, QQueryProperty> {
  QueryBuilder<DailyReport, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyReport, int, QQueryOperations> bowelMovementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bowelMovements');
    });
  }

  QueryBuilder<DailyReport, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DailyReport, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyReport, int, QQueryOperations> fatigueLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatigueLevel');
    });
  }

  QueryBuilder<DailyReport, double, QQueryOperations> hoursSleptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursSlept');
    });
  }

  QueryBuilder<DailyReport, List<String>, QQueryOperations>
      medicationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medications');
    });
  }

  QueryBuilder<DailyReport, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<DailyReport, int, QQueryOperations> sleepQualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepQuality');
    });
  }

  QueryBuilder<DailyReport, DayStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DailyReport, int, QQueryOperations> statusColorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusColorValue');
    });
  }

  QueryBuilder<DailyReport, String, QQueryOperations> statusEmojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusEmoji');
    });
  }

  QueryBuilder<DailyReport, String, QQueryOperations> statusNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusName');
    });
  }

  QueryBuilder<DailyReport, int, QQueryOperations> stressLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stressLevel');
    });
  }

  QueryBuilder<DailyReport, TransitQuality, QQueryOperations>
      transitQualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transitQuality');
    });
  }

  QueryBuilder<DailyReport, String, QQueryOperations>
      transitQualityNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transitQualityName');
    });
  }

  QueryBuilder<DailyReport, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
