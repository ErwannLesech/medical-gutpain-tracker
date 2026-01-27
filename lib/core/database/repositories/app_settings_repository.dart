import 'package:isar/isar.dart';

import '../../models/app_settings.dart';
import '../database_service.dart';

/// Repository pour la gestion des paramètres de l'application
class AppSettingsRepository {
  final DatabaseService _db;

  AppSettingsRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== READ / WRITE ====================

  /// Récupère les paramètres actuels ou crée les paramètres par défaut
  Future<AppSettings> get() async {
    var settings = await _isar.appSettings.where().findFirst();
    
    if (settings == null) {
      settings = AppSettings();
      await save(settings);
    }
    
    return settings;
  }

  /// Sauvegarde les paramètres
  Future<int> save(AppSettings settings) async {
    return await _isar.writeTxn(() async {
      return await _isar.appSettings.put(settings);
    });
  }

  /// Met à jour un paramètre spécifique
  Future<AppSettings> update(AppSettings Function(AppSettings) updater) async {
    var settings = await get();
    settings = updater(settings);
    await save(settings);
    return settings;
  }

  // ==================== HELPERS ====================

  /// Met à jour le mode de thème
  Future<void> setThemeMode(ThemeMode mode) async {
    await update((s) => s.copyWith(themeMode: mode));
  }

  /// Met à jour le nom de l'utilisateur
  Future<void> setUserName(String? name) async {
    await update((s) => s.copyWith(userName: name));
  }

  /// Active/désactive les rappels de repas
  Future<void> setMealReminders(bool enabled) async {
    await update((s) => s.copyWith(mealReminders: enabled));
  }

  /// Active/désactive le retour haptique
  Future<void> setHapticFeedback(bool enabled) async {
    await update((s) => s.copyWith(hapticFeedback: enabled));
  }

  /// Met à jour les heures de repas par défaut
  Future<void> setDefaultMealTimes({
    int? breakfastHour,
    int? breakfastMinute,
    int? lunchHour,
    int? lunchMinute,
    int? dinnerHour,
    int? dinnerMinute,
  }) async {
    await update((s) => s.copyWith(
      breakfastHour: breakfastHour,
      breakfastMinute: breakfastMinute,
      lunchHour: lunchHour,
      lunchMinute: lunchMinute,
      dinnerHour: dinnerHour,
      dinnerMinute: dinnerMinute,
    ));
  }

  /// Met à jour le délai maximum pour lier repas et douleur
  Future<void> setMaxMealPainLinkHours(int hours) async {
    await update((s) => s.copyWith(maxMealPainLinkHours: hours));
  }

  /// Enregistre la date de dernière sauvegarde
  Future<void> recordBackup() async {
    await update((s) => s.copyWith(lastBackupDate: DateTime.now()));
  }

  // ==================== WATCH ====================

  /// Stream des paramètres
  Stream<AppSettings?> watch() {
    return _isar.appSettings
        .where()
        .watch(fireImmediately: true)
        .map((list) => list.isNotEmpty ? list.first : null);
  }

  // ==================== RESET ====================

  /// Réinitialise les paramètres par défaut
  Future<AppSettings> reset() async {
    await _isar.writeTxn(() async {
      await _isar.appSettings.clear();
    });
    return await get();
  }
}
