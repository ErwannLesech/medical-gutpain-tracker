import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waky_gut/core/database/repositories/repositories.dart';
import 'package:waky_gut/core/services/coin_service.dart';
import 'package:waky_gut/core/services/providers.dart';
import 'package:waky_gut/core/services/scene_puzzle.dart';
import 'package:waky_gut/core/services/scene_service.dart';
import 'package:waky_gut/features/scenes/scene_widgets.dart';

import 'helpers/memory_coin_repository.dart';

void main() {
  final assets = {
    for (final id in sceneOrder)
      'assets/scenes/$id/scene.json': File(
        'assets/scenes/$id/scene.json',
      ).readAsStringSync(),
  };

  late MemoryCoinRepository repo;
  late SceneService service;
  late SceneDef def;

  Future<void> fund(int amount) => CoinService(
    coinRepo: repo,
  ).awardDuplicate('cat', DateTime(2026, 11, 1), amount: amount);

  Future<void> openDialog(
    WidgetTester tester, {
    required bool complete,
    Size size = const Size(360, 690),
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sceneServiceProvider.overrideWithValue(service),
          coinBalanceProvider.overrideWith((ref) => Stream.value(12)),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () =>
                      showSceneReference(context, def, complete: complete),
                  child: const Text('ouvrir'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ouvrir'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Finder hiddenCells() => find.byIcon(Icons.visibility_outlined);

  setUp(() async {
    repo = MemoryCoinRepository();
    service = SceneService(
      repository: ScenePieceRepository(),
      coinService: CoinService(coinRepo: repo),
      loadAsset: (p) async => assets[p]!,
    );
    def = await service.loadScene('forest');
  });

  for (final size in const [Size(360, 690), Size(412, 915)]) {
    testWidgets(
      'scène en cours : modèle flouté, toutes les zones à dévoiler '
      '(${size.width.toInt()}px)',
      (tester) async {
        await openDialog(tester, complete: false, size: size);

        expect(hiddenCells(), findsNWidgets(SceneReveal.cells));
        expect(find.textContaining('Le modèle est flou'), findsOneWidget);
        expect(
          find.text('0 / ${SceneReveal.cells} zones dévoilées'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('scène terminée : modèle en clair, plus de zones à dévoiler', (
    tester,
  ) async {
    await openDialog(tester, complete: true);

    expect(hiddenCells(), findsNothing);
    expect(find.textContaining('Le modèle est flou'), findsNothing);
    expect(find.textContaining('reconstruite'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('toucher une zone puis confirmer la dévoile et débite 4 Catcoins', (
    tester,
  ) async {
    await fund(10);
    await openDialog(tester, complete: false);

    await tester.tap(find.byKey(const ValueKey('reveal-cell-2')));
    await tester.pump();
    expect(find.text('Dévoiler cette zone ?'), findsOneWidget);
    await tester.tap(find.text('Dévoiler'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(hiddenCells(), findsNWidgets(SceneReveal.cells - 1));
    expect(
      find.text('1 / ${SceneReveal.cells} zones dévoilées'),
      findsOneWidget,
    );
    expect(await CoinService(coinRepo: repo).getBalance(), 10 - 4);
    expect(await service.revealedCells(def.id), {2});
    expect(tester.takeException(), isNull);
  });

  testWidgets('refuser la confirmation ne dévoile rien', (tester) async {
    await fund(10);
    await openDialog(tester, complete: false);

    await tester.tap(find.byKey(const ValueKey('reveal-cell-0')));
    await tester.pump();
    await tester.tap(find.text('Non'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(hiddenCells(), findsNWidgets(SceneReveal.cells));
    expect(await CoinService(coinRepo: repo).getBalance(), 10);
  });

  testWidgets('solde insuffisant : message et zone toujours floue', (
    tester,
  ) async {
    await fund(1);
    await openDialog(tester, complete: false);

    await tester.tap(find.byKey(const ValueKey('reveal-cell-5')));
    await tester.pump();
    await tester.tap(find.text('Dévoiler'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(hiddenCells(), findsNWidgets(SceneReveal.cells));
    expect(find.textContaining('Il te faut 4 Catcoins'), findsOneWidget);
    expect(await CoinService(coinRepo: repo).getBalance(), 1);
  });

  testWidgets('les zones déjà dévoilées sont retrouvées à la réouverture', (
    tester,
  ) async {
    await fund(10);
    await service.revealCell(def.id, 1);
    await service.revealCell(def.id, 6);
    await openDialog(tester, complete: false);

    expect(hiddenCells(), findsNWidgets(SceneReveal.cells - 2));
    expect(
      find.text('2 / ${SceneReveal.cells} zones dévoilées'),
      findsOneWidget,
    );
  });
}
