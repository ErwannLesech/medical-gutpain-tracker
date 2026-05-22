import 'package:isar/isar.dart';

part 'daily_report.g.dart';

/// État global de la journée
enum DayStatus {
  excellent,  // Excellente journée
  good,       // Bonne journée
  average,    // Journée moyenne
  difficult,  // Journée difficile
  terrible,   // Très mauvaise journée
}

/// Qualité du transit
enum TransitQuality {
  normal,       // Normal
  diarrhea,     // Diarrhée
  constipation, // Constipation
  mixed,        // Alternance
  none,         // Pas de selles
}

/// Rapport journalier
/// Permet de résumer l'état global de la journée
@collection
class DailyReport {
  Id id = Isar.autoIncrement;

  /// Date du rapport (sans l'heure, normalisée à minuit)
  @Index(unique: true)
  DateTime date;

  /// État global de la journée
  @Enumerated(EnumType.ordinal)
  DayStatus status;

  /// Niveau de stress (1 à 5)
  int stressLevel;

  /// Niveau de fatigue (1 à 5)
  int fatigueLevel;

  /// Qualité du transit
  @Enumerated(EnumType.ordinal)
  TransitQuality transitQuality;

  /// Nombre de selles dans la journée
  int bowelMovements;

  /// Qualité du sommeil la nuit précédente (1 à 5)
  int sleepQuality;

  /// Heures de sommeil
  double hoursSlept;

  /// Notes optionnelles
  String? notes;

  /// Médicaments pris ce jour
  List<String> medications;

  /// Date de création de l'entrée
  DateTime createdAt;

  /// Date de dernière modification
  DateTime updatedAt;

  DailyReport({
    required this.date,
    this.status = DayStatus.average,
    this.stressLevel = 3,
    this.fatigueLevel = 3,
    this.transitQuality = TransitQuality.normal,
    this.bowelMovements = 1,
    this.sleepQuality = 3,
    this.hoursSlept = 7,
    this.notes,
    this.medications = const [],
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Retourne le nom lisible du statut
  String get statusName {
    switch (status) {
      case DayStatus.excellent:
        return 'Excellente';
      case DayStatus.good:
        return 'Bonne';
      case DayStatus.average:
        return 'Moyenne';
      case DayStatus.difficult:
        return 'Difficile';
      case DayStatus.terrible:
        return 'Très difficile';
    }
  }

  /// Retourne l'emoji associé au statut
  String get statusEmoji {
    switch (status) {
      case DayStatus.excellent:
        return '😄';
      case DayStatus.good:
        return '🙂';
      case DayStatus.average:
        return '😐';
      case DayStatus.difficult:
        return '😔';
      case DayStatus.terrible:
        return '😢';
    }
  }

  /// Retourne la couleur associée au statut (en hex)
  int get statusColorValue {
    switch (status) {
      case DayStatus.excellent:
        return 0xFF4CAF50; // Vert
      case DayStatus.good:
        return 0xFF8BC34A; // Vert clair
      case DayStatus.average:
        return 0xFFFFEB3B; // Jaune
      case DayStatus.difficult:
        return 0xFFFF9800; // Orange
      case DayStatus.terrible:
        return 0xFFF44336; // Rouge
    }
  }

  /// Retourne le nom lisible de la qualité du transit
  String get transitQualityName {
    switch (transitQuality) {
      case TransitQuality.normal:
        return 'Normal';
      case TransitQuality.diarrhea:
        return 'Diarrhée';
      case TransitQuality.constipation:
        return 'Constipation';
      case TransitQuality.mixed:
        return 'Alternance';
      case TransitQuality.none:
        return 'Pas de selles';
    }
  }

  /// Normalise une date à minuit (pour l'index unique)
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Copie le rapport avec des modifications
  DailyReport copyWith({
    DateTime? date,
    DayStatus? status,
    int? stressLevel,
    int? fatigueLevel,
    TransitQuality? transitQuality,
    int? bowelMovements,
    int? sleepQuality,
    double? hoursSlept,
    String? notes,
    List<String>? medications,
  }) {
    final copy = DailyReport(
      date: date ?? this.date,
      status: status ?? this.status,
      stressLevel: stressLevel ?? this.stressLevel,
      fatigueLevel: fatigueLevel ?? this.fatigueLevel,
      transitQuality: transitQuality ?? this.transitQuality,
      bowelMovements: bowelMovements ?? this.bowelMovements,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      hoursSlept: hoursSlept ?? this.hoursSlept,
      notes: notes ?? this.notes,
      medications: medications ?? List.from(this.medications),
    );
    copy.id = id;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }
}
