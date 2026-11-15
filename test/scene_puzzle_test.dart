import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:waky_gut/core/models/scene_piece.dart';
import 'package:waky_gut/core/services/scene_puzzle.dart';
import 'package:waky_gut/core/services/scene_service.dart';

SceneDef loadForest() => SceneDef.fromJson(
  jsonDecode(File('assets/scenes/forest/scene.json').readAsStringSync())
      as Map<String, dynamic>,
);

var _ref = 0;
ScenePiece piece(String model, {String? slot}) => ScenePiece(
  sceneId: 'forest',
  modelId: model,
  slotId: slot,
  source: ScenePieceSource.shop,
  refKey: 'test:${_ref++}',
  acquiredAt: DateTime(2026, 11, 15),
);

SceneDef loadScene(String id) => SceneDef.fromJson(
  jsonDecode(File('assets/scenes/$id/scene.json').readAsStringSync())
      as Map<String, dynamic>,
);

void main() {
  final def = loadForest();

  group('Toutes les scènes préparées', () {
    final pets =
        ((jsonDecode(File('assets/scenes/pets/pets.json').readAsStringSync())
                    as Map)['pets']
                as List)
            .map((p) => (p as Map)['id'] as String)
            .toSet();
    final pubspec = File('pubspec.yaml').readAsStringSync();

    for (final id in sceneOrder) {
      test('$id : images, noms, prix, supports et animaux', () {
        final s = loadScene(id);
        expect(s.slots.length, greaterThanOrEqualTo(20));
        final order = {
          for (var i = 0; i < s.slots.length; i++) s.slots[i].id: i,
        };
        for (final slot in s.slots) {
          expect(
            s.models.containsKey(slot.model),
            isTrue,
            reason: '$id: ${slot.model}',
          );
          expect(
            File(s.slotImage(slot)).existsSync(),
            isTrue,
            reason: '$id: ${slot.id}',
          );
          expect(
            File(s.iconImage(slot.model)).existsSync(),
            isTrue,
            reason: '$id: ${slot.model}',
          );
          for (final r in slot.requires) {
            expect(order[r], isNotNull, reason: '$id: ${slot.id} -> $r');
            expect(
              order[r]! < order[slot.id]!,
              isTrue,
              reason: '$id: ${slot.id} après $r',
            );
          }
        }
        for (final starter in s.starter) {
          expect(
            s.models.containsKey(starter),
            isTrue,
            reason: '$id: départ $starter',
          );
        }
        expect(s.petChoices, hasLength(3));
        expect(
          pets.containsAll(s.petChoices),
          isTrue,
          reason: '$id: ${s.petChoices}',
        );
        expect(s.petSpot, isNotNull);
        for (final dir in ['', 'slots/', 'icons/']) {
          expect(
            pubspec.contains('- assets/scenes/$id/$dir\n') ||
                pubspec.contains('- assets/scenes/$id/$dir\r\n'),
            isTrue,
            reason: 'pubspec: assets/scenes/$id/$dir',
          );
        }
      });
    }

    test('chaque animal n\'est proposé que dans une seule scène', () {
      final all = [for (final id in sceneOrder) ...loadScene(id).petChoices];
      expect(all.toSet().length, all.length);
      expect(all, contains('tiger'));
    });
  });

  group('Scène générée (forest)', () {
    test('chaque emplacement a son image et un modèle avec nom et prix', () {
      expect(def.slots, hasLength(38));
      for (final s in def.slots) {
        expect(def.models.containsKey(s.model), isTrue, reason: s.model);
        expect(File(def.slotImage(s)).existsSync(), isTrue, reason: s.id);
        expect(
          File(def.iconImage(s.model)).existsSync(),
          isTrue,
          reason: s.model,
        );
      }
      expect(File(def.referenceImage).existsSync(), isTrue);
    });

    test('un support est toujours affiché avant ce qu\'il porte', () {
      final order = {
        for (var i = 0; i < def.slots.length; i++) def.slots[i].id: i,
      };
      for (final s in def.slots) {
        for (final r in s.requires) {
          expect(order.containsKey(r), isTrue, reason: '${s.id} -> $r');
          expect(order[r]! < order[s.id]!, isTrue, reason: '${s.id} après $r');
        }
      }
    });

    test('animaux proposés en fin de scène et emplacement prévu', () {
      expect(def.petChoices, isNotEmpty);
      expect(def.petSpot, isNotNull);
    });
  });

  group('État du puzzle', () {
    test('tiroir, pièces posées et manquantes', () {
      final state = ScenePuzzleState(def, [
        piece('tree', slot: 'tree1'),
        piece('tree'),
        piece('tent'),
      ]);
      expect(state.placedCount, 1);
      expect(state.inventoryCount, 2);
      expect(state.inventory['tree'], hasLength(1));
      // 2 sapins possédés
      expect(state.missingByModel['tree'], def.slotCount('tree') - 2);
      expect(state.missingByModel.containsKey('tent'), isFalse);
    });

    test(
      'un emplacement porté n\'est disponible qu\'une fois son support posé',
      () {
        final roof = def.slots.firstWhere((s) => s.id == 'roofR');
        var state = ScenePuzzleState(def, []);
        expect(state.isAvailable(roof), isFalse);
        state = ScenePuzzleState(def, [
          piece('building-structure', slot: 'towerR'),
          piece('building-platform', slot: 'deckR'),
        ]);
        expect(state.isAvailable(roof), isTrue);
      },
    );

    test('dépôt : seul le bon modèle, près du repère, est accepté', () {
      final state = ScenePuzzleState(def, []);
      final tent = def.slots.firstWhere((s) => s.id == 'tent');
      expect(
        state.findDropSlot('tent', tent.anchor + const Offset(20, 10))?.id,
        'tent',
      );
      expect(
        state.findDropSlot('tent', tent.anchor + const Offset(300, 0)),
        isNull,
      );
      expect(state.findDropSlot('tree', tent.anchor), isNull);
    });

    test(
      'dépôt d\'une pièce interchangeable : l\'emplacement le plus proche',
      () {
        final state = ScenePuzzleState(def, []);
        final tree3 = def.slots.firstWhere((s) => s.id == 'tree3');
        expect(state.findDropSlot('tree', tree3.anchor)?.id, 'tree3');
      },
    );

    test('le tirage ne donne que des pièces encore nécessaires', () {
      // Tout possédé sauf le toit
      final pieces = [
        for (final s in def.slots)
          if (s.model != 'building-roof') piece(s.model),
      ];
      final state = ScenePuzzleState(def, pieces);
      final random = Random(3);
      for (var i = 0; i < 20; i++) {
        expect(state.drawMissingModel(random), 'building-roof');
      }
      expect(
        ScenePuzzleState(def, [
          ...pieces,
          piece('building-roof'),
        ]).drawMissingModel(random),
        isNull,
      );
    });

    test(
      'journal : tant qu\'aucun modèle n\'est complet, toujours du neuf',
      () {
        final state = ScenePuzzleState(def, [piece('tree')]);
        final random = Random(1);
        for (var i = 0; i < 50; i++) {
          expect(state.drawForJournal(random)!.$2, isFalse);
        }
      },
    );

    test(
      'journal : au moins une chance sur deux d\'avoir du neuf, doublons = modèles complets',
      () {
        // Tout possédé sauf 2 pièces : la chance de neuf tombe au plancher de 50 %
        final owned = [for (final s in def.slots) piece(s.model)];
        owned.removeWhere((p) => p.modelId == 'building-roof');
        owned.remove(owned.firstWhere((p) => p.modelId == 'tent'));
        final state = ScenePuzzleState(def, owned);
        final random = Random(7);
        var fresh = 0;
        const n = 4000;
        for (var i = 0; i < n; i++) {
          final (model, dup) = state.drawForJournal(random)!;
          if (dup) {
            expect(
              state.missingByModel.containsKey(model),
              isFalse,
              reason: 'doublon $model',
            );
          } else {
            fresh++;
            expect(['building-roof', 'tent'], contains(model));
          }
        }
        expect(fresh / n, closeTo(0.5, 0.03));
      },
    );

    test('journal : tout possédé, uniquement des doublons', () {
      final state = ScenePuzzleState(def, [
        for (final s in def.slots) piece(s.model),
      ]);
      final random = Random(2);
      for (var i = 0; i < 30; i++) {
        expect(state.drawForJournal(random)!.$2, isTrue);
      }
    });

    test('scène terminée quand tous les emplacements sont remplis', () {
      final state = ScenePuzzleState(def, [
        for (final s in def.slots) piece(s.model, slot: s.id),
      ]);
      expect(state.isComplete, isTrue);
      expect(state.availableSlots, isEmpty);
      expect(state.progress, 1);
    });

    test('l\'animal choisi n\'est pas compté comme une pièce', () {
      final state = ScenePuzzleState(def, [
        piece('pet:fox', slot: ScenePuzzleState.petSlot),
      ]);
      expect(state.petId, 'fox');
      expect(state.inventoryCount, 0);
      expect(state.placedCount, 0);
    });
  });
}
