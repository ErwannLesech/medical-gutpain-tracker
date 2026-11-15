import '../database/repositories/repositories.dart';
import '../models/models.dart';
import 'coin_service.dart';

/// Mois ciblé par un bilan
class RecapMonth {
  final int year;
  final int month;

  const RecapMonth(this.year, this.month);

  factory RecapMonth.of(DateTime date) => RecapMonth(date.year, date.month);

  DateTime get start => DateTime(year, month, 1);
  DateTime get end => DateTime(year, month + 1, 1); // exclusif
  int get daysInMonth => DateTime(year, month + 1, 0).day;
  RecapMonth get previous => RecapMonth.of(DateTime(year, month - 1, 1));

  @override
  bool operator ==(Object other) =>
      other is RecapMonth && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => 'RecapMonth($year-$month)';
}

/// Fenêtre d'affichage du bilan sur l'accueil :
/// les 2 derniers jours du mois (bilan du mois en cours)
/// et les 2 premiers jours du mois suivant (bilan du mois précédent).
/// Retourne null en dehors de cette fenêtre.
RecapMonth? recapMonthInWindow(DateTime now) {
  final current = RecapMonth.of(now);
  if (now.day <= 2) return current.previous;
  if (now.day >= current.daysInMonth - 1) return current;
  return null;
}

/// Dernier bilan disponible (pour le revoir depuis les réglages) :
/// le mois en cours s'il est dans ses 2 derniers jours, sinon le mois précédent.
RecapMonth latestRecapMonth(DateTime now) {
  final current = RecapMonth.of(now);
  return now.day >= current.daysInMonth - 1 ? current : current.previous;
}

/// Aliment et son nombre d'occurrences
class FoodCount {
  final String name;
  final int count;
  const FoodCount(this.name, this.count);
}

/// Statistiques d'un mois, prêtes à afficher
class MonthlyRecap {
  final RecapMonth month;

  /// Nombre de jours pris en compte (jours écoulés si mois en cours)
  final int daysCounted;
  final int daysTracked;
  final int longestStreak;

  /// État de chaque jour du mois (null = pas de journal), index 0 = jour 1
  final List<DayStatus?> dailyStatus;

  /// Intensité max de douleur par jour (0 = aucune), index 0 = jour 1
  final List<int> dailyMaxPain;

  final Map<DayStatus, int> statusCounts;
  final int painCount;
  final double? avgPainIntensity;

  /// Jours avec journal et sans aucune douleur
  final int painFreeDays;

  final DateTime? bestDay;
  final DayStatus? bestDayStatus;

  final double? avgSleepHours;
  final double? avgSleepQuality;
  final double? avgStress;
  final double? avgFatigue;

  final List<FoodCount> topFoods;
  final List<FoodCount> wellToleratedFoods;

  /// Aliments souvent liés à une douleur (vide si l'option est désactivée)
  final List<FoodCount> watchFoods;

  final int newCats;
  final int newFoodCards;
  final int coinsEarned;

  /// Mois précédent (null si aucun journal ce mois-là)
  final int? prevPainCount;
  final int? prevGoodDays;
  final double? prevAvgSleepHours;

  const MonthlyRecap({
    required this.month,
    required this.daysCounted,
    required this.daysTracked,
    required this.longestStreak,
    required this.dailyStatus,
    required this.dailyMaxPain,
    required this.statusCounts,
    required this.painCount,
    required this.avgPainIntensity,
    required this.painFreeDays,
    required this.bestDay,
    required this.bestDayStatus,
    required this.avgSleepHours,
    required this.avgSleepQuality,
    required this.avgStress,
    required this.avgFatigue,
    required this.topFoods,
    required this.wellToleratedFoods,
    required this.watchFoods,
    required this.newCats,
    required this.newFoodCards,
    required this.coinsEarned,
    required this.prevPainCount,
    required this.prevGoodDays,
    required this.prevAvgSleepHours,
  });

  int get goodDays =>
      (statusCounts[DayStatus.excellent] ?? 0) + (statusCounts[DayStatus.good] ?? 0);

  bool get hasData => daysTracked > 0 || painCount > 0;

