import 'package:isar/isar.dart';

part 'meal.g.dart';

/// Type de repas
enum MealType {
  breakfast,  // Petit-déjeuner
  lunch,      // Déjeuner
  dinner,     // Dîner
  snack,      // Collation
}

/// État du repas
enum MealStatus {
  planned,    // Planifié mais pas encore confirmé
  confirmed,  // Confirmé comme consommé
  modified,   // Modifié après confirmation
  skipped,    // Repas sauté
}

/// Modèle principal pour un repas
/// C'est l'entité centrale de l'application
@collection
class Meal {
  Id id = Isar.autoIncrement;

  /// Date et heure planifiées du repas
  @Index()
  DateTime plannedDateTime;

  /// Date et heure réelles de consommation (null si pas encore consommé)
  DateTime? consumedDateTime;

  /// Type de repas
  @Enumerated(EnumType.ordinal)
  MealType type;

  /// État du repas
  @Enumerated(EnumType.ordinal)
  MealStatus status;

  /// Titre du repas (ex: "Pâtes carbo", "Salade César")
  String? title;

  /// Liste des aliments consommés
  List<String> foods;

  /// Notes optionnelles
  String? notes;

  /// Quantité estimée (1 = légère, 2 = normale, 3 = copieuse)
  int quantity;

  /// Date de création de l'entrée
  DateTime createdAt;

  /// Date de dernière modification
  DateTime updatedAt;

  Meal({
    required this.plannedDateTime,
    this.consumedDateTime,
    required this.type,
    this.status = MealStatus.planned,
    this.title,
    this.foods = const [],
    this.notes,
    this.quantity = 2,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Retourne true - tous les repas planifiés sont considérés comme consommés
  bool get isConsumed => true;

  /// Retourne le nom lisible du type de repas
  String get typeName {
    switch (type) {
      case MealType.breakfast:
        return 'Petit-déjeuner';
      case MealType.lunch:
        return 'Déjeuner';
      case MealType.dinner:
        return 'Dîner';
      case MealType.snack:
        return 'Collation';
    }
  }

  /// Retourne l'emoji associé au type de repas
  String get typeEmoji {
    switch (type) {
      case MealType.breakfast:
        return '🌅';
      case MealType.lunch:
        return '☀️';
      case MealType.dinner:
        return '🌙';
      case MealType.snack:
        return '🍪';
    }
  }

  /// Copie le repas avec des modifications
  Meal copyWith({
    DateTime? plannedDateTime,
    DateTime? consumedDateTime,
    MealType? type,
    MealStatus? status,
    String? title,
    List<String>? foods,
    String? notes,
    int? quantity,
  }) {
    final copy = Meal(
      plannedDateTime: plannedDateTime ?? this.plannedDateTime,
      consumedDateTime: consumedDateTime ?? this.consumedDateTime,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      foods: foods ?? List.from(this.foods),
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
    );
    copy.id = id;
    copy.createdAt = this.createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  /// Retourne le nom d'affichage (titre ou type de repas)
  String get displayName => title ?? typeName;
}
