import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waky_gut/core/database/repositories/repositories.dart';
import 'package:waky_gut/core/models/models.dart';
import 'package:waky_gut/core/services/coin_service.dart';
import 'package:waky_gut/core/services/providers.dart';
import 'package:waky_gut/core/services/scene_puzzle.dart';
import 'package:waky_gut/core/services/scene_service.dart';
import 'package:waky_gut/features/scenes/current_scene_button.dart';
import 'package:waky_gut/features/scenes/scene_gallery_screen.dart';
import 'package:waky_gut/features/scenes/scene_puzzle_screen.dart';

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
    if (pieces.any((p) => p.refKey == piece.refKey)) return false;
    pieces.add(piece..id = _id++);
    return true;
  }
}

class _FakeCoins extends CoinService {
  _FakeCoins() : super(coinRepo: CoinRepository());
}

void main() {
  final assets = {
    for (final p in [
      ...sceneOrder.map((id) => 'assets/scenes/$id/scene.json'),
      'assets/scenes/pets/pets.json',
    ])
      p: File(p).readAsStringSync(),
  };

  late _MemoryPieces repo;
  late SceneService service;

  setUp(() {
    repo = _MemoryPieces();
    service = SceneService(
      repository: repo,
      coinService: _FakeCoins(),
      loadAsset: (p) async => assets[p]!,
    );
  });

  /// Affiche le bouton avec une vue d'ensemble donnée
  Future<void> pumpButton(
    WidgetTester tester,
    SceneOverview overview, {
    Size size = const Size(360, 690),
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentSceneProvider.overrideWith((ref) => overview),
          sceneServiceProvider.overrideWithValue(service),
          coinBalanceProvider.overrideWith((ref) => Stream.value(30)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: CurrentSceneButton(),
              ),
            ),
          ),
        ),
      ),
    );
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<SceneOverview> inProgress() async {
    await service.ensureStarterPieces('forest');
    return service.currentScene();
  }

  for (final size in const [Size(320, 640), Size(360, 690), Size(412, 915)]) {
    testWidgets(
      'scène en cours : titre, nom, avancement et pièces à poser, sans '
      'débordement (${size.width.toInt()}px)',
      (tester) async {
        final overview = await inProgress();
        await pumpButton(tester, overview, size: size);

        expect(find.text('Continuer ma scène'), findsOneWidget);
        expect(
          find.text('${overview.def.emoji} ${overview.def.name}'),
          findsOneWidget,
        );
        expect(find.text('0/${overview.state.totalSlots}'), findsOneWidget);
        // 3 pièces de départ dans le tiroir
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('scene-button-badge')),
            matching: find.text('${overview.state.inventoryCount}'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('tiroir vide : pas de pastille de pièces à poser', (
    tester,
  ) async {
    final def = await service.loadScene('forest');
    final overview = SceneOverview(
      def: def,
      state: ScenePuzzleState(def, const []),
      allDone: false,
    );
    await pumpButton(tester, overview);

    expect(find.text('Continuer ma scène'), findsOneWidget);
    expect(find.byKey(const ValueKey('scene-button-badge')), findsNothing);
  });

  testWidgets('scène terminée sans animal : invite à le choisir', (
    tester,
  ) async {
    final def = await service.loadScene('forest');
    final placed = [
      for (final slot in def.slots)
        ScenePiece(
          sceneId: def.id,
          modelId: slot.model,
          slotId: slot.id,
          source: ScenePieceSource.shop,
          refKey: 'placed:${slot.id}',
          acquiredAt: DateTime(2026, 11, 15),
        )..id = def.slots.indexOf(slot) + 1,
    ];
    final overview = SceneOverview(
      def: def,
      state: ScenePuzzleState(def, placed),
      allDone: false,
    );
    await pumpButton(tester, overview, size: const Size(320, 640));

    expect(find.textContaining('choisis son habitant'), findsOneWidget);
    expect(find.byKey(const ValueKey('scene-button-badge')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('toutes les scènes terminées : renvoie vers la collection', (
    tester,
  ) async {
    final def = await service.loadScene(sceneOrder.last);
    final overview = SceneOverview(
      def: def,
      state: ScenePuzzleState(def, const []),
      allDone: true,
    );
    await pumpButton(tester, overview);

    expect(find.textContaining('Toutes tes scènes sont terminées'), findsOneWidget);
    expect(find.text('Revoir ma collection'), findsOneWidget);
    expect(find.text('Continuer ma scène'), findsNothing);

    await tester.tap(find.byType(CurrentSceneButton));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(SceneGalleryScreen), findsOneWidget);
    expect(find.byType(ScenePuzzleScreen), findsNothing);
  });

  testWidgets('toucher le bouton ouvre directement le puzzle de la scène', (
    tester,
  ) async {
    final overview = await inProgress();
    await pumpButton(tester, overview);

    await tester.tap(find.byType(CurrentSceneButton));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byType(ScenePuzzleScreen), findsOneWidget);
    expect(find.byType(SceneGalleryScreen), findsNothing);
    // C'est bien la scène en cours qui s'ouvre
    expect(find.textContaining(overview.def.name), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
