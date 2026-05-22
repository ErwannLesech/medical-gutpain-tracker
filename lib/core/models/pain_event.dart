import 'package:isar/isar.dart';

part 'pain_event.g.dart';

/// État digestif au moment de la douleur
enum DigestiveState {
  hungry,     // À jeun / faim
  postMeal,   // Après un repas
  other,      // Autre moment
}

/// Symptômes associés possibles
enum Symptom {
  bloating,       // Ballonnements
  nausea,         // Nausées
  cramping,       // Crampes
  burning,        // Brûlures
  diarrhea,       // Diarrhée
  constipation,   // Constipation
  gas,            // Gaz
  reflux,         // Reflux
  fatigue,        // Fatigue
  other,          // Autre
}

/// Localisation de la douleur
enum PainLocation {
  upperAbdomen,     // Abdomen supérieur
  lowerAbdomen,     // Abdomen inférieur
  leftSide,         // Côté gauche
  rightSide,        // Côté droit
  central,          // Central / autour du nombril
  diffuse,          // Diffuse / partout
}

/// Événement de douleur
/// Automatiquement relié au dernier repas consommé
@collection
class PainEvent {
  Id id = Isar.autoIncrement;

  /// Date et heure de la douleur
  @Index()
  DateTime dateTime;

  /// Intensité de 1 (légère) à 5 (insupportable)
  int intensity;

  /// Est-ce une douleur habituelle ?
  bool isUsual;

  /// Description courte optionnelle
  String? description;

  /// Description du moment "autre" (quand digestiveState == other)
  String? otherMomentDescription;

  /// Symptômes associés (stockés comme index des enums)
  List<int> symptomsIndexes;

  /// État digestif au moment de la douleur
  @Enumerated(EnumType.ordinal)
  DigestiveState digestiveState;

  /// Localisation de la douleur
  @Enumerated(EnumType.ordinal)
  PainLocation location;

  /// ID du repas associé (dernier repas consommé avant la douleur)
  /// Null si aucun repas trouvé ou à jeun depuis longtemps
  int? linkedMealId;

  /// Délai en minutes entre le repas et la douleur (calculé)
  int? delayFromMealMinutes;

  /// Date de création de l'entrée
  DateTime createdAt;

  /// Date de dernière modification
  DateTime updatedAt;