  /// Calcule le bilan à partir des données brutes (fonction pure, testable)
  factory MonthlyRecap.compute({
    required RecapMonth month,
    required DateTime now,
    required List<DailyReport> reports,
    required List<PainEvent> pains,
    required List<Meal> meals,
    required Map<int, Meal> linkedMealsById,
    required List<DailyReport> prevReports,
    required List<PainEvent> prevPains,
    required int newCats,
    required int newFoodCards,
    required int coinsEarned,
    required bool includeWatchFoods,
  }) {
    final dim = month.daysInMonth;
    final isCurrentMonth = RecapMonth.of(now) == month;
    final daysCounted = isCurrentMonth ? now.day : dim;

    bool inMonth(DateTime d) => d.year == month.year && d.month == month.month;

    final monthReports = reports.where((r) => inMonth(r.date)).toList();
    final monthPains = pains.where((p) => inMonth(p.dateTime)).toList();

    // --- Jours ---
    final dailyStatus = List<DayStatus?>.filled(dim, null);
    for (final r in monthReports) {
      dailyStatus[r.date.day - 1] = r.status;
    }
    final dailyMaxPain = List<int>.filled(dim, 0);
    for (final p in monthPains) {
      final i = p.dateTime.day - 1;
      if (p.intensity > dailyMaxPain[i]) dailyMaxPain[i] = p.intensity;
    }

    var longest = 0, run = 0;
    for (final s in dailyStatus) {
      run = s != null ? run + 1 : 0;
      if (run > longest) longest = run;
    }

    final statusCounts = <DayStatus, int>{};
    for (final r in monthReports) {
      statusCounts[r.status] = (statusCounts[r.status] ?? 0) + 1;
    }

    final painFreeDays = monthReports.where((r) => dailyMaxPain[r.date.day - 1] == 0).length;

    // Meilleur jour : meilleur état, puis douleur la plus faible, puis le plus récent
    DailyReport? best;
    for (final r in monthReports) {
      if (best == null) {
        best = r;
        continue;
      }
      final byStatus = r.status.index.compareTo(best.status.index);
      final byPain = dailyMaxPain[r.date.day - 1].compareTo(dailyMaxPain[best.date.day - 1]);
      if (byStatus < 0 ||
          (byStatus == 0 && byPain < 0) ||
          (byStatus == 0 && byPain == 0 && r.date.isAfter(best.date))) {
        best = r;
      }
    }

    double? avg(Iterable<num> values) =>
        values.isEmpty ? null : values.fold<num>(0, (a, b) => a + b) / values.length;

    // --- Aliments ---
    final eaten = meals.where((m) => inMonth(m.plannedDateTime) && m.status != MealStatus.skipped);
    final foodCounts = <String, int>{};
    final displayNames = <String, String>{};
    for (final meal in eaten) {
      for (final food in meal.foods) {
        final key = food.trim().toLowerCase();
        if (key.isEmpty) continue;
        displayNames.putIfAbsent(key, () => food.trim());
        foodCounts[key] = (foodCounts[key] ?? 0) + 1;
      }
    }

    final painFoodCounts = <String, int>{};
    for (final p in monthPains) {
      final meal = p.linkedMealId != null ? linkedMealsById[p.linkedMealId] : null;
      if (meal == null) continue;
      for (final food in meal.foods.map((f) => f.trim().toLowerCase()).toSet()) {
        if (food.isEmpty) continue;
        displayNames.putIfAbsent(food, () => food);
        painFoodCounts[food] = (painFoodCounts[food] ?? 0) + 1;
      }
    }

    List<FoodCount> top(Map<String, int> counts, bool Function(String, int) keep) {
      final entries = counts.entries.where((e) => keep(e.key, e.value)).toList()
        ..sort((a, b) => b.value != a.value
            ? b.value.compareTo(a.value)
            : displayNames[a.key]!.compareTo(displayNames[b.key]!));
      return entries.take(3).map((e) => FoodCount(displayNames[e.key]!, e.value)).toList();
    }

    // --- Mois précédent ---
    final prev = month.previous;
    bool inPrev(DateTime d) => d.year == prev.year && d.month == prev.month;
    final prevMonthReports = prevReports.where((r) => inPrev(r.date)).toList();
    final hasPrev = prevMonthReports.isNotEmpty;

    return MonthlyRecap(
      month: month,
      daysCounted: daysCounted,
      daysTracked: monthReports.length,
      longestStreak: longest,
      dailyStatus: dailyStatus,
      dailyMaxPain: dailyMaxPain,
      statusCounts: statusCounts,
      painCount: monthPains.length,
      avgPainIntensity: avg(monthPains.map((p) => p.intensity)),
      painFreeDays: painFreeDays,
      bestDay: best?.date,
      bestDayStatus: best?.status,
      avgSleepHours: avg(monthReports.map((r) => r.hoursSlept)),
      avgSleepQuality: avg(monthReports.map((r) => r.sleepQuality)),
      avgStress: avg(monthReports.map((r) => r.stressLevel)),
      avgFatigue: avg(monthReports.map((r) => r.fatigueLevel)),
      topFoods: top(foodCounts, (_, _) => true),
      wellToleratedFoods: top(foodCounts, (k, v) => v >= 2 && !painFoodCounts.containsKey(k)),
      watchFoods: includeWatchFoods ? top(painFoodCounts, (_, v) => v >= 2) : const [],
      newCats: newCats,
      newFoodCards: newFoodCards,
      coinsEarned: coinsEarned,
      prevPainCount: hasPrev ? prevPains.where((p) => inPrev(p.dateTime)).length : null,
      prevGoodDays: hasPrev
          ? prevMonthReports
              .where((r) => r.status == DayStatus.excellent || r.status == DayStatus.good)
              .length
          : null,
      prevAvgSleepHours: hasPrev ? avg(prevMonthReports.map((r) => r.hoursSlept)) : null,
    );
  }
}

