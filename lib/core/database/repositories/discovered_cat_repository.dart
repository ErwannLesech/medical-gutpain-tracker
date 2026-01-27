import 'package:isar/isar.dart';

import '../../models/discovered_cat.dart';
import '../database_service.dart';

/// Repository pour la gestion des chats découverts
class DiscoveredCatRepository {
  final DatabaseService _db;

  DiscoveredCatRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE ====================

  /// Ajoute un chat découvert (si pas déjà présent)
  Future<DiscoveredCat?> addDiscoveredCat({
    required String catId,
    required DateTime reportDate,
  }) async {
    // Vérifie si le chat est déjà découvert
    final existing = await getByCatId(catId);
    if (existing != null) {
      return null; // Déjà découvert
    }

    final cat = DiscoveredCat(
      catId: catId,
      discoveredAt: DateTime.now(),
      reportDate: _normalizeDate(reportDate),
    );

    await _isar.writeTxn(() async {
      await _isar.discoveredCats.put(cat);
    });

    return cat;
  }

  /// Enregistre un tirage de chat pour une date donnée
  Future<CatDrawRecord?> recordDraw({
    required DateTime reportDate,
    required String catId,
    required bool wasDuplicate,
  }) async {
    final normalizedDate = _normalizeDate(reportDate);
    
    // Vérifie s'il y a déjà un tirage pour cette date
    final existing = await getDrawByDate(normalizedDate);
    if (existing != null) {
      return null; // Tirage déjà effectué
    }

    final record = CatDrawRecord(
      reportDate: normalizedDate,
      drawnCatId: catId,
      wasDuplicate: wasDuplicate,
      drawnAt: DateTime.now(),
    );

    await _isar.writeTxn(() async {
      await _isar.catDrawRecords.put(record);
    });

    return record;
  }

  // ==================== READ ====================

  /// Récupère un chat découvert par son catId
  Future<DiscoveredCat?> getByCatId(String catId) async {
    return await _isar.discoveredCats
        .where()
        .filter()
        .catIdEqualTo(catId)
        .findFirst();
  }

  /// Récupère tous les chats découverts
  Future<List<DiscoveredCat>> getAllDiscovered() async {
    return await _isar.discoveredCats
        .where()
        .sortByDiscoveredAtDesc()
        .findAll();
  }

  /// Récupère le nombre de chats découverts
  Future<int> getDiscoveredCount() async {
    return await _isar.discoveredCats.count();
  }

  /// Récupère tous les IDs des chats découverts
  Future<Set<String>> getDiscoveredCatIds() async {
    final cats = await _isar.discoveredCats.where().findAll();
    return cats.map((c) => c.catId).toSet();
  }

  /// Récupère le tirage pour une date donnée
  Future<CatDrawRecord?> getDrawByDate(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await _isar.catDrawRecords
        .where()
        .filter()
        .reportDateEqualTo(normalizedDate)
        .findFirst();
  }

  /// Vérifie si un tirage a déjà été effectué pour une date
  Future<bool> hasDrawnForDate(DateTime date) async {
    final record = await getDrawByDate(date);
    return record != null;
  }

  /// Récupère tous les tirages
  Future<List<CatDrawRecord>> getAllDraws() async {
    return await _isar.catDrawRecords
        .where()
        .sortByDrawnAtDesc()
        .findAll();
  }

  // ==================== WATCH ====================

  /// Stream des chats découverts
  Stream<List<DiscoveredCat>> watchAllDiscovered() {
    return _isar.discoveredCats
        .where()
        .sortByDiscoveredAtDesc()
        .watch(fireImmediately: true);
  }

  /// Stream du nombre de chats découverts
  Stream<int> watchDiscoveredCount() {
    return _isar.discoveredCats
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getDiscoveredCount());
  }

  // ==================== DELETE ====================

  /// Supprime toutes les données (reset)
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.discoveredCats.clear();
      await _isar.catDrawRecords.clear();
    });
  }

  // ==================== UTILS ====================

  /// Normalise une date à minuit
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
