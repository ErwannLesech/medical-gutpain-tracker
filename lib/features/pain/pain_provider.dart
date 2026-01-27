import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/database/repositories/repositories.dart';
import '../../core/services/providers.dart';

/// État des événements de douleur
class PainEventsState {
  final List<PainEvent> events;
  final bool isLoading;
  final String? error;
  final DateTime selectedDate;

  const PainEventsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
    required this.selectedDate,
  });

  PainEventsState copyWith({
    List<PainEvent>? events,
    bool? isLoading,
    String? error,
    DateTime? selectedDate,
  }) {
    return PainEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

/// Notifier pour la gestion des événements de douleur
class PainEventsNotifier extends StateNotifier<PainEventsState> {
  final PainEventRepository _repository;
  final MealRepository _mealRepository;
  final FoodItemRepository _foodRepository;
  final int _maxMealLinkHours;

  PainEventsNotifier(
    this._repository,
    this._mealRepository,
    this._foodRepository, {
    int maxMealLinkHours = 6,
  })  : _maxMealLinkHours = maxMealLinkHours,
        super(PainEventsState(selectedDate: DateTime.now())) {
    loadEvents();
  }

  /// Charge les événements de la date sélectionnée
  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final events = await _repository.getByDate(state.selectedDate);
      state = state.copyWith(events: events, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Change la date sélectionnée
  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date);
    await loadEvents();
  }

  /// Crée un nouvel événement de douleur
  /// Lie automatiquement au dernier repas consommé
  Future<PainEvent?> createEvent(PainEvent event) async {
    try {
      final id = await _repository.create(event, maxMealLinkHours: _maxMealLinkHours);
      
      // Si un repas est lié, on met à jour les statistiques des aliments
      if (event.linkedMealId != null) {
        final meal = await _mealRepository.getById(event.linkedMealId!);
        if (meal != null) {
          for (final food in meal.foods) {
            await _foodRepository.recordPainAssociation(food);
          }
        }
      }
      
      await loadEvents();
      return event..id = id;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Met à jour un événement
  Future<bool> updateEvent(PainEvent event) async {
    try {
      await _repository.update(event);
      await loadEvents();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Supprime un événement
  Future<bool> deleteEvent(int id) async {
    try {
      await _repository.delete(id);
      await loadEvents();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Récupère les statistiques de douleur
  Future<PainStats> getStats() async {
    final allEvents = await _repository.getAll();
    final avgIntensity = await _repository.getAverageIntensity();
    final intensityDist = await _repository.getIntensityDistribution();
    final countByHour = await _repository.getCountByHour();
    final symptoms = await _repository.getMostFrequentSymptoms();
    final avgDelay = await _repository.getAverageDelayFromMeal();

    return PainStats(
      totalEvents: allEvents.length,
      averageIntensity: avgIntensity,
      intensityDistribution: intensityDist,
      countByHour: countByHour,
      mostFrequentSymptoms: symptoms,
      averageDelayFromMeal: avgDelay,
    );
  }
}

/// Statistiques de douleur
class PainStats {
  final int totalEvents;
  final double averageIntensity;
  final Map<int, int> intensityDistribution;
  final Map<int, int> countByHour;
  final Map<Symptom, int> mostFrequentSymptoms;
  final double? averageDelayFromMeal;

  PainStats({
    required this.totalEvents,
    required this.averageIntensity,
    required this.intensityDistribution,
    required this.countByHour,
    required this.mostFrequentSymptoms,
    this.averageDelayFromMeal,
  });
}

/// Provider des événements de douleur
final painEventsProvider = StateNotifierProvider<PainEventsNotifier, PainEventsState>((ref) {
  return PainEventsNotifier(
    ref.watch(painEventRepositoryProvider),
    ref.watch(mealRepositoryProvider),
    ref.watch(foodItemRepositoryProvider),
  );
});

/// Provider des événements récents
final recentPainEventsProvider = FutureProvider<List<PainEvent>>((ref) async {
  final repository = ref.watch(painEventRepositoryProvider);
  return await repository.getRecent(limit: 5);
});

/// Provider du nombre d'événements de cette semaine
final weeklyPainEventsCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(painEventRepositoryProvider);
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final startOfWeekNormalized = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  final endOfWeek = startOfWeekNormalized.add(const Duration(days: 7));
  
  final events = await repository.getByDateRange(startOfWeekNormalized, endOfWeek);
  return events.length;
});

/// Provider des statistiques
final painStatsProvider = FutureProvider<PainStats>((ref) async {
  final notifier = ref.watch(painEventsProvider.notifier);
  return await notifier.getStats();
});