/// Service qui rassemble les données nécessaires au bilan
class MonthlyRecapService {
  final DailyReportRepository dailyRepo;
  final PainEventRepository painRepo;
  final MealRepository mealRepo;
  final DiscoveredCatRepository catRepo;
  final DiscoveredFoodCardRepository foodCardRepo;
  final AppSettingsRepository settingsRepo;
  final CoinService coinService;

  MonthlyRecapService({
    required this.dailyRepo,
    required this.painRepo,
    required this.mealRepo,
    required this.catRepo,
    required this.foodCardRepo,
    required this.settingsRepo,
    required this.coinService,
  });

  Future<MonthlyRecap> build(RecapMonth month, {DateTime? now}) async {
    final prev = month.previous;
    final lastDay = month.end.subtract(const Duration(days: 1));

    final reports = await dailyRepo.getByDateRange(month.start, lastDay);
    final prevReports = await dailyRepo.getByDateRange(
        prev.start, prev.end.subtract(const Duration(days: 1)));
    final pains = await painRepo.getByDateRange(month.start, month.end);
    final prevPains = await painRepo.getByDateRange(prev.start, prev.end);
    // Les douleurs du début de mois peuvent être liées à un repas de la veille
    final meals = await mealRepo.getByDateRange(
        month.start.subtract(const Duration(days: 1)), month.end);

    final linkedIds = pains.map((p) => p.linkedMealId).whereType<int>().toSet();
    final linkedMeals = <int, Meal>{for (final m in meals) m.id: m};
    for (final id in linkedIds.where((id) => !linkedMeals.containsKey(id))) {
      final meal = await mealRepo.getById(id);
      if (meal != null) linkedMeals[id] = meal;
    }

    bool inMonth(DateTime d) => !d.isBefore(month.start) && d.isBefore(month.end);
    final newCats =
        (await catRepo.getAllDiscovered()).where((c) => inMonth(c.discoveredAt)).length;
    final newFoodCards =
        (await foodCardRepo.getAllDiscovered()).where((c) => inMonth(c.discoveredAt)).length;
    final coins = await coinService.getEarnedBetween(month.start, month.end);
    final settings = await settingsRepo.get();

    return MonthlyRecap.compute(
      month: month,
      now: now ?? DateTime.now(),
      reports: reports,
      pains: pains,
      meals: meals,
      linkedMealsById: linkedMeals,
      prevReports: prevReports,
      prevPains: prevPains,
      newCats: newCats,
      newFoodCards: newFoodCards,
      coinsEarned: coins,
      includeWatchFoods: settings.highlightProblematicFoods,
    );
  }
}
