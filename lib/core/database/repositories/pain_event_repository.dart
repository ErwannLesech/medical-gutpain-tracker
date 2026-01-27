import 'package:isar/isar.dart';

import '../../models/pain_event.dart';
import '../../models/meal.dart';
import '../database_service.dart';

/// Repository pour la gestion des événements de douleur
class PainEventRepository {
  final DatabaseService _db;

  PainEventRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE ====================

  /// Crée un nouvel événement de douleur
  /// Lie automatiquement au dernier repas consommé
  Future<int> create(PainEvent event, {int maxMealLinkHours = 6}) async {
    // Recherche le dernier repas consommé avant la douleur
    if (event.linkedMealId == null) {
      final lastMeal = await _getLastConsumedMealBefore(
        event.dateTime, 
        maxHours: maxMealLinkHours,
      );
      
      if (lastMeal != null) {
        event.linkedMealId = lastMeal.id;
        event.delayFromMealMinutes = event.dateTime
            .difference(lastMeal.consumedDateTime!)
            .inMinutes;
        
        // Met à jour l'état digestif automatiquement
        if (event.delayFromMealMinutes! <= 120) {
          event.digestiveState = DigestiveState.postMeal;
        }
      } else {
        event.digestiveState = DigestiveState.hungry;
      }
    }

    return await _isar.writeTxn(() async {
      return await _isar.painEvents.put(event);
    });
  }

  /// Récupère le dernier repas consommé avant une date
  Future<Meal?> _getLastConsumedMealBefore(DateTime dateTime, {int maxHours = 6}) async {
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

  // ==================== READ ====================

  /// Récupère un événement par son ID
  Future<PainEvent?> getById(int id) async {
    return await _isar.painEvents.get(id);
  }

  /// Récupère tous les événements
  Future<List<PainEvent>> getAll() async {
    return await _isar.painEvents.where().findAll();
  }

  /// Récupère les événements d'une journée
  Future<List<PainEvent>> getByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await _isar.painEvents
        .where()
        .filter()
        .dateTimeBetween(startOfDay, endOfDay)
        .sortByDateTime()
        .findAll();
  }

  /// Récupère les événements d'une période
  Future<List<PainEvent>> getByDateRange(DateTime start, DateTime end) async {
    return await _isar.painEvents
        .where()
        .filter()
        .dateTimeBetween(start, end)
        .sortByDateTime()
        .findAll();
  }

  /// Récupère les événements liés à un repas spécifique
  Future<List<PainEvent>> getByMealId(int mealId) async {
    return await _isar.painEvents
        .where()
        .filter()
        .linkedMealIdEqualTo(mealId)
        .sortByDateTime()
        .findAll();
  }

  /// Récupère les événements par intensité
  Future<List<PainEvent>> getByIntensity(int intensity) async {
    return await _isar.painEvents
        .where()
        .filter()
        .intensityEqualTo(intensity)
        .sortByDateTimeDesc()
        .findAll();
  }

  /// Récupère les N derniers événements
  Future<List<PainEvent>> getRecent({int limit = 10}) async {
    return await _isar.painEvents
        .where()
        .sortByDateTimeDesc()
        .limit(limit)
        .findAll();
  }

  /// Récupère les événements inhabituels
  Future<List<PainEvent>> getUnusual() async {
    return await _isar.painEvents
        .where()
        .filter()
        .isUsualEqualTo(false)
        .sortByDateTimeDesc()
        .findAll();
  }

  // ==================== UPDATE ====================

  /// Met à jour un événement
  Future<int> update(PainEvent event) async {
    event.updatedAt = DateTime.now();
    return await _isar.writeTxn(() async {
      return await _isar.painEvents.put(event);
    });
  }

  // ==================== DELETE ====================

  /// Supprime un événement par son ID
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.painEvents.delete(id);
    });
  }

  /// Supprime tous les événements
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.painEvents.clear();
    });
  }

  // ==================== WATCH ====================

  /// Stream de tous les événements
  Stream<List<PainEvent>> watchAll() {
    return _isar.painEvents.where().watch(fireImmediately: true);
  }

  /// Stream des événements d'une journée
  Stream<List<PainEvent>> watchByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _isar.painEvents
        .where()
        .filter()
        .dateTimeBetween(startOfDay, endOfDay)
        .sortByDateTime()
        .watch(fireImmediately: true);
  }

  // ==================== STATS ====================

  /// Compte le nombre total d'événements
  Future<int> count() async {
    return await _isar.painEvents.count();
  }

  /// Calcule l'intensité moyenne des douleurs
  Future<double> getAverageIntensity() async {
    final events = await _isar.painEvents.where().findAll();
    if (events.isEmpty) return 0;
    
    final sum = events.fold<int>(0, (sum, e) => sum + e.intensity);
    return sum / events.length;
  }

  /// Calcule l'intensité moyenne par période
  Future<double> getAverageIntensityByDateRange(DateTime start, DateTime end) async {
    final events = await getByDateRange(start, end);
    if (events.isEmpty) return 0;
    
    final sum = events.fold<int>(0, (sum, e) => sum + e.intensity);
    return sum / events.length;
  }

  /// Récupère la distribution des intensités
  Future<Map<int, int>> getIntensityDistribution() async {
    final events = await _isar.painEvents.where().findAll();
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    
    for (final event in events) {
      distribution[event.intensity] = (distribution[event.intensity] ?? 0) + 1;
    }
    
    return distribution;
  }

  /// Récupère le nombre d'événements par heure de la journée
  Future<Map<int, int>> getCountByHour() async {
    final events = await _isar.painEvents.where().findAll();
    final countByHour = <int, int>{};
    
    for (int i = 0; i < 24; i++) {
      countByHour[i] = 0;
    }
    
    for (final event in events) {
      final hour = event.dateTime.hour;
      countByHour[hour] = (countByHour[hour] ?? 0) + 1;
    }
    
    return countByHour;
  }

  /// Récupère les symptômes les plus fréquents
  Future<Map<Symptom, int>> getMostFrequentSymptoms() async {
    final events = await _isar.painEvents.where().findAll();
    final symptomCount = <Symptom, int>{};
    
    for (final event in events) {
      for (final symptom in event.symptoms) {
        symptomCount[symptom] = (symptomCount[symptom] ?? 0) + 1;
      }
    }
    
    final sortedEntries = symptomCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedEntries);
  }

  /// Récupère le délai moyen entre repas et douleur
  Future<double?> getAverageDelayFromMeal() async {
    final events = await _isar.painEvents
        .where()
        .filter()
        .delayFromMealMinutesIsNotNull()
        .findAll();
    
    if (events.isEmpty) return null;
    
    final sum = events.fold<int>(0, (sum, e) => sum + (e.delayFromMealMinutes ?? 0));
    return sum / events.length;
  }
}
