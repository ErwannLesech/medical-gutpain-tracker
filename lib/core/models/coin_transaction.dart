import 'package:isar/isar.dart';

part 'coin_transaction.g.dart';

/// Origine d'un mouvement de Catcoins
enum CoinReason {
  // L'ordre est stocké en base : ne pas réordonner ni supprimer de valeur.
  dailyJournal, // (plus utilisé) journal du jour rempli
  duplicateCard, // Doublon du journal (chat, plat, pièce de scène)
  memoryGame, // (plus utilisé) partie de memory
  monthlyRecap, // Bilan mensuel vu (montant 0, sert de trace)
  purchase, // Achat (montant négatif) : pièce de scène, indice
}

/// Mouvement de Catcoins (registre : le solde est la somme des montants)
///
/// Chaque mouvement porte une [refKey] unique qui garantit qu'une même
/// récompense ne peut pas être versée deux fois (ex: "daily:2026-11-14").
@collection
class CoinTransaction {
  Id id = Isar.autoIncrement;

  /// Montant (positif = gain, négatif = dépense)
  int amount;

  /// Origine du mouvement
  @Enumerated(EnumType.ordinal)
  CoinReason reason;

  /// Clé d'idempotence unique
  @Index(unique: true)
  String refKey;

  /// Date du mouvement
  @Index()
  DateTime createdAt;

  CoinTransaction({
    required this.amount,
    required this.reason,
    required this.refKey,
    required this.createdAt,
  });
}
