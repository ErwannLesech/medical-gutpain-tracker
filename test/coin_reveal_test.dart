import 'package:flutter_test/flutter_test.dart';
import 'package:waky_gut/core/database/repositories/repositories.dart';
import 'package:waky_gut/core/models/models.dart';
import 'package:waky_gut/core/services/coin_service.dart';
import 'package:waky_gut/core/services/scene_puzzle.dart';
import 'package:waky_gut/core/services/scene_service.dart';

import 'helpers/memory_coin_repository.dart';

void main() {
  late MemoryCoinRepository repo;
  late CoinService coins;
  late SceneService scenes;

  setUp(() {
    repo = MemoryCoinRepository();
    coins = CoinService(coinRepo: repo);
    scenes = SceneService(repository: ScenePieceRepository(), coinService: coins);
  });

  group('bilan mensuel', () {
    test('le cadeau est versé la première fois seulement', () async {
      expect(await coins.markRecapSeen(2026, 10), CoinRewards.monthlyRecap);
      expect(await coins.getBalance(), CoinRewards.monthlyRecap);
      expect(await coins.isRecapSeen(2026, 10), isTrue);

      // Revoir le même bilan ne rapporte plus rien
      expect(await coins.markRecapSeen(2026, 10), 0);
      expect(await coins.getBalance(), CoinRewards.monthlyRecap);
    });

    test('chaque mois a son propre cadeau', () async {
      await coins.markRecapSeen(2026, 10);
      expect(await coins.markRecapSeen(2026, 11), CoinRewards.monthlyRecap);
      expect(await coins.getBalance(), 2 * CoinRewards.monthlyRecap);
    });

    test('un bilan déjà vu avant le cadeau le reçoit à la prochaine visite',
        () async {
      // Ancien registre : seul le mouvement « vu » à 0 existait
      await repo.addIfAbsent(CoinTransaction(
        amount: 0,
        reason: CoinReason.monthlyRecap,
        refKey: CoinService.recapRefKey(2026, 10),
        createdAt: DateTime(2026, 11, 1),
      ));
      expect(await coins.markRecapSeen(2026, 10), CoinRewards.monthlyRecap);
      expect(await coins.markRecapSeen(2026, 10), 0);
    });
  });

  group('zones dévoilées du modèle', () {
    Future<void> fund(int amount) => coins.awardDuplicate(
          'cat',
          DateTime(2026, 11, 1),
          amount: amount,
        );

    test('SceneReveal.parse ignore les autres clés et les zones invalides', () {
      expect(
        SceneReveal.parse('forest', [
          'reveal:forest:0',
          'reveal:forest:7',
          'reveal:forest:8', // hors quadrillage
          'reveal:forest:x',
          'reveal:holiday:3', // autre scène
          'hint:forest:123',
        ]),
        {0, 7},
      );
    });

    test('dévoiler une zone coûte son prix et la mémorise', () async {
      await fund(10);
      expect(await scenes.revealedCells('forest'), isEmpty);

      expect(await scenes.revealCell('forest', 3), isTrue);
      expect(await coins.getBalance(), 10 - CoinRewards.sceneReveal);
      expect(await scenes.revealedCells('forest'), {3});
    });

    test('on ne paie jamais deux fois la même zone', () async {
      await fund(20);
      expect(await scenes.revealCell('forest', 3), isTrue);
      expect(await scenes.revealCell('forest', 3), isFalse);
      expect(await coins.getBalance(), 20 - CoinRewards.sceneReveal);
    });

    test('solde insuffisant : rien n\'est dévoilé ni débité', () async {
      await fund(CoinRewards.sceneReveal - 1);
      expect(await scenes.revealCell('forest', 0), isFalse);
      expect(await coins.getBalance(), CoinRewards.sceneReveal - 1);
      expect(await scenes.revealedCells('forest'), isEmpty);
    });

    test('chaque scène a ses propres zones', () async {
      await fund(20);
      await scenes.revealCell('forest', 1);
      await scenes.revealCell('holiday', 2);
      expect(await scenes.revealedCells('forest'), {1});
      expect(await scenes.revealedCells('holiday'), {2});
    });

    test('zone hors quadrillage : refusée', () async {
      await fund(20);
      expect(await scenes.revealCell('forest', -1), isFalse);
      expect(await scenes.revealCell('forest', SceneReveal.cells), isFalse);
      expect(await coins.getBalance(), 20);
    });
  });
}
