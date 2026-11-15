import 'package:flutter_test/flutter_test.dart';
import 'package:waky_gut/core/models/models.dart';
import 'package:waky_gut/core/services/monthly_recap_service.dart';

DailyReport report(int day, DayStatus status, {double sleep = 7, int month = 11}) =>
    DailyReport(date: DateTime(2026, month, day), status: status, hoursSlept: sleep);

PainEvent pain(int day, int intensity, {int? mealId, int month = 11}) =>
    PainEvent(dateTime: DateTime(2026, month, day, 15), intensity: intensity, linkedMealId: mealId);

Meal meal(int id, int day, List<String> foods, {MealStatus status = MealStatus.confirmed}) =>
    Meal(plannedDateTime: DateTime(2026, 11, day, 12), type: MealType.lunch, foods: foods, status: status)
      ..id = id;

void main() {
  group('Fenêtre d\'affichage du bilan', () {
    test('2 premiers jours du mois -> bilan du mois précédent', () {
      expect(recapMonthInWindow(DateTime(2026, 12, 1)), const RecapMonth(2026, 11));
      expect(recapMonthInWindow(DateTime(2026, 12, 2)), const RecapMonth(2026, 11));
    });

    test('janvier -> décembre de l\'année précédente', () {
      expect(recapMonthInWindow(DateTime(2027, 1, 1)), const RecapMonth(2026, 12));
    });

    test('2 derniers jours du mois -> bilan du mois en cours', () {
      expect(recapMonthInWindow(DateTime(2026, 11, 29)), const RecapMonth(2026, 11));
      expect(recapMonthInWindow(DateTime(2026, 11, 30)), const RecapMonth(2026, 11));
      // Février non bissextile : 27 et 28
      expect(recapMonthInWindow(DateTime(2027, 2, 27)), const RecapMonth(2027, 2));
    });

    test('milieu de mois -> pas de bannière', () {
      expect(recapMonthInWindow(DateTime(2026, 11, 3)), isNull);
      expect(recapMonthInWindow(DateTime(2026, 11, 14)), isNull);
      expect(recapMonthInWindow(DateTime(2026, 11, 28)), isNull);
    });

    test('dernier bilan disponible depuis les réglages', () {
      expect(latestRecapMonth(DateTime(2026, 11, 14)), const RecapMonth(2026, 10));
      expect(latestRecapMonth(DateTime(2026, 11, 30)), const RecapMonth(2026, 11));
    });
  });

  group('Calcul du bilan', () {
    MonthlyRecap compute({bool watch = true, DateTime? now}) {
      final meals = [
        meal(1, 2, ['Riz', 'Poulet']),
        meal(2, 3, ['riz ', 'Courgette']),
        meal(3, 4, ['Lait', 'Céréales']),
        meal(4, 6, ['Lait', 'Riz']),
        meal(5, 7, ['Frites'], status: MealStatus.skipped),
      ];
      return MonthlyRecap.compute(
        month: const RecapMonth(2026, 11),
        now: now ?? DateTime(2026, 12, 1),
        reports: [
          report(1, DayStatus.good),
          report(2, DayStatus.excellent, sleep: 8),
          report(3, DayStatus.excellent, sleep: 6),
          report(4, DayStatus.difficult),
          report(6, DayStatus.average),
        ],
        pains: [pain(3, 2), pain(4, 4, mealId: 3), pain(4, 2), pain(6, 3, mealId: 4)],
        meals: meals,
        linkedMealsById: {for (final m in meals) m.id: m},
        prevReports: [report(10, DayStatus.good, month: 10), report(11, DayStatus.terrible, month: 10)],
        prevPains: [pain(10, 3, month: 10), pain(11, 5, month: 10), pain(12, 4, month: 10)],
        newCats: 2,
        newFoodCards: 0,
        coinsEarned: 42,
        includeWatchFoods: watch,
      );
    }

    test('jours, série et états', () {
      final r = compute();
      expect(r.daysCounted, 30);
      expect(r.daysTracked, 5);
      expect(r.longestStreak, 4); // 1 -> 4
      expect(r.goodDays, 3);
      expect(r.dailyStatus[4], isNull); // le 5 n'est pas renseigné
    });

    test('douleurs : total, max par jour, jours sans douleur, comparaison', () {
      final r = compute();
      expect(r.painCount, 4);
      expect(r.dailyMaxPain[3], 4); // le 4 : max(4, 2)
      expect(r.avgPainIntensity, closeTo(2.75, 0.001));
      expect(r.painFreeDays, 2); // le 1 et le 2
      expect(r.prevPainCount, 3);
      expect(r.prevGoodDays, 1);
    });

    test('meilleur jour : meilleur état puis moins de douleur', () {
      final r = compute();
      // Le 2 et le 3 sont "excellents", mais le 3 a une douleur
      expect(r.bestDay, DateTime(2026, 11, 2));
    });

    test('aliments : fréquents, bien tolérés, à surveiller', () {
      final r = compute();
      expect(r.topFoods.first.name, 'Riz');
      expect(r.topFoods.first.count, 3); // "riz " normalisé, repas sauté ignoré
      expect(r.topFoods.any((f) => f.name == 'Frites'), isFalse);
      // Riz apparaît dans le repas 4 lié à une douleur -> pas "bien toléré"
      expect(r.wellToleratedFoods, isEmpty);
      expect(r.watchFoods.single.name, 'Lait');
    });

    test('"à surveiller" masqué si l\'option est désactivée', () {
      expect(compute(watch: false).watchFoods, isEmpty);
    });

    test('mois en cours : seuls les jours écoulés comptent', () {
      expect(compute(now: DateTime(2026, 11, 29)).daysCounted, 29);
    });

    test('mois vide : pas de données, pas de crash', () {
      final r = MonthlyRecap.compute(
        month: const RecapMonth(2026, 11),
        now: DateTime(2026, 12, 1),
        reports: const [],
        pains: const [],
        meals: const [],
        linkedMealsById: const {},
        prevReports: const [],
        prevPains: const [],
        newCats: 0,
        newFoodCards: 0,
        coinsEarned: 0,
        includeWatchFoods: true,
      );
      expect(r.hasData, isFalse);
      expect(r.bestDay, isNull);
      expect(r.avgSleepHours, isNull);
      expect(r.prevPainCount, isNull);
    });
  });
}
