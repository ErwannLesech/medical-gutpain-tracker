import 'package:isar/isar.dart';

import '../../models/discovered_food_card.dart';
import '../database_service.dart';

/// Repository pour la gestion des cartes de plats decouvertes
class DiscoveredFoodCardRepository {
  final DatabaseService _db;

  DiscoveredFoodCardRepository({DatabaseService? db})
      : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE ====================

  /// Ajoute une carte decouverte (si pas deja presente)
  Future<DiscoveredFoodCard?> addDiscoveredCard({
    required String foodCardId,
    required DateTime reportDate,
  }) async {
    final existing = await getByFoodCardId(foodCardId);
    if (existing != null) {
      return null;
    }

    final card = DiscoveredFoodCard(
      foodCardId: foodCardId,
      discoveredAt: DateTime.now(),
      reportDate: _normalizeDate(reportDate),
    );

    await _isar.writeTxn(() async {
      await _isar.discoveredFoodCards.put(card);
    });

    return card;
  }

  /// Enregistre un tirage de carte pour une date donnee
  Future<FoodCardDrawRecord?> recordDraw({
    required DateTime reportDate,
    required String foodCardId,
    required bool wasDuplicate,
  }) async {
    final normalizedDate = _normalizeDate(reportDate);

    final existing = await getDrawByDate(normalizedDate);
    if (existing != null) {
      return null;
    }

    final record = FoodCardDrawRecord(
      reportDate: normalizedDate,
      drawnFoodCardId: foodCardId,
      wasDuplicate: wasDuplicate,
      drawnAt: DateTime.now(),
    );

    await _isar.writeTxn(() async {
      await _isar.foodCardDrawRecords.put(record);
    });

    return record;
  }

  // ==================== READ ====================

  /// Recupere une carte decouverte par son ID
  Future<DiscoveredFoodCard?> getByFoodCardId(String foodCardId) async {
    return await _isar.discoveredFoodCards
        .where()
        .filter()
        .foodCardIdEqualTo(foodCardId)
        .findFirst();
  }

  /// Recupere toutes les cartes decouvertes
  Future<List<DiscoveredFoodCard>> getAllDiscovered() async {
    return await _isar.discoveredFoodCards
        .where()
        .sortByDiscoveredAtDesc()
        .findAll();
  }

  /// Recupere le nombre de cartes decouvertes
  Future<int> getDiscoveredCount() async {
    return await _isar.discoveredFoodCards.count();
  }

  /// Recupere tous les IDs des cartes decouvertes
  Future<Set<String>> getDiscoveredFoodCardIds() async {
    final cards = await _isar.discoveredFoodCards.where().findAll();
    return cards.map((c) => c.foodCardId).toSet();
  }

  /// Recupere le tirage pour une date donnee
  Future<FoodCardDrawRecord?> getDrawByDate(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await _isar.foodCardDrawRecords
        .where()
        .filter()
        .reportDateEqualTo(normalizedDate)
        .findFirst();
  }

  /// Verifie si un tirage a deja ete effectue pour une date
  Future<bool> hasDrawnForDate(DateTime date) async {
    final record = await getDrawByDate(date);
    return record != null;
  }

  /// Recupere tous les tirages
  Future<List<FoodCardDrawRecord>> getAllDraws() async {
    return await _isar.foodCardDrawRecords
        .where()
        .sortByDrawnAtDesc()
        .findAll();
  }

  // ==================== WATCH ====================

  /// Stream des cartes decouvertes
  Stream<List<DiscoveredFoodCard>> watchAllDiscovered() {
    return _isar.discoveredFoodCards
        .where()
        .sortByDiscoveredAtDesc()
        .watch(fireImmediately: true);
  }

  /// Stream du nombre de cartes decouvertes
  Stream<int> watchDiscoveredCount() {
    return _isar.discoveredFoodCards
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getDiscoveredCount());
  }

  // ==================== DELETE ====================

  /// Supprime toutes les donnees (reset)
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.discoveredFoodCards.clear();
      await _isar.foodCardDrawRecords.clear();
    });
  }

  // ==================== UTILS ====================

  /// Normalise une date a minuit
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
