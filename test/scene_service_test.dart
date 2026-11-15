import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:waky_gut/core/database/repositories/repositories.dart';
import 'package:waky_gut/core/models/models.dart';
import 'package:waky_gut/core/services/coin_service.dart';
import 'package:waky_gut/core/services/scene_service.dart';

class _MemoryPieces extends ScenePieceRepository {
  final List<ScenePiece> pieces = [];
  var _id = 1;

  @override
  Future<List<ScenePiece>> getForScene(String sceneId) async =>
      pieces.where((p) => p.sceneId == sceneId).toList();

  @override
  Future<bool> hasRefKey(String refKey) async =>
      pieces.any((p) => p.refKey == refKey);

  @override
  Future<bool> addIfAbsent(ScenePiece piece) async {
    if (await hasRefKey(piece.refKey)) return false;
    pieces.add(piece..id = _id++);
    return true;
  }
}

/// Registre de Catcoins en mémoire
class _MemoryCoins extends CoinService {
  final Map<String, int> ledger = {};
  _MemoryCoins() : super(coinRepo: CoinRepository());

  @override
  Future<bool> hasRefKey(String refKey) async => ledger.containsKey(refKey);

  @override
  Future<int> awardDuplicate(
    String collection,
    DateTime reportDate, {
    int amount = CoinRewards.duplicateCard,
  }) async {
    final key = CoinService.duplicateRefKey(collection, reportDate);
    if (ledger.containsKey(key)) return 0;
    ledger[key] = amount;
    return amount;
  }
}

void main() {
  final assets = {
    for (final id in sceneOrder)
      'assets/scenes/$id/scene.json': File(
        'assets/scenes/$id/scene.json',
      ).readAsStringSync(),
  };
  final today = DateTime(2026, 11, 20);

  SceneService service(
    _MemoryPieces repo,
    _MemoryCoins coins, {
    int seed = 1,
  }) => SceneService(
    repository: repo,
    coinService: coins,
    loadAsset: (p) async => assets[p]!,
    random: Random(seed),
  );

  test(
    'nouvelle pièce : ajoutée au tiroir, une seule fois par journal',
    () async {
      final repo = _MemoryPieces();
      final coins = _MemoryCoins();
      final s = service(repo, coins);

      final first = await s.drawForDate(today, now: today);
      expect(first, isNotNull);
      expect(first!.isDuplicate, isFalse); // rien de complet au départ
      expect(repo.pieces, hasLength(1));
      expect(repo.pieces.single.refKey, 'journal:2026-11-20');

      expect(await s.drawForDate(today, now: today), isNull);
      expect(repo.pieces, hasLength(1));
    },
  );

  test(
    'doublon : transformé en Catcoins (moitié du prix), une seule fois par journal',
    () async {
      final repo = _MemoryPieces();
      final coins = _MemoryCoins();
      final s = service(repo, coins);
      // Toutes les pièces de la première scène sont possédées -> forcément un doublon
      final def = await s.loadScene(sceneOrder.first);
      for (final slot in def.slots) {
        await repo.addIfAbsent(
          ScenePiece(
            sceneId: def.id,
            modelId: slot.model,
            source: ScenePieceSource.shop,
            refKey: 'own:${slot.id}',
            acquiredAt: today,
          ),
        );
      }

      final result = await s.drawForDate(today, now: today);
      expect(result!.isDuplicate, isTrue);
      expect(result.coins, CoinRewards.sceneDuplicate(result.model.price));
      expect(coins.ledger['dup:scene:2026-11-20'], result.coins);
      expect(
        repo.pieces,
        hasLength(def.slots.length),
      ); // rien d'ajouté au tiroir

      expect(await s.canDrawForDate(today, now: today), isFalse);
    },
  );

  test('journal trop ancien : pas de tirage', () async {
    final s = service(_MemoryPieces(), _MemoryCoins());
    expect(
      await s.canDrawForDate(
        today.subtract(const Duration(days: 8)),
        now: today,
      ),
      isFalse,
    );
    expect(
      await s.canDrawForDate(
        today.subtract(const Duration(days: 7)),
        now: today,
      ),
      isTrue,
    );
  });

  test(
    'collection : seule la première scène est débloquée au départ',
    () async {
      final scenes = await service(_MemoryPieces(), _MemoryCoins()).allScenes();
      expect(scenes.first.unlocked, isTrue);
      expect(scenes.skip(1).every((s) => !s.unlocked), isTrue);
    },
  );

  test('scène terminée avec son animal : la suivante se débloque', () async {
    final repo = _MemoryPieces();
    final s = service(repo, _MemoryCoins());
    final def = await s.loadScene(sceneOrder.first);
    for (final slot in def.slots) {
      await repo.addIfAbsent(
        ScenePiece(
          sceneId: def.id,
          modelId: slot.model,
          slotId: slot.id,
          source: ScenePieceSource.shop,
          refKey: 'placed:${slot.id}',
          acquiredAt: today,
        ),
      );
    }
    expect(await s.choosePet(def.id, def.petChoices.first), isTrue);
    final scenes = await s.allScenes();
    expect(scenes.first.isFinished, isTrue);
    if (scenes.length > 1) {
      expect(scenes[1].unlocked, isTrue);
      expect((await s.currentScene()).def.id, scenes[1].def.id);
    }
  });
}
