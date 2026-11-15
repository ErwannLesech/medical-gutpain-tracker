import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:waky_gut/core/database/repositories/repositories.dart';
import 'package:waky_gut/core/models/models.dart';
import 'package:waky_gut/core/services/coin_service.dart';
import 'package:waky_gut/core/services/monthly_recap_service.dart';
import 'package:waky_gut/core/services/providers.dart';
import 'package:waky_gut/features/recap/monthly_recap_screen.dart';

/// Faux service de bilan : renvoie un bilan riche, sans base de données
class _FakeRecapService extends MonthlyRecapService {
  final MonthlyRecap recap;
  _FakeRecapService(this.recap, CoinService coins)
      : super(
          dailyRepo: DailyReportRepository(),
          painRepo: PainEventRepository(),
          mealRepo: MealRepository(),
          catRepo: DiscoveredCatRepository(),
          foodCardRepo: DiscoveredFoodCardRepository(),
          settingsRepo: AppSettingsRepository(),
          coinService: coins,
        );

  @override
  Future<MonthlyRecap> build(RecapMonth month, {DateTime? now}) async => recap;
}

class _FakeCoinService extends CoinService {
  bool seen = false;
  _FakeCoinService() : super(coinRepo: CoinRepository());

  @override
  Future<bool> isRecapSeen(int year, int month) async => seen;

  @override
  Future<void> markRecapSeen(int year, int month) async => seen = true;
}

MonthlyRecap _richRecap() {
  final meals = [
    for (var d = 1; d <= 28; d++)
      Meal(
        plannedDateTime: DateTime(2026, 11, d, 12),
        type: MealType.lunch,
        foods: d.isEven ? ['Riz basmati', 'Poulet rôti'] : ['Lait d\'avoine', 'Pain complet'],
      )..id = d,
  ];
  return MonthlyRecap.compute(
    month: const RecapMonth(2026, 11),
    now: DateTime(2026, 12, 1),
    reports: [
      for (var d = 1; d <= 30; d++)
        if (d % 7 != 0)
          DailyReport(
            date: DateTime(2026, 11, d),
            status: DayStatus.values[d % 5],
            hoursSlept: 6.5 + (d % 3) * 0.5,
          ),
    ],
    pains: [
      for (var d = 1; d <= 28; d += 3)
        PainEvent(dateTime: DateTime(2026, 11, d, 14), intensity: 1 + d % 5, linkedMealId: d),
    ],
    meals: meals,
    linkedMealsById: {for (final m in meals) m.id: m},
    prevReports: [DailyReport(date: DateTime(2026, 10, 5), status: DayStatus.good)],
    prevPains: [PainEvent(dateTime: DateTime(2026, 10, 5), intensity: 3)],
    newCats: 2,
    newFoodCards: 5,
    coinsEarned: 64,
    includeWatchFoods: true,
  );
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  for (final size in const [Size(360, 690), Size(412, 915)]) {
    testWidgets('toutes les slides s\'affichent sans débordement (${size.width.toInt()}px)',
        (tester) async {
      tester.view.physicalSize = size * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final coins = _FakeCoinService();
      final recap = _richRecap();

      await tester.pumpWidget(ProviderScope(
        overrides: [
          coinServiceProvider.overrideWithValue(coins),
          monthlyRecapServiceProvider.overrideWithValue(_FakeRecapService(recap, coins)),
          coinBalanceProvider.overrideWith((ref) => Stream.value(42)),
        ],
        child: const MaterialApp(
          home: MonthlyRecapScreen(month: RecapMonth(2026, 11)),
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Novembre 2026'), findsOneWidget);

      // 7 slides : on avance en tapant sur la droite de l'écran
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 1500));
        expect(tester.takeException(), isNull, reason: 'slide $i');
        await tester.tapAt(Offset(size.width - 20, size.height / 2));
        await tester.pump();
      }
      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.text('Tes récompenses du mois'), findsOneWidget);

      // Arrivé au bout : le bilan est marqué comme vu (sans Catcoins)
      expect(coins.seen, isTrue);
      expect(find.text('Fermer'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
