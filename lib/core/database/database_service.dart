import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';

/// Service de gestion de la base de données Isar
/// Singleton pour garantir une seule instance de la base
class DatabaseService {
  static DatabaseService? _instance;
  static Isar? _isar;

  DatabaseService._();

  /// Retourne l'instance singleton du service
  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  /// Retourne l'instance Isar (doit être initialisée avant utilisation)
  Isar get isar {
    if (_isar == null) {
      throw StateError(
        'La base de données n\'est pas initialisée. '
        'Appelez DatabaseService.instance.initialize() d\'abord.',
      );
    }
    return _isar!;
  }

  /// Vérifie si la base de données est initialisée
  bool get isInitialized => _isar != null;

  /// Initialise la base de données Isar
  Future<void> initialize() async {
    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [
        MealSchema,
        PainEventSchema,
        DailyReportSchema,
        FoodItemSchema,
        AppSettingsSchema,
        AchievementSchema,
        DiscoveredCatSchema,
        CatDrawRecordSchema,
      ],
      directory: dir.path,
      name: 'wakygut_db',
      inspector: kDebugMode, // Activer l'inspecteur en mode debug
    );

    debugPrint('✅ Base de données Isar initialisée');
  }

  /// Ferme la base de données
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
    debugPrint('🔒 Base de données Isar fermée');
  }

  /// Efface toutes les données (pour tests ou reset)
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
    debugPrint('🗑️ Toutes les données ont été effacées');
  }

  /// Exporte les données en JSON (pour backup)
  Future<Map<String, dynamic>> exportToJson() async {
    final meals = await isar.meals.where().findAll();
    final painEvents = await isar.painEvents.where().findAll();
    final dailyReports = await isar.dailyReports.where().findAll();
    final foodItems = await isar.foodItems.where().findAll();
    final settings = await isar.appSettings.where().findFirst();

    return {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
      'meals': meals.map((m) => _mealToJson(m)).toList(),
      'painEvents': painEvents.map((p) => _painEventToJson(p)).toList(),
      'dailyReports': dailyReports.map((d) => _dailyReportToJson(d)).toList(),
      'foodItems': foodItems.map((f) => _foodItemToJson(f)).toList(),
      'settings': settings != null ? _settingsToJson(settings) : null,
    };
  }

  // Helpers de conversion en JSON
  Map<String, dynamic> _mealToJson(Meal meal) => {
    'id': meal.id,
    'plannedDateTime': meal.plannedDateTime.toIso8601String(),
    'consumedDateTime': meal.consumedDateTime?.toIso8601String(),
    'type': meal.type.index,
    'status': meal.status.index,
    'foods': meal.foods,
    'notes': meal.notes,
    'quantity': meal.quantity,
    'createdAt': meal.createdAt.toIso8601String(),
    'updatedAt': meal.updatedAt.toIso8601String(),
  };

  Map<String, dynamic> _painEventToJson(PainEvent event) => {
    'id': event.id,
    'dateTime': event.dateTime.toIso8601String(),
    'intensity': event.intensity,
    'isUsual': event.isUsual,
    'description': event.description,
    'symptomsIndexes': event.symptomsIndexes,
    'digestiveState': event.digestiveState.index,
    'location': event.location.index,
    'linkedMealId': event.linkedMealId,
    'delayFromMealMinutes': event.delayFromMealMinutes,
    'createdAt': event.createdAt.toIso8601String(),
    'updatedAt': event.updatedAt.toIso8601String(),
  };

  Map<String, dynamic> _dailyReportToJson(DailyReport report) => {
    'id': report.id,
    'date': report.date.toIso8601String(),
    'status': report.status.index,
    'stressLevel': report.stressLevel,
    'fatigueLevel': report.fatigueLevel,
    'transitQuality': report.transitQuality.index,
    'bowelMovements': report.bowelMovements,
    'sleepQuality': report.sleepQuality,
    'hoursSlept': report.hoursSlept,
    'notes': report.notes,
    'medications': report.medications,
    'createdAt': report.createdAt.toIso8601String(),
    'updatedAt': report.updatedAt.toIso8601String(),
  };

  Map<String, dynamic> _foodItemToJson(FoodItem item) => {
    'id': item.id,
    'name': item.name,
    'category': item.category.index,
    'consumptionCount': item.consumptionCount,
    'painAssociationCount': item.painAssociationCount,
    'isMarkedProblematic': item.isMarkedProblematic,
    'notes': item.notes,
    'lastConsumed': item.lastConsumed?.toIso8601String(),
    'createdAt': item.createdAt.toIso8601String(),
  };

  Map<String, dynamic> _settingsToJson(AppSettings settings) => {
    'id': settings.id,
    'themeMode': settings.themeMode.index,
    'userName': settings.userName,
    'mealReminders': settings.mealReminders,
    'hapticFeedback': settings.hapticFeedback,
    'breakfastHour': settings.breakfastHour,
    'breakfastMinute': settings.breakfastMinute,
    'lunchHour': settings.lunchHour,
    'lunchMinute': settings.lunchMinute,
    'dinnerHour': settings.dinnerHour,
    'dinnerMinute': settings.dinnerMinute,
    'maxMealPainLinkHours': settings.maxMealPainLinkHours,
    'highlightProblematicFoods': settings.highlightProblematicFoods,
    'exportWithCharts': settings.exportWithCharts,
    'locale': settings.locale,
    'firstUseDate': settings.firstUseDate.toIso8601String(),
    'lastBackupDate': settings.lastBackupDate?.toIso8601String(),
  };
}
