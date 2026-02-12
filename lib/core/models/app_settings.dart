import 'package:isar/isar.dart';

part 'app_settings.g.dart';

/// Mode de thème
enum ThemeMode {
  light,
  dark,
  system,
}

/// Paramètres de l'application
@collection
class AppSettings {
  Id id = Isar.autoIncrement;

  /// Mode de thème
  @Enumerated(EnumType.ordinal)
  ThemeMode themeMode;

  /// Nom de l'utilisateur (optionnel, pour personnalisation)
  String? userName;

  /// Activer les notifications de rappel de repas
  bool mealReminders;

  /// Activer les retours haptiques
  bool hapticFeedback;

  /// Activer la notification journalière de rappel
  bool dailyReminderEnabled;

  /// Heure de la notification journalière
  int dailyReminderHour;
  int dailyReminderMinute;

  /// Heures par défaut des repas
  int breakfastHour;
  int breakfastMinute;
  int lunchHour;
  int lunchMinute;
  int dinnerHour;
  int dinnerMinute;

  /// Délai maximum (en heures) pour lier une douleur à un repas
  int maxMealPainLinkHours;

  /// Afficher les aliments problématiques en rouge
  bool highlightProblematicFoods;

  /// Exporter les données avec graphiques
  bool exportWithCharts;

  /// Langue de l'application
  String locale;

  /// Taille du texte (facteur d'échelle)
  double textScale;

  /// Date de première utilisation
  DateTime firstUseDate;

  /// Dernière sauvegarde
  DateTime? lastBackupDate;

  AppSettings({
    this.themeMode = ThemeMode.system,
    this.userName,
    this.mealReminders = true,
    this.hapticFeedback = true,
    this.dailyReminderEnabled = false,
    this.dailyReminderHour = 20,
    this.dailyReminderMinute = 0,
    this.breakfastHour = 8,
    this.breakfastMinute = 0,
    this.lunchHour = 12,
    this.lunchMinute = 30,
    this.dinnerHour = 19,
    this.dinnerMinute = 30,
    this.maxMealPainLinkHours = 6,
    this.highlightProblematicFoods = true,
    this.exportWithCharts = true,
    this.textScale = 1.0,
    this.locale = 'fr',
    this.lastBackupDate,
  }) : firstUseDate = DateTime.now();

  /// Retourne l'heure du petit-déjeuner formatée
  String get breakfastTime => 
      '${breakfastHour.toString().padLeft(2, '0')}:${breakfastMinute.toString().padLeft(2, '0')}';

  /// Retourne l'heure du déjeuner formatée
  String get lunchTime => 
      '${lunchHour.toString().padLeft(2, '0')}:${lunchMinute.toString().padLeft(2, '0')}';

  /// Retourne l'heure du dîner formatée
  String get dinnerTime => 
      '${dinnerHour.toString().padLeft(2, '0')}:${dinnerMinute.toString().padLeft(2, '0')}';

  /// Retourne l'heure de la notification journalière formatée
  String get dailyReminderTime => 
      '${dailyReminderHour.toString().padLeft(2, '0')}:${dailyReminderMinute.toString().padLeft(2, '0')}';

  /// Copie les paramètres avec des modifications
  AppSettings copyWith({
    ThemeMode? themeMode,
    String? userName,
    bool? mealReminders,
    bool? hapticFeedback,
    bool? dailyReminderEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    int? breakfastHour,
    int? breakfastMinute,
    int? lunchHour,
    int? lunchMinute,
    int? dinnerHour,
    int? dinnerMinute,
    int? maxMealPainLinkHours,
    bool? highlightProblematicFoods,
    bool? exportWithCharts,
    String? locale,
    DateTime? lastBackupDate,
  }) {
    final copy = AppSettings(
      themeMode: themeMode ?? this.themeMode,
      userName: userName ?? this.userName,
      mealReminders: mealReminders ?? this.mealReminders,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      breakfastHour: breakfastHour ?? this.breakfastHour,
      breakfastMinute: breakfastMinute ?? this.breakfastMinute,
      lunchHour: lunchHour ?? this.lunchHour,
      lunchMinute: lunchMinute ?? this.lunchMinute,
      dinnerHour: dinnerHour ?? this.dinnerHour,
      dinnerMinute: dinnerMinute ?? this.dinnerMinute,
      maxMealPainLinkHours: maxMealPainLinkHours ?? this.maxMealPainLinkHours,
      highlightProblematicFoods: highlightProblematicFoods ?? this.highlightProblematicFoods,
      exportWithCharts: exportWithCharts ?? this.exportWithCharts,
      locale: locale ?? this.locale,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
    copy.id = id;
    copy.firstUseDate = this.firstUseDate;
    return copy;
  }
}
