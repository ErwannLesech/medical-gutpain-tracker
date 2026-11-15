import 'package:isar/isar.dart';

part 'scene_piece.g.dart';

/// Origine d'une pièce de scène
enum ScenePieceSource {
  starter, // offerte à l'ouverture de la scène
  journal, // tirée en remplissant le journal
  shop, // achetée en Catcoins
  reward, // récompense de fin de scène (animal)
}

/// Pièce de puzzle possédée (scènes 3D Kenney).
///
/// Une pièce est un exemplaire d'un modèle (ex: "tree") pour une scène.
/// Tant que [slotId] est null, elle attend dans le tiroir ; une fois posée,
/// [slotId] indique l'emplacement occupé. Les animaux de fin de scène sont
/// stockés avec `modelId = "pet:<id>"` et `slotId = "pet"`.
@collection
class ScenePiece {
  Id id = Isar.autoIncrement;

  @Index()
  String sceneId;

  String modelId;

  /// Emplacement occupé (null = dans le tiroir)
  String? slotId;

  @Enumerated(EnumType.ordinal)
  ScenePieceSource source;

  /// Clé d'idempotence unique (ex: "journal:2026-11-15", "starter:forest:0")
  @Index(unique: true)
  String refKey;

  DateTime acquiredAt;

  ScenePiece({
    required this.sceneId,
    required this.modelId,
    this.slotId,
    required this.source,
    required this.refKey,
    required this.acquiredAt,
  });

  bool get isPlaced => slotId != null;
}
