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
        DiscoveredFoodCardSchema,
        FoodCardDrawRecordSchema,
        ShoppingListItemStateSchema,
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
    final achievements = await isar.achievements.where().findAll();
    final discoveredCats = await isar.discoveredCats.where().findAll();
    final catDrawRecords = await isar.catDrawRecords.where().findAll();
    final discoveredFoodCards = await isar.discoveredFoodCards.where().findAll();
    final foodCardDrawRecords = await isar.foodCardDrawRecords.where().findAll();
    final shoppingListStates = await isar.shoppingListItemStates.where().findAll();

    return {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
      'meals': meals.map((m) => _mealToJson(m)).toList(),
      'painEvents': painEvents.map((p) => _painEventToJson(p)).toList(),
      'dailyReports': dailyReports.map((d) => _dailyReportToJson(d)).toList(),
      'foodItems': foodItems.map((f) => _foodItemToJson(f)).toList(),
      'settings': settings != null ? _settingsToJson(settings) : null,
      'achievements': achievements.map((a) => _achievementToJson(a)).toList(),
      'discoveredCats': discoveredCats.map((c) => _discoveredCatToJson(c)).toList(),
      'shoppingListStates': shoppingListStates.map((s) => {
        'id': s.id,
        'foodName': s.foodName,
        'isChecked': s.isChecked,
        'updatedAt': s.updatedAt.toIso8601String(),
      }).toList(),
      'catDrawRecords': catDrawRecords.map((r) => _catDrawRecordToJson(r)).toList(),
      'discoveredFoodCards':
          discoveredFoodCards.map((c) => _discoveredFoodCardToJson(c)).toList(),
      'foodCardDrawRecords':
          foodCardDrawRecords.map((r) => _foodCardDrawRecordToJson(r)).toList(),
    };
  }

  // Helpers de conversion en JSON
  Map<String, dynamic> _mealToJson(Meal meal) => {
    'id': meal.id,
    'plannedDateTime': meal.plannedDateTime.toIso8601String(),
    'consumedDateTime': meal.consumedDateTime?.toIso8601String(),
    'type': meal.type.index,
    'status': meal.status.index,
    'title': meal.title,
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
    'otherMomentDescription': event.otherMomentDescription,
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

  Map<String, dynamic> _achievementToJson(Achievement achievement) => {
    'id': achievement.id,
    'badgeType': achievement.badgeType.index,
    'unlockedAt': achievement.unlockedAt.toIso8601String(),
    'seen': achievement.seen,
  };

  Map<String, dynamic> _discoveredCatToJson(DiscoveredCat cat) => {
    'id': cat.id,
    'catId': cat.catId,
    'discoveredAt': cat.discoveredAt.toIso8601String(),
  };

  Map<String, dynamic> _catDrawRecordToJson(CatDrawRecord record) => {
    'id': record.id,
    'drawnAt': record.drawnAt.toIso8601String(),
    'catId': record.drawnCatId,
    'wasDuplicate': record.wasDuplicate,
  };

  Map<String, dynamic> _discoveredFoodCardToJson(DiscoveredFoodCard card) => {
    'id': card.id,
    'foodCardId': card.foodCardId,
    'discoveredAt': card.discoveredAt.toIso8601String(),
  };

  Map<String, dynamic> _foodCardDrawRecordToJson(FoodCardDrawRecord record) => {
    'id': record.id,
    'drawnAt': record.drawnAt.toIso8601String(),
    'foodCardId': record.drawnFoodCardId,
    'wasDuplicate': record.wasDuplicate,
  };

  /// Importe des données depuis un JSON (restauration de backup)
  Future<void> importFromJson(Map<String, dynamic> jsonData) async {
    await isar.writeTxn(() async {
      // Importer les repas
      if (jsonData['meals'] != null) {
        final meals = (jsonData['meals'] as List)
            .map((m) => _jsonToMeal(m as Map<String, dynamic>))
            .toList();
        await isar.meals.putAll(meals);
      }

      // Importer les douleurs
      if (jsonData['painEvents'] != null) {
        final painEvents = (jsonData['painEvents'] as List)
            .map((p) => _jsonToPainEvent(p as Map<String, dynamic>))
            .toList();
        await isar.painEvents.putAll(painEvents);
      }

      // Importer les journaux
      if (jsonData['dailyReports'] != null) {
        final dailyReports = (jsonData['dailyReports'] as List)
            .map((d) => _jsonToDailyReport(d as Map<String, dynamic>))
            .toList();
        await isar.dailyReports.putAll(dailyReports);
      }

      // Importer les aliments
      if (jsonData['foodItems'] != null) {
        final foodItems = (jsonData['foodItems'] as List)
            .map((f) => _jsonToFoodItem(f as Map<String, dynamic>))
            .toList();
        await isar.foodItems.putAll(foodItems);
      }

      // Importer les paramètres
      if (jsonData['settings'] != null) {
        final settings = _jsonToSettings(jsonData['settings'] as Map<String, dynamic>);
        await isar.appSettings.put(settings);
      }

      // Importer les achievements
      if (jsonData['achievements'] != null) {
        final achievements = (jsonData['achievements'] as List)
            .map((a) => _jsonToAchievement(a as Map<String, dynamic>))
            .toList();
        await isar.achievements.putAll(achievements);
      }

      // Importer les chats découverts
      if (jsonData['discoveredCats'] != null) {
        final discoveredCats = (jsonData['discoveredCats'] as List)
            .map((c) => _jsonToDiscoveredCat(c as Map<String, dynamic>))
            .toList();
        await isar.discoveredCats.putAll(discoveredCats);
      }

      // Importer les tirages de chats
      if (jsonData['catDrawRecords'] != null) {
        final catDrawRecords = (jsonData['catDrawRecords'] as List)
            .map((r) => _jsonToCatDrawRecord(r as Map<String, dynamic>))
            .toList();
        await isar.catDrawRecords.putAll(catDrawRecords);
      }

      // Importer les cartes de plats decouvertes
      if (jsonData['discoveredFoodCards'] != null) {
        final discoveredCards = (jsonData['discoveredFoodCards'] as List)
            .map((c) => _jsonToDiscoveredFoodCard(c as Map<String, dynamic>))
            .toList();
        await isar.discoveredFoodCards.putAll(discoveredCards);
      }

      // Importer les tirages de cartes de plats
      if (jsonData['foodCardDrawRecords'] != null) {
        final drawRecords = (jsonData['foodCardDrawRecords'] as List)
            .map((r) => _jsonToFoodCardDrawRecord(r as Map<String, dynamic>))
            .toList();
        await isar.foodCardDrawRecords.putAll(drawRecords);
      }
    });

    debugPrint('✅ Données importées avec succès');
  }

  // Helpers de conversion depuis JSON
  Meal _jsonToMeal(Map<String, dynamic> json) {
    final meal = Meal(
      plannedDateTime: DateTime.parse(json['plannedDateTime'] as String),
      type: MealType.values[json['type'] as int],
    );
    meal.id = json['id'] as int;
    meal.consumedDateTime = json['consumedDateTime'] != null 
        ? DateTime.parse(json['consumedDateTime'] as String) 
        : null;
    meal.status = MealStatus.values[json['status'] as int];
    meal.title = json['title'] as String?;
    meal.foods = (json['foods'] as List?)?.cast<String>() ?? [];
    meal.notes = json['notes'] as String?;
    meal.quantity = json['quantity'] as int? ?? 2;
    meal.createdAt = DateTime.parse(json['createdAt'] as String);
    meal.updatedAt = DateTime.parse(json['updatedAt'] as String);
    return meal;
  }

  PainEvent _jsonToPainEvent(Map<String, dynamic> json) {
    final painEvent = PainEvent(
      dateTime: DateTime.parse(json['dateTime'] as String),
      intensity: json['intensity'] as int,
    );
    painEvent.id = json['id'] as int;
    painEvent.isUsual = json['isUsual'] as bool;
    painEvent.description = json['description'] as String?;
    painEvent.otherMomentDescription = json['otherMomentDescription'] as String?;
    painEvent.symptomsIndexes = (json['symptomsIndexes'] as List?)?.cast<int>() ?? [];
    painEvent.digestiveState = DigestiveState.values[json['digestiveState'] as int];
    painEvent.location = PainLocation.values[json['location'] as int];
    painEvent.linkedMealId = json['linkedMealId'] as int?;
    painEvent.delayFromMealMinutes = json['delayFromMealMinutes'] as int?;
    painEvent.createdAt = DateTime.parse(json['createdAt'] as String);
    painEvent.updatedAt = DateTime.parse(json['updatedAt'] as String);
    return painEvent;
  }

  DailyReport _jsonToDailyReport(Map<String, dynamic> json) {
    final report = DailyReport(
      date: DateTime.parse(json['date'] as String),
    );
    report.id = json['id'] as int;
    report.status = DayStatus.values[json['status'] as int];
    report.stressLevel = json['stressLevel'] as int? ?? 0;
    report.fatigueLevel = json['fatigueLevel'] as int? ?? 0;
    report.transitQuality = TransitQuality.values[json['transitQuality'] as int];
    report.bowelMovements = json['bowelMovements'] as int? ?? 0;
    report.sleepQuality = json['sleepQuality'] as int? ?? 0;
    report.hoursSlept = (json['hoursSlept'] as num?)?.toDouble() ?? 0.0;
    report.notes = json['notes'] as String?;
    report.medications = (json['medications'] as List?)?.cast<String>() ?? [];
    report.createdAt = DateTime.parse(json['createdAt'] as String);
    report.updatedAt = DateTime.parse(json['updatedAt'] as String);
    return report;
  }

  FoodItem _jsonToFoodItem(Map<String, dynamic> json) {
    final foodItem = FoodItem(
      name: json['name'] as String,
    );
    foodItem.id = json['id'] as int;
    foodItem.category = FoodCategory.values[json['category'] as int];
    foodItem.consumptionCount = json['consumptionCount'] as int;
    foodItem.painAssociationCount = json['painAssociationCount'] as int;
    foodItem.isMarkedProblematic = json['isMarkedProblematic'] as bool;
    foodItem.notes = json['notes'] as String?;
    foodItem.lastConsumed = json['lastConsumed'] != null 
        ? DateTime.parse(json['lastConsumed'] as String) 
        : null;
    foodItem.createdAt = DateTime.parse(json['createdAt'] as String);
    return foodItem;
  }

  AppSettings _jsonToSettings(Map<String, dynamic> json) {
    final settings = AppSettings();
    settings.id = json['id'] as int;
    settings.themeMode = ThemeMode.values[json['themeMode'] as int];
    settings.userName = json['userName'] as String? ?? '';
    settings.mealReminders = json['mealReminders'] as bool;
    settings.hapticFeedback = json['hapticFeedback'] as bool;
    settings.breakfastHour = json['breakfastHour'] as int;
    settings.breakfastMinute = json['breakfastMinute'] as int;
    settings.lunchHour = json['lunchHour'] as int;
    settings.lunchMinute = json['lunchMinute'] as int;
    settings.dinnerHour = json['dinnerHour'] as int;
    settings.dinnerMinute = json['dinnerMinute'] as int;
    settings.maxMealPainLinkHours = json['maxMealPainLinkHours'] as int;
    settings.highlightProblematicFoods = json['highlightProblematicFoods'] as bool;
    settings.exportWithCharts = json['exportWithCharts'] as bool;
    settings.locale = (json['locale'] as String?) ?? 'fr';
    settings.firstUseDate = DateTime.parse(json['firstUseDate'] as String);
    settings.lastBackupDate = json['lastBackupDate'] != null 
        ? DateTime.parse(json['lastBackupDate'] as String) 
        : null;
    return settings;
  }

  Achievement _jsonToAchievement(Map<String, dynamic> json) {
    final achievement = Achievement();
    achievement.id = json['id'] as int;
    achievement.badgeType = BadgeType.values[json['badgeType'] as int];
    achievement.unlockedAt = DateTime.parse(json['unlockedAt'] as String);
    achievement.seen = json['seen'] as bool;
    return achievement;
  }

  DiscoveredCat _jsonToDiscoveredCat(Map<String, dynamic> json) {
    final cat = DiscoveredCat(
      catId: json['catId'] as String,
      discoveredAt: DateTime.parse(json['discoveredAt'] as String),
      reportDate: DateTime.parse(json['discoveredAt'] as String), // Utiliser la même date
    );
    cat.id = json['id'] as int;
    return cat;
  }

  CatDrawRecord _jsonToCatDrawRecord(Map<String, dynamic> json) {
    final record = CatDrawRecord(
      drawnAt: DateTime.parse(json['drawnAt'] as String),
      reportDate: DateTime.parse(json['drawnAt'] as String), // Utiliser la même date
      drawnCatId: (json['catId'] as String?) ?? 'unknown',
      wasDuplicate: (json['wasDuplicate'] as bool?) ?? false,
    );
    record.id = (json['id'] as num).toInt();
    return record;
  }

  DiscoveredFoodCard _jsonToDiscoveredFoodCard(Map<String, dynamic> json) {
    final card = DiscoveredFoodCard(
      foodCardId: json['foodCardId'] as String,
      discoveredAt: DateTime.parse(json['discoveredAt'] as String),
      reportDate: DateTime.parse(json['discoveredAt'] as String),
    );
    card.id = json['id'] as int;
    return card;
  }

  FoodCardDrawRecord _jsonToFoodCardDrawRecord(Map<String, dynamic> json) {
    final record = FoodCardDrawRecord(
      drawnAt: DateTime.parse(json['drawnAt'] as String),
      reportDate: DateTime.parse(json['drawnAt'] as String),
      drawnFoodCardId: (json['foodCardId'] as String?) ?? 'unknown',
      wasDuplicate: (json['wasDuplicate'] as bool?) ?? false,
    );
    record.id = (json['id'] as num).toInt();
    return record;
  }
}

