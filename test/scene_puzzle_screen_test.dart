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
import 'package:waky_gut/features/scenes/scene_gallery_screen.dart';
import 'package:waky_gut/features/scenes/scene_puzzle_screen.dart';
import 'package:waky_gut/features/scenes/scene_widgets.dart';

/// Stockage en mémoire, sans Isar
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

  @override
  Future<bool> buy(ScenePiece piece, CoinTransaction payment) =>
      addIfAbsent(piece);

  @override
  Future<bool> place(int pieceId, String slotId) async {
    final p = pieces.firstWhere((p) => p.id == pieceId);
    if (p.slotId != null || pieces.any((o) => o.slotId == slotId)) return false;
    p.slotId = slotId;
    return true;
  }
}

class _FakeCoins extends CoinService {
  _FakeCoins() : super(coinRepo: CoinRepository());
  @override
  Future<bool> spend(int amount, String refKey) async => true;
}

void main() {
  // Lecture synchrone des JSON (les E/S réelles ne progressent pas dans testWidgets)
  final assets = {
    for (final p in [
      ...sceneOrder.map((id) => 'assets/scenes/$id/scene.json'),
      'assets/scenes/pets/pets.json',
    ])
      p: File(p).readAsStringSync(),
  };

  Future<(_MemoryPieces, SceneDef)> pumpScene(
    WidgetTester tester,
    Size size,
  ) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final repo = _MemoryPieces();
    final service = SceneService(
      repository: repo,
      coinService: _FakeCoins(),
      loadAsset: (p) async => assets[p]!,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sceneServiceProvider.overrideWithValue(service),
          coinBalanceProvider.overrideWith((ref) => Stream.value(30)),
        ],
        child: const MaterialApp(home: ScenePuzzleScreen()),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    return (repo, await service.loadScene('forest'));
  }

  /// Position à l'écran d'un point de la scène
  Offset toScreen(WidgetTester tester, Offset scenePoint) {
    final box = tester.renderObject<RenderBox>(
      find
          .descendant(
            of: find.byType(FittedBox),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    return box.localToGlobal(scenePoint);
  }

  /// Un emplacement libre du modèle voulu, visible à l'écran (la scène s'ouvre zoomée)
  SceneSlot visibleSlot(
    WidgetTester tester,
    SceneDef def,
    bool Function(SceneSlot) test,
  ) {
    final view = tester.getRect(find.byType(InteractiveViewer)).deflate(24);
    return def.slots.firstWhere(
      (s) =>
          test(s) &&
          s.requires.isEmpty &&
          view.contains(toScreen(tester, s.anchor)),
    );
  }

  Future<void> dragTo(WidgetTester tester, Finder from, Offset to) async {
    final gesture = await tester.startGesture(tester.getCenter(from));
    await tester.pump(const Duration(milliseconds: 50));
    final start = tester.getCenter(from);
    for (var i = 1; i <= 10; i++) {
      await gesture.moveTo(Offset.lerp(start, to, i / 10)!);
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  for (final size in const [Size(360, 690), Size(412, 915)]) {
    testWidgets(
      'pièces offertes dans le tiroir, sans débordement (${size.width.toInt()}px)',
      (tester) async {
        await pumpScene(tester, size);
        expect(find.text('0 / 38 pièces'), findsOneWidget);
        expect(find.text('Sapin'), findsOneWidget);
        expect(find.text('Chemin de terre'), findsOneWidget);
        expect(find.text('Pousse'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('glisser une pièce sur son repère la pose', (tester) async {
    final (repo, def) = await pumpScene(tester, const Size(412, 915));
    final tree = visibleSlot(tester, def, (s) => s.model == 'tree');

    await dragTo(tester, find.text('Sapin'), toScreen(tester, tree.anchor));

    final placed = repo.pieces.where((p) => p.modelId == 'tree').single;
    expect(placed.slotId, isNotNull);
    expect(def.slots.firstWhere((s) => s.id == placed.slotId).model, 'tree');
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1 / 38 pièces'), findsOneWidget);
    expect(find.text('Sapin'), findsNothing); // plus dans le tiroir
    expect(tester.takeException(), isNull);
  });

  testWidgets('mauvais repère : la pièce revient et un message aide', (
    tester,
  ) async {
    final (repo, def) = await pumpScene(tester, const Size(412, 915));
    final other = visibleSlot(tester, def, (s) => s.model == 'tent');

    await dragTo(tester, find.text('Sapin'), toScreen(tester, other.anchor));

    expect(repo.pieces.where((p) => p.modelId == 'tree').single.slotId, isNull);
    expect(find.textContaining('Pas ici'), findsOneWidget);
    expect(find.text('0 / 38 pièces'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets(
    'collection : la première scène est visible, les autres sont « ? »',
    (tester) async {
      tester.view.physicalSize =
          const Size(360, 1400) * 3; // assez haut pour les 8 tuiles
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final service = SceneService(
        repository: _MemoryPieces(),
        coinService: _FakeCoins(),
        loadAsset: (p) async => assets[p]!,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sceneServiceProvider.overrideWithValue(service)],
          child: const MaterialApp(home: SceneGalleryScreen()),
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.textContaining('La forêt des archers'), findsOneWidget);
      expect(find.text('?'), findsNWidgets(sceneOrder.length - 1));
      expect(
        find.text('0 / ${sceneOrder.length} scènes terminées'),
        findsOneWidget,
      );
      expect(find.textContaining('Village'), findsNothing); // contenu caché

      await tester.tap(find.text('?').first);
      await tester.pump();
      expect(
        find.textContaining('Termine la scène précédente'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets('indice : met en avant les repères du modèle choisi', (
    tester,
  ) async {
    final (_, def) = await pumpScene(tester, const Size(412, 915));
    await tester.tap(find.text('Sapin'));
    await tester.pump();
    expect(find.textContaining('Glisse « Sapin »'), findsOneWidget);
    await tester.tap(find.byType(ActionChip));
    await tester.pump(const Duration(milliseconds: 100));
    final highlighted = tester
        .widgetList<SlotMarker>(find.byType(SlotMarker))
        .where((m) => m.highlighted)
        .length;
    expect(
      highlighted,
      def.slotCount('tree'),
    ); // tous les emplacements de sapin
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 6)); // l'indice s'éteint
  });
}
