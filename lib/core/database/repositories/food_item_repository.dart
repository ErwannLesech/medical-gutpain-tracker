import 'package:isar/isar.dart';

import '../../models/food_item.dart';
import '../database_service.dart';

/// Repository pour la gestion des aliments enregistrés
class FoodItemRepository {
  final DatabaseService _db;

  FoodItemRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE / UPDATE ====================

  /// Crée ou met à jour un aliment
  Future<int> save(FoodItem item) async {
    return await _isar.writeTxn(() async {
      return await _isar.foodItems.put(item);
    });
  }

  /// Enregistre un aliment consommé (crée ou incrémente)
  Future<FoodItem> recordConsumption(String name, {FoodCategory? category}) async {
    final normalizedName = name.trim().toLowerCase();
    var item = await getByName(normalizedName);
    
    item ??= FoodItem(
        name: normalizedName,
        category: category ?? FoodCategory.other,
      );
    
    item.incrementConsumption();
    await save(item);
    return item;
  }

  /// Associe un aliment à une douleur
  Future<void> recordPainAssociation(String name) async {
    final normalizedName = name.trim().toLowerCase();
    final item = await getByName(normalizedName);
    
    if (item != null) {
      item.incrementPainAssociation();
      await save(item);
    }
  }

  // ==================== READ ====================

  /// Récupère un aliment par son ID
  Future<FoodItem?> getById(int id) async {
    return await _isar.foodItems.get(id);
  }

  /// Récupère un aliment par son nom
  Future<FoodItem?> getByName(String name) async {
    final normalizedName = name.trim().toLowerCase();
    return await _isar.foodItems
        .where()
        .filter()
        .nameEqualTo(normalizedName, caseSensitive: false)
        .findFirst();
  }

  /// Récupère tous les aliments
  Future<List<FoodItem>> getAll() async {
    return await _isar.foodItems.where().findAll();
  }

  /// Recherche d'aliments par nom (autocomplete)
  Future<List<FoodItem>> search(String query, {int limit = 10}) async {
    if (query.isEmpty) return [];
    
    return await _isar.foodItems
        .where()
        .filter()
        .nameContains(query, caseSensitive: false)
        .sortByConsumptionCountDesc()
        .limit(limit)
        .findAll();
  }

  /// Récupère les aliments par catégorie
  Future<List<FoodItem>> getByCategory(FoodCategory category) async {
    return await _isar.foodItems
        .where()
        .filter()
        .categoryEqualTo(category)
        .sortByConsumptionCountDesc()
        .findAll();
  }

  /// Récupère les aliments les plus consommés
  Future<List<FoodItem>> getMostConsumed({int limit = 20}) async {
    return await _isar.foodItems
        .where()
        .sortByConsumptionCountDesc()
        .limit(limit)
        .findAll();
  }

  /// Récupère les aliments marqués comme problématiques
  Future<List<FoodItem>> getProblematic() async {
    return await _isar.foodItems
        .where()
        .filter()
        .isMarkedProblematicEqualTo(true)
        .sortByPainAssociationCountDesc()
        .findAll();
  }

  /// Récupère les aliments à risque (basé sur le ratio douleur/consommation)
  Future<List<FoodItem>> getRiskyFoods({double minRisk = 0.3, int minConsumptions = 3}) async {
    final items = await _isar.foodItems
        .where()
        .filter()
        .consumptionCountGreaterThan(minConsumptions - 1)
        .findAll();
    
    final risky = items.where((item) => item.riskScore >= minRisk).toList();
    risky.sort((a, b) => b.riskScore.compareTo(a.riskScore));
    return risky;
  }

  /// Récupère les aliments récemment consommés
  Future<List<FoodItem>> getRecentlyConsumed({int limit = 10}) async {
    return await _isar.foodItems
        .where()
        .filter()
        .lastConsumedIsNotNull()
        .sortByLastConsumedDesc()
        .limit(limit)
        .findAll();
  }

  // ==================== DELETE ====================

  /// Supprime un aliment par son ID
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.foodItems.delete(id);
    });
  }

  /// Supprime tous les aliments
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.foodItems.clear();
    });
  }

  // ==================== WATCH ====================

  /// Stream de tous les aliments
  Stream<List<FoodItem>> watchAll() {
    return _isar.foodItems
        .where()
        .sortByConsumptionCountDesc()
        .watch(fireImmediately: true);
  }

  /// Stream des aliments problématiques
  Stream<List<FoodItem>> watchProblematic() {
    return _isar.foodItems
        .where()
        .filter()
        .isMarkedProblematicEqualTo(true)
        .watch(fireImmediately: true);
  }

  // ==================== STATS ====================

  /// Compte le nombre total d'aliments
  Future<int> count() async {
    return await _isar.foodItems.count();
  }

  /// Récupère les catégories les plus consommées
  Future<Map<FoodCategory, int>> getCategoryDistribution() async {
    final items = await _isar.foodItems.where().findAll();
    final distribution = <FoodCategory, int>{};
    
    for (final item in items) {
      distribution[item.category] = 
          (distribution[item.category] ?? 0) + item.consumptionCount;
    }
    
    final sortedEntries = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedEntries);
  }
}
