import 'package:isar/isar.dart';

part 'food_item.g.dart';

/// Catégorie d'aliment
enum FoodCategory {
  dairy,        // Produits laitiers
  gluten,       // Contient du gluten
  meat,         // Viande
  fish,         // Poisson
  vegetable,    // Légumes
  fruit,        // Fruits
  grain,        // Céréales
  legume,       // Légumineuses
  fat,          // Matières grasses
  sweet,        // Sucreries
  beverage,     // Boissons
  spicy,        // Épicé
  processed,    // Transformé
  fermented,    // Fermenté
  other,        // Autre
}

/// Aliment enregistré pour suggestions et statistiques
@collection
class FoodItem {
  Id id = Isar.autoIncrement;

  /// Nom de l'aliment
  @Index()
  String name;

  /// Catégorie de l'aliment
  @Enumerated(EnumType.ordinal)
  FoodCategory category;

  /// Nombre de fois consommé (pour le tri par fréquence)
  int consumptionCount;

  /// Nombre de fois associé à une douleur
  int painAssociationCount;

  /// Est-ce un aliment marqué comme problématique par l'utilisateur ?
  bool isMarkedProblematic;

  /// Notes sur cet aliment
  String? notes;

  /// Date de dernière consommation
  DateTime? lastConsumed;

  /// Date de création
  DateTime createdAt;

  FoodItem({
    required this.name,
    this.category = FoodCategory.other,
    this.consumptionCount = 0,
    this.painAssociationCount = 0,
    this.isMarkedProblematic = false,
    this.notes,
    this.lastConsumed,
  }) : createdAt = DateTime.now();

  /// Calcule un score de risque basé sur l'association aux douleurs
  double get riskScore {
    if (consumptionCount == 0) return 0;
    return painAssociationCount / consumptionCount;
  }

  /// Retourne le nom lisible de la catégorie
  String get categoryName {
    switch (category) {
      case FoodCategory.dairy:
        return 'Produits laitiers';
      case FoodCategory.gluten:
        return 'Gluten';
      case FoodCategory.meat:
        return 'Viande';
      case FoodCategory.fish:
        return 'Poisson';
      case FoodCategory.vegetable:
        return 'Légumes';
      case FoodCategory.fruit:
        return 'Fruits';
      case FoodCategory.grain:
        return 'Céréales';
      case FoodCategory.legume:
        return 'Légumineuses';
      case FoodCategory.fat:
        return 'Matières grasses';
      case FoodCategory.sweet:
        return 'Sucreries';
      case FoodCategory.beverage:
        return 'Boissons';
      case FoodCategory.spicy:
        return 'Épicé';
      case FoodCategory.processed:
        return 'Transformé';
      case FoodCategory.fermented:
        return 'Fermenté';
      case FoodCategory.other:
        return 'Autre';
    }
  }

  /// Retourne l'emoji de la catégorie
  String get categoryEmoji {
    switch (category) {
      case FoodCategory.dairy:
        return '🥛';
      case FoodCategory.gluten:
        return '🍞';
      case FoodCategory.meat:
        return '🥩';
      case FoodCategory.fish:
        return '🐟';
      case FoodCategory.vegetable:
        return '🥬';
      case FoodCategory.fruit:
        return '🍎';
      case FoodCategory.grain:
        return '🌾';
      case FoodCategory.legume:
        return '🫘';
      case FoodCategory.fat:
        return '🧈';
      case FoodCategory.sweet:
        return '🍬';
      case FoodCategory.beverage:
        return '🥤';
      case FoodCategory.spicy:
        return '🌶️';
      case FoodCategory.processed:
        return '🍟';
      case FoodCategory.fermented:
        return '🥒';
      case FoodCategory.other:
        return '🍽️';
    }
  }

  /// Incrémente le compteur de consommation
  void incrementConsumption() {
    consumptionCount++;
    lastConsumed = DateTime.now();
  }

  /// Incrémente le compteur d'association aux douleurs
  void incrementPainAssociation() {
    painAssociationCount++;
  }

  /// Copie l'aliment avec des modifications
  FoodItem copyWith({
    String? name,
    FoodCategory? category,
    int? consumptionCount,
    int? painAssociationCount,
    bool? isMarkedProblematic,
    String? notes,
    DateTime? lastConsumed,
  }) {
    final copy = FoodItem(
      name: name ?? this.name,
      category: category ?? this.category,
      consumptionCount: consumptionCount ?? this.consumptionCount,
      painAssociationCount: painAssociationCount ?? this.painAssociationCount,
      isMarkedProblematic: isMarkedProblematic ?? this.isMarkedProblematic,
      notes: notes ?? this.notes,
      lastConsumed: lastConsumed ?? this.lastConsumed,
    );
    copy.id = id;
    copy.createdAt = createdAt;
    return copy;
  }
}
