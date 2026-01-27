import 'package:isar/isar.dart';

part 'discovered_cat.g.dart';

/// Un chat découvert dans la galerie (système de récompense type Pokédex)
@collection
class DiscoveredCat {
  Id id = Isar.autoIncrement;

  /// Identifiant unique du chat (correspond au fichier, ex: "1", "42")
  @Index(unique: true)
  String catId;

  /// Date à laquelle le chat a été découvert
  DateTime discoveredAt;

  /// Date du DailyReport qui a déclenché la découverte
  @Index()
  DateTime reportDate;

  DiscoveredCat({
    required this.catId,
    required this.discoveredAt,
    required this.reportDate,
  });

  /// Retourne le chemin de l'asset du chat
  String get assetPath => 'assets/cats_optimized/$catId.webp';
}

/// Enregistrement d'un tirage de chat pour une date donnée
/// (empêche les tirages multiples pour la même date)
@collection
class CatDrawRecord {
  Id id = Isar.autoIncrement;

  /// Date du rapport (normalisée à minuit) - une seule entrée par date
  @Index(unique: true)
  DateTime reportDate;

  /// ID du chat tiré ce jour-là
  String drawnCatId;

  /// Si le chat était déjà découvert (doublon)
  bool wasDuplicate;

  /// Date/heure du tirage
  DateTime drawnAt;

  CatDrawRecord({
    required this.reportDate,
    required this.drawnCatId,
    required this.wasDuplicate,
    required this.drawnAt,
  });
}