  PainEvent({
    required this.dateTime,
    required this.intensity,
    this.isUsual = true,
    this.description,
    this.otherMomentDescription,
    this.symptomsIndexes = const [],
    this.digestiveState = DigestiveState.hungry,
    this.location = PainLocation.diffuse,
    this.linkedMealId,
    this.delayFromMealMinutes,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Retourne la liste des symptômes comme enums
  @ignore
  List<Symptom> get symptoms {
    return symptomsIndexes
        .where((index) => index >= 0 && index < Symptom.values.length)
        .map((index) => Symptom.values[index])
        .toList();
  }

  /// Définit les symptômes à partir d'une liste d'enums
  set symptoms(List<Symptom> value) {
    symptomsIndexes = value.map((s) => s.index).toList();
  }

  /// Retourne le nom lisible de l'intensité
  String get intensityName {
    switch (intensity) {
      case 1:
        return 'Légère';
      case 2:
        return 'Modérée';
      case 3:
        return 'Moyenne';
      case 4:
        return 'Forte';
      case 5:
        return 'Intense';
      default:
        return 'Inconnue';
    }
  }

  /// Retourne l'emoji associé à l'intensité
  String get intensityEmoji {
    switch (intensity) {
      case 1:
        return '😐';
      case 2:
        return '😕';
      case 3:
        return '😣';
      case 4:
        return '😖';
      case 5:
        return '😫';
      default:
        return '❓';
    }
  }

  /// Retourne la couleur associée à l'intensité (en hex)
  int get intensityColorValue {
    switch (intensity) {
      case 1:
        return 0xFF4CAF50; // Vert
      case 2:
        return 0xFF8BC34A; // Vert clair
      case 3:
        return 0xFFFFEB3B; // Jaune
      case 4:
        return 0xFFFF9800; // Orange
      case 5:
        return 0xFFF44336; // Rouge
      default:
        return 0xFF9E9E9E; // Gris
    }
  }

  /// Retourne le nom lisible de l'état digestif
  String get digestiveStateName {
    switch (digestiveState) {
      case DigestiveState.hungry:
        return 'À jeun';
      case DigestiveState.postMeal:
        return 'Après repas';
      case DigestiveState.other:
        return otherMomentDescription ?? 'Autre';
    }
  }

  /// Retourne le nom lisible de la localisation
  String get locationName {
    switch (location) {
      case PainLocation.upperAbdomen:
        return 'Haut de l\'abdomen';
      case PainLocation.lowerAbdomen:
        return 'Bas de l\'abdomen';
      case PainLocation.leftSide:
        return 'Côté gauche';
      case PainLocation.rightSide:
        return 'Côté droit';
      case PainLocation.central:
        return 'Central';
      case PainLocation.diffuse:
        return 'Diffuse';
    }
  }

  /// Retourne le délai formaté en texte lisible
  String get delayFromMealFormatted {
    // Si à jeun, afficher "Aucun repas (à jeun)"
    if (digestiveState == DigestiveState.hungry) {
      return 'Aucun repas (à jeun)';
    }
    
    // Si pas de repas lié ou délai > 6h, afficher "Aucun repas récent"
    if (delayFromMealMinutes == null || delayFromMealMinutes! > 360) {
      return 'Aucun repas récent';
    }
    
    final hours = delayFromMealMinutes! ~/ 60;
    final minutes = delayFromMealMinutes! % 60;
    
    if (hours > 0) {
      return '${hours}h${minutes > 0 ? ' ${minutes}min' : ''} après le repas';
    }
    return '${minutes}min après le repas';
  }

  /// Copie l'événement avec des modifications
  PainEvent copyWith({
    DateTime? dateTime,
    int? intensity,
    bool? isUsual,
    String? description,
    String? otherMomentDescription,
    List<int>? symptomsIndexes,
    DigestiveState? digestiveState,
    PainLocation? location,
    int? linkedMealId,
    int? delayFromMealMinutes,
  }) {
    final copy = PainEvent(
      dateTime: dateTime ?? this.dateTime,
      intensity: intensity ?? this.intensity,
      isUsual: isUsual ?? this.isUsual,
      description: description ?? this.description,
      otherMomentDescription: otherMomentDescription ?? this.otherMomentDescription,
      symptomsIndexes: symptomsIndexes ?? List.from(this.symptomsIndexes),
      digestiveState: digestiveState ?? this.digestiveState,
      location: location ?? this.location,
      linkedMealId: linkedMealId ?? this.linkedMealId,
      delayFromMealMinutes: delayFromMealMinutes ?? this.delayFromMealMinutes,
    );
    copy.id = id;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }
}

/// Extension pour obtenir le nom lisible d'un symptôme
extension SymptomExtension on Symptom {
  String get name {
    switch (this) {
      case Symptom.bloating:
        return 'Ballonnements';
      case Symptom.nausea:
        return 'Nausées';
      case Symptom.cramping:
        return 'Crampes';
      case Symptom.burning:
        return 'Brûlures';
      case Symptom.diarrhea:
        return 'Diarrhée';
      case Symptom.constipation:
        return 'Constipation';
      case Symptom.gas:
        return 'Gaz';
      case Symptom.reflux:
        return 'Reflux';
      case Symptom.fatigue:
        return 'Fatigue';
      case Symptom.other:
        return 'Autre';
    }
  }

  String get emoji {
    switch (this) {
      case Symptom.bloating:
        return '🎈';
      case Symptom.nausea:
        return '🤢';
      case Symptom.cramping:
        return '💥';
      case Symptom.burning:
        return '🔥';
      case Symptom.diarrhea:
        return '💨';
      case Symptom.constipation:
        return '🧱';
      case Symptom.gas:
        return '💨';
      case Symptom.reflux:
        return '🔼';
      case Symptom.fatigue:
        return '😴';
      case Symptom.other:
        return '❓';
    }
  }
}
