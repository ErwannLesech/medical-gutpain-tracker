import 'package:isar/isar.dart';

import '../../models/daily_report.dart';
import '../database_service.dart';

/// Repository pour la gestion des rapports journaliers
class DailyReportRepository {
  final DatabaseService _db;

  DailyReportRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE / UPDATE ====================

  /// Crée ou met à jour un rapport journalier
  /// Un seul rapport par jour (date unique)
  Future<int> save(DailyReport report) async {
    // Normalise la date
    report.date = DailyReport.normalizeDate(report.date);
    
    // Vérifie s'il existe déjà un rapport pour cette date
    final existing = await getByDate(report.date);
    if (existing != null) {
      report.id = existing.id;
      report.createdAt = existing.createdAt;
    }
    
    report.updatedAt = DateTime.now();

    return await _isar.writeTxn(() async {
      return await _isar.dailyReports.put(report);
    });
  }

  // ==================== READ ====================

  /// Récupère un rapport par son ID
  Future<DailyReport?> getById(int id) async {
    return await _isar.dailyReports.get(id);
  }

  /// Récupère le rapport d'une date spécifique
  Future<DailyReport?> getByDate(DateTime date) async {
    final normalizedDate = DailyReport.normalizeDate(date);
    return await _isar.dailyReports
        .where()
        .filter()
        .dateEqualTo(normalizedDate)
        .findFirst();
  }

  /// Récupère tous les rapports
  Future<List<DailyReport>> getAll() async {
    return await _isar.dailyReports
        .where()
        .sortByDateDesc()
        .findAll();
  }

  /// Récupère les rapports d'une période
  Future<List<DailyReport>> getByDateRange(DateTime start, DateTime end) async {
    final normalizedStart = DailyReport.normalizeDate(start);
    final normalizedEnd = DailyReport.normalizeDate(end).add(const Duration(days: 1));

    return await _isar.dailyReports
        .where()
        .filter()
        .dateBetween(normalizedStart, normalizedEnd)
        .sortByDate()
        .findAll();
  }

  /// Récupère les N derniers rapports
  Future<List<DailyReport>> getRecent({int limit = 7}) async {
    return await _isar.dailyReports
        .where()
        .sortByDateDesc()
        .limit(limit)
        .findAll();
  }

  /// Récupère les rapports par statut
  Future<List<DailyReport>> getByStatus(DayStatus status) async {
    return await _isar.dailyReports
        .where()
        .filter()
        .statusEqualTo(status)
        .sortByDateDesc()
        .findAll();
  }

  /// Récupère le rapport d'aujourd'hui ou le crée
  Future<DailyReport> getOrCreateToday() async {
    final today = DailyReport.normalizeDate(DateTime.now());
    var report = await getByDate(today);
    
    if (report == null) {
      report = DailyReport(date: today);
      await save(report);
    }
    
    return report;
  }

  /// Récupère le rapport d'aujourd'hui sans le créer
  Future<DailyReport?> getTodayReport() async {
    final today = DailyReport.normalizeDate(DateTime.now());
    return await getByDate(today);
  }

  // ==================== DELETE ====================

  /// Supprime un rapport par son ID
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.dailyReports.delete(id);
    });
  }

  /// Supprime un rapport par date
  Future<bool> deleteByDate(DateTime date) async {
    final report = await getByDate(date);
    if (report == null) return false;
    return await delete(report.id);
  }

  /// Supprime tous les rapports
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.dailyReports.clear();
    });
  }

  // ==================== WATCH ====================

  /// Stream de tous les rapports
  Stream<List<DailyReport>> watchAll() {
    return _isar.dailyReports
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  /// Stream du rapport d'une date spécifique
  Stream<DailyReport?> watchByDate(DateTime date) {
    final normalizedDate = DailyReport.normalizeDate(date);
    return _isar.dailyReports
        .where()
        .filter()
        .dateEqualTo(normalizedDate)
        .watch(fireImmediately: true)
        .map((list) => list.isNotEmpty ? list.first : null);
  }

  // ==================== STATS ====================

  /// Compte le nombre total de rapports
  Future<int> count() async {
    return await _isar.dailyReports.count();
  }

  /// Calcule le score moyen de bien-être
  Future<double> getAverageWellbeing() async {
    final reports = await _isar.dailyReports.where().findAll();
    if (reports.isEmpty) return 0;
    
    // Convertit le statut en score (1-5)
    final sum = reports.fold<int>(0, (sum, r) => sum + (5 - r.status.index));
    return sum / reports.length;
  }

  /// Récupère la distribution des statuts
  Future<Map<DayStatus, int>> getStatusDistribution() async {
    final reports = await _isar.dailyReports.where().findAll();
    final distribution = <DayStatus, int>{};
    
    for (final status in DayStatus.values) {
      distribution[status] = 0;
    }
    
    for (final report in reports) {
      distribution[report.status] = (distribution[report.status] ?? 0) + 1;
    }
    
    return distribution;
  }

  /// Calcule le niveau moyen de stress
  Future<double> getAverageStress() async {
    final reports = await _isar.dailyReports.where().findAll();
    if (reports.isEmpty) return 0;
    
    final sum = reports.fold<int>(0, (sum, r) => sum + r.stressLevel);
    return sum / reports.length;
  }

  /// Calcule le niveau moyen de fatigue
  Future<double> getAverageFatigue() async {
    final reports = await _isar.dailyReports.where().findAll();
    if (reports.isEmpty) return 0;
    
    final sum = reports.fold<int>(0, (sum, r) => sum + r.fatigueLevel);
    return sum / reports.length;
  }

  /// Récupère les jours consécutifs difficiles
  Future<int> getConsecutiveDifficultDays() async {
    final reports = await _isar.dailyReports
        .where()
        .sortByDateDesc()
        .findAll();
    
    int count = 0;
    for (final report in reports) {
      if (report.status == DayStatus.difficult || 
          report.status == DayStatus.terrible) {
        count++;
      } else {
        break;
      }
    }
    
    return count;
  }
}
