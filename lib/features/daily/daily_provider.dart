import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/database/repositories/repositories.dart';
import '../../core/services/providers.dart';

/// État du rapport journalier
class DailyReportState {
  final DailyReport? report;
  final bool isLoading;
  final String? error;
  final DateTime selectedDate;

  const DailyReportState({
    this.report,
    this.isLoading = false,
    this.error,
    required this.selectedDate,
  });

  DailyReportState copyWith({
    DailyReport? report,
    bool? isLoading,
    String? error,
    DateTime? selectedDate,
  }) {
    return DailyReportState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

/// Notifier pour la gestion des rapports journaliers
class DailyReportNotifier extends StateNotifier<DailyReportState> {
  final DailyReportRepository _repository;

  DailyReportNotifier(this._repository)
      : super(DailyReportState(selectedDate: DateTime.now())) {
    loadReport();
  }

  /// Charge le rapport de la date sélectionnée
  Future<void> loadReport() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final report = await _repository.getByDate(state.selectedDate);
      state = state.copyWith(report: report, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Change la date sélectionnée
  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date);
    await loadReport();
  }

  /// Sauvegarde le rapport (création ou mise à jour)
  Future<bool> saveReport(DailyReport report) async {
    try {
      await _repository.save(report);
      state = state.copyWith(report: report);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Récupère ou crée le rapport d'aujourd'hui
  Future<DailyReport> getOrCreateToday() async {
    return await _repository.getOrCreateToday();
  }

  /// Récupère le rapport d'aujourd'hui sans le créer
  Future<DailyReport?> getTodayReport() async {
    return await _repository.getTodayReport();
  }

  /// Crée le rapport d'aujourd'hui
  Future<DailyReport> createTodayReport() async {
    return await _repository.getOrCreateToday();
  }

  /// Met à jour un champ spécifique du rapport
  Future<bool> updateField(DailyReport Function(DailyReport) updater) async {
    final current = state.report ?? DailyReport(date: state.selectedDate);
    final updated = updater(current);
    return await saveReport(updated);
  }

  /// Supprime un rapport
  Future<bool> deleteReport(int id) async {
    try {
      final deleted = await _repository.delete(id);
      if (deleted) {
        state = state.copyWith(report: null);
        // Recharger pour s'assurer que l'état est à jour
        await loadReport();
      }
      return deleted;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// Provider du rapport journalier
final dailyReportProvider = StateNotifierProvider<DailyReportNotifier, DailyReportState>((ref) {
  return DailyReportNotifier(ref.watch(dailyReportRepositoryProvider));
});

/// Provider du rapport d'aujourd'hui (sans création automatique)
final todayReportProvider = FutureProvider<DailyReport?>((ref) async {
  final repository = ref.watch(dailyReportRepositoryProvider);
  return await repository.getTodayReport();
});

/// Provider des rapports récents
final recentReportsProvider = FutureProvider<List<DailyReport>>((ref) async {
  final repository = ref.watch(dailyReportRepositoryProvider);
  return await repository.getRecent(limit: 7);
});

/// Provider des statistiques de bien-être
final wellbeingStatsProvider = FutureProvider<WellbeingStats>((ref) async {
  final repository = ref.watch(dailyReportRepositoryProvider);
  
  final avgWellbeing = await repository.getAverageWellbeing();
  final avgStress = await repository.getAverageStress();
  final avgFatigue = await repository.getAverageFatigue();
  final statusDist = await repository.getStatusDistribution();
  final consecutiveDifficult = await repository.getConsecutiveDifficultDays();

  return WellbeingStats(
    averageWellbeing: avgWellbeing,
    averageStress: avgStress,
    averageFatigue: avgFatigue,
    statusDistribution: statusDist,
    consecutiveDifficultDays: consecutiveDifficult,
  );
});

/// Provider pour obtenir tous les rapports (utilisé pour le calendrier)
final allReportsForCalendarProvider = FutureProvider<List<DailyReport>>((ref) async {
  final repository = ref.watch(dailyReportRepositoryProvider);
  return await repository.getAll();
});

/// Statistiques de bien-être
class WellbeingStats {
  final double averageWellbeing;
  final double averageStress;
  final double averageFatigue;
  final Map<DayStatus, int> statusDistribution;
  final int consecutiveDifficultDays;

  WellbeingStats({
    required this.averageWellbeing,
    required this.averageStress,
    required this.averageFatigue,
    required this.statusDistribution,
    required this.consecutiveDifficultDays,
  });
}
