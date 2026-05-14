import 'package:isar/isar.dart';

part 'discovered_food_card.g.dart';

/// Un plat decouvert dans la galerie (systeme de recompense type collection)
@collection
class DiscoveredFoodCard {
  Id id = Isar.autoIncrement;

  /// Identifiant unique du plat (correspond au fichier, ex: "1", "42")
  @Index(unique: true)
  String foodCardId;

  /// Date a laquelle la carte a ete decouverte
  DateTime discoveredAt;

  /// Date du DailyReport qui a declenche la decouverte
  @Index()
  DateTime reportDate;

  DiscoveredFoodCard({
    required this.foodCardId,
    required this.discoveredAt,
    required this.reportDate,
  });

  /// Retourne le chemin de l'asset de la carte
  String get assetPath => 'assets/food_cards_optimized/$foodCardId.webp';
}

/// Enregistrement d'un tirage de plat pour une date donnee
/// (empeche les tirages multiples pour la meme date)
@collection
class FoodCardDrawRecord {
  Id id = Isar.autoIncrement;

  /// Date du rapport (normalisee a minuit) - une seule entree par date
  @Index(unique: true)
  DateTime reportDate;

  /// ID de la carte tiree ce jour-la
  String drawnFoodCardId;

  /// Si la carte etait deja decouverte (doublon)
  bool wasDuplicate;

  /// Date/heure du tirage
  DateTime drawnAt;

  FoodCardDrawRecord({
    required this.reportDate,
    required this.drawnFoodCardId,
    required this.wasDuplicate,
    required this.drawnAt,
  });
}
