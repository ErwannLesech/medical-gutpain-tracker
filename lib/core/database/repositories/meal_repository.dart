import 'package:isar/isar.dart';

import '../../models/meal.dart';
import '../database_service.dart';

/// Repository pour la gestion des repas
/// Toutes les opérations CRUD passent par cette classe
class MealRepository {
  final DatabaseService _db;

  MealRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE ====================

  /// Crée un nouveau repas
  Future<int> create(Meal meal) async {
    // Tous les repas planifiés sont considérés comme consommés
    meal.consumedDateTime = meal.plannedDateTime;
    
    return await _isar.writeTxn(() async {
      return await _isar.meals.put(meal);
    });
  }

  /// Crée plusieurs repas en une seule transaction
  Future<List<int>> createMany(List<Meal> meals) async {
    return await _isar.writeTxn(() async {
      return await _isar.meals.putAll(meals);
    });
  }

  // ==================== READ ====================

  /// Récupère un repas par son ID
  Future<Meal?> getById(int id) async {
    return await _isar.meals.get(id);
  }

  /// Récupère tous les repas
  Future<List<Meal>> getAll() async {
    return await _isar.meals.where().findAll();
  }

  /// Récupère les repas d'une journée spécifique
  Future<List<Meal>> getByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await _isar.meals
        .where()
        .filter()
        .plannedDateTimeBetween(startOfDay, endOfDay)
        .sortByPlannedDateTime()
        .findAll();
  }

  /// Récupère les repas d'une période
  Future<List<Meal>> getByDateRange(DateTime start, DateTime end) async {
    return await _isar.meals
        .where()
        .filter()
        .plannedDateTimeBetween(start, end)
        .sortByPlannedDateTime()
        .findAll();
  }

  /// Récupère les repas consommés d'une journée
  Future<List<Meal>> getConsumedByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await _isar.meals
        .where()
        .filter()
        .consumedDateTimeIsNotNull()
        .consumedDateTimeBetween(startOfDay, endOfDay)
        .sortByConsumedDateTime()
        .findAll();
  }

  /// Récupère le dernier repas consommé avant une date/heure donnée
  /// Utilisé pour lier automatiquement une douleur au repas précédent
  Future<Meal?> getLastConsumedBefore(DateTime dateTime, {int maxHours = 6}) async {
    final minDateTime = dateTime.subtract(Duration(hours: maxHours));

    final meals = await _isar.meals
        .where()
        .filter()
        .consumedDateTimeIsNotNull()
        .consumedDateTimeBetween(minDateTime, dateTime)
        .sortByConsumedDateTimeDesc()
        .limit(1)
        .findAll();

    return meals.isNotEmpty ? meals.first : null;
  }

  /// Récupère les repas contenant un aliment spécifique
  Future<List<Meal>> getByFood(String food) async {
    final lowerFood = food.toLowerCase();
    return await _isar.meals
        .where()
        .filter()
        .foodsElementContains(lowerFood, caseSensitive: false)
        .sortByPlannedDateTimeDesc()
        .findAll();
  }

  /// Récupère les repas par type
  Future<List<Meal>> getByType(MealType type) async {
    return await _isar.meals
        .where()
        .filter()
        .typeEqualTo(type)
        .sortByPlannedDateTimeDesc()
        .findAll();
  }

  /// Récupère les N derniers repas
  Future<List<Meal>> getRecent({int limit = 10}) async {
    return await _isar.meals
        .where()
        .sortByPlannedDateTimeDesc()
        .limit(limit)
        .findAll();
  }

  // ==================== UPDATE ====================

  /// Met à jour un repas existant
  Future<int> update(Meal meal) async {
    meal.updatedAt = DateTime.now();
    // Tous les repas ont leur consumedDateTime = plannedDateTime
    meal.consumedDateTime = meal.plannedDateTime;
    return await _isar.writeTxn(() async {
      return await _isar.meals.put(meal);
    });
  }

  // ==================== DELETE ====================

  /// Supprime un repas par son ID
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.meals.delete(id);
    });
  }

  /// Supprime plusieurs repas
  Future<int> deleteMany(List<int> ids) async {
    return await _isar.writeTxn(() async {
      return await _isar.meals.deleteAll(ids);
    });
  }

  /// Supprime tous les repas
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.meals.clear();
    });
  }

  // ==================== WATCH ====================

  /// Stream de tous les repas (pour observer les changements)
  Stream<List<Meal>> watchAll() {
    return _isar.meals.where().watch(fireImmediately: true);
  }

  /// Stream des repas d'une journée
  Stream<List<Meal>> watchByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _isar.meals
        .where()
        .filter()
        .plannedDateTimeBetween(startOfDay, endOfDay)
        .sortByPlannedDateTime()
        .watch(fireImmediately: true);
  }

  // ==================== STATS ====================

  /// Compte le nombre total de repas
  Future<int> count() async {
    return await _isar.meals.count();
  }

  /// Récupère tous les aliments uniques consommés
  Future<List<String>> getAllUniquefoods() async {
    final meals = await _isar.meals.where().findAll();
    final allfoods = meals.expand((m) => m.foods).toSet().toList();
    allfoods.sort();
    return allfoods;
  }

  /// Récupère les aliments les plus fréquents
  Future<Map<String, int>> getMostFrequentfoods({int limit = 20}) async {
    final meals = await _isar.meals.where().findAll();
    final foodCount = <String, int>{};

    for (final meal in meals) {
      for (final food in meal.foods) {
        final lowerFood = food.toLowerCase();
        foodCount[lowerFood] = (foodCount[lowerFood] ?? 0) + 1;
      }
    }

    final sortedEntries = foodCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries.take(limit));
  }

  /// Récupère tous les aliments des repas à venir (du jour actuel au futur)
  Future<List<String>> getFutureFoods({DateTime? fromDate}) async {
    final startDate = fromDate ?? DateTime.now();
    final startOfDay = DateTime(startDate.year, startDate.month, startDate.day);

    final meals = await _isar.meals
        .where()
        .filter()
        .plannedDateTimeGreaterThan(startOfDay)
        .sortByPlannedDateTime()
        .findAll();

    // Collecte tous les aliments uniques
    final allFoods = <String>{};
    for (final meal in meals) {
      allFoods.addAll(meal.foods);
    }

    final foodList = allFoods.toList()..sort();
    return foodList;
  }
}
