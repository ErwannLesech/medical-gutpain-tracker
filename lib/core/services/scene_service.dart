import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../database/repositories/scene_piece_repository.dart';
import '../models/coin_transaction.dart';
import '../models/scene_piece.dart';
import 'coin_service.dart';
import 'scene_puzzle.dart';

/// Ordre des scènes : une scène terminée ouvre la suivante.
/// Pour en ajouter une : la rendre avec tool/scene_render puis l'ajouter ici.
const List<String> sceneOrder = [
  'forest', // La forêt des archers
  'holiday', // Le village de Noël
  'pirate', // L'île au trésor (le tigre peut s'y installer)
  'arcade', // La salle d'arcade
  'dungeon', // Le donjon secret
  'platformer', // Le monde des plateformes
  'arena', // L'arène des champions
  'fantasy', // Le bourg du royaume
];

/// Pièce tirée via le journal (nouvelle, ou doublon transformé en Catcoins)
class ScenePieceDrawResult {
  final SceneDef scene;
  final SceneModelInfo model;
  final bool isDuplicate;
  final int coins;

  const ScenePieceDrawResult({
    required this.scene,
    required this.model,
    this.isDuplicate = false,
    this.coins = 0,
  });
}

/// Une scène dans la collection
class SceneStatus {
  final SceneDef def;
  final ScenePuzzleState state;

  /// Débloquée : la scène précédente est terminée (ou c'est la première)
  final bool unlocked;

  const SceneStatus({
    required this.def,
    required this.state,
    required this.unlocked,
  });

  /// Terminée : toutes les pièces posées et l'animal choisi
  bool get isFinished => state.isComplete && state.pet != null;
}

/// Vue d'ensemble de la scène en cours (carte d'accueil)
class SceneOverview {
  final SceneDef def;
  final ScenePuzzleState state;

  /// Toutes les scènes disponibles sont terminées
  final bool allDone;

  const SceneOverview({
    required this.def,
    required this.state,
    required this.allDone,
  });
}

/// Service des scènes puzzle (modèles 3D Kenney pré-rendus)
class SceneService {
  final ScenePieceRepository _repo;
  final CoinService _coins;
  final Future<String> Function(String path) _loadAsset;
  final Random _random;

  SceneService({
    required ScenePieceRepository repository,
    required CoinService coinService,
    Future<String> Function(String path)? loadAsset,
    Random? random,
  }) : _repo = repository,
       _coins = coinService,
       _loadAsset = loadAsset ?? rootBundle.loadString,
       _random = random ?? Random();

  final Map<String, SceneDef> _defs = {};
  List<PetDef>? _pets;

  Future<SceneDef> loadScene(String id) async {
    return _defs[id] ??= SceneDef.fromJson(
      jsonDecode(await _loadAsset('assets/scenes/$id/scene.json'))
          as Map<String, dynamic>,
    );
  }

  Future<List<PetDef>> loadPets() async {
    return _pets ??=
        ((jsonDecode(await _loadAsset('assets/scenes/pets/pets.json'))
                    as Map<String, dynamic>)['pets']
                as List)
            .map((p) => PetDef.fromJson(p as Map<String, dynamic>))
            .toList();
  }

  Future<ScenePuzzleState> getState(String sceneId) async {
    final def = await loadScene(sceneId);
    return ScenePuzzleState(def, await _repo.getForScene(sceneId));
  }

  /// Scène en cours : la première dont les emplacements ne sont pas tous
  /// remplis ou dont l'animal n'a pas encore été choisi.
  Future<SceneOverview> currentScene() async {
    for (final id in sceneOrder) {
      final state = await getState(id);
      if (!state.isComplete || state.pet == null) {
        return SceneOverview(def: state.def, state: state, allDone: false);
      }
    }
    final last = await getState(sceneOrder.last);
    return SceneOverview(def: last.def, state: last, allDone: true);
  }

  /// Offre les pièces de départ d'une scène (une seule fois)
  Future<void> ensureStarterPieces(String sceneId) async {
    final def = await loadScene(sceneId);
    for (var i = 0; i < def.starter.length; i++) {
      await _repo.addIfAbsent(
        ScenePiece(
          sceneId: sceneId,
          modelId: def.starter[i],
          source: ScenePieceSource.starter,
          refKey: 'starter:$sceneId:$i',
          acquiredAt: DateTime.now(),
        ),
      );
    }
  }

  /// Toutes les scènes, dans l'ordre, avec leur état de déblocage
  Future<List<SceneStatus>> allScenes() async {
    final out = <SceneStatus>[];
    var previousFinished = true;
    for (final id in sceneOrder) {
      final state = await getState(id);
      final status = SceneStatus(
        def: state.def,
        state: state,
        unlocked: previousFinished,
      );
      out.add(status);
      previousFinished = status.isFinished;
    }
    return out;
  }

  static String journalRefKey(DateTime date) =>
      'journal:${CoinService.dayKey(date)}';

  /// Un tirage de scène peut-il être fait pour le journal de cette date ?
  Future<bool> canDrawForDate(DateTime date, {DateTime? now}) async {
    if (CoinService.journalAgeDays(date, now: now) >
        CoinRewards.dailyJournalMaxAgeDays) {
      return false;
    }
    if (await _repo.hasRefKey(journalRefKey(date))) return false;
    if (await _coins.hasRefKey(CoinService.duplicateRefKey('scene', date))) {
      return false;
    }
    final current = await currentScene();
    return !current.allDone;
  }

  /// Tirage du journal : une pièce nouvelle pour la scène en cours, ou un
  /// doublon d'un modèle déjà complet, transformé en Catcoins.
  Future<ScenePieceDrawResult?> drawForDate(
    DateTime date, {
    DateTime? now,
  }) async {
    if (!await canDrawForDate(date, now: now)) return null;
    final current = await currentScene();
    final draw = current.state.drawForJournal(_random);
    if (draw == null) return null;
    final (model, isDuplicate) = draw;
    final info = current.def.model(model);

    if (isDuplicate) {
      final coins = await _coins.awardDuplicate(
        'scene',
        date,
        amount: CoinRewards.sceneDuplicate(info.price),
      );
      if (coins == 0) return null;
      return ScenePieceDrawResult(
        scene: current.def,
        model: info,
        isDuplicate: true,
        coins: coins,
      );
    }

    final added = await _repo.addIfAbsent(
      ScenePiece(
        sceneId: current.def.id,
        modelId: model,
        source: ScenePieceSource.journal,
        refKey: journalRefKey(date),
        acquiredAt: DateTime.now(),
      ),
    );
    if (!added) return null;
    return ScenePieceDrawResult(scene: current.def, model: info);
  }

  /// Achète un exemplaire manquant d'un modèle. Retourne false si le solde
  /// est insuffisant ou si le modèle n'est plus nécessaire.
  Future<bool> buy(String sceneId, String modelId) async {
    final state = await getState(sceneId);
    if ((state.missingByModel[modelId] ?? 0) <= 0) return false;
    final ref =
        'shop:$sceneId:$modelId:${DateTime.now().microsecondsSinceEpoch}';
    return _repo.buy(
      ScenePiece(
        sceneId: sceneId,
        modelId: modelId,
        source: ScenePieceSource.shop,
        refKey: ref,
        acquiredAt: DateTime.now(),
      ),
      CoinTransaction(
        amount: -state.def.model(modelId).price,
        reason: CoinReason.purchase,
        refKey: ref,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Pose une pièce sur un emplacement (vérifie que le modèle correspond)
  Future<bool> place(
    ScenePuzzleState state,
    ScenePiece piece,
    SceneSlot slot,
  ) async {
    if (piece.modelId != slot.model || !state.isAvailable(slot)) return false;
    return _repo.place(piece.id, slot.id);
  }

  /// Indice payant (1 Catcoin)
  Future<bool> buyHint(String sceneId) => _coins.spend(
    CoinRewards.sceneHint,
    'hint:$sceneId:${DateTime.now().microsecondsSinceEpoch}',
  );

  /// Zones déjà dévoilées du modèle flouté d'une scène
  Future<Set<int>> revealedCells(String sceneId) async => SceneReveal.parse(
    sceneId,
    await _coins.refKeysWithPrefix(SceneReveal.refKeyPrefix(sceneId)),
  );

  /// Dévoile une zone du modèle contre des Catcoins. Retourne false si le
  /// solde est insuffisant ou si la zone est déjà dévoilée (la clé est unique
  /// par scène et par zone : on ne paie jamais deux fois).
  Future<bool> revealCell(String sceneId, int cell) {
    if (cell < 0 || cell >= SceneReveal.cells) return Future.value(false);
    return _coins.spend(
      CoinRewards.sceneReveal,
      SceneReveal.refKey(sceneId, cell),
    );
  }

  /// Choisit l'animal qui vient habiter la scène terminée (une seule fois)
  Future<bool> choosePet(String sceneId, String petId) async {
    final state = await getState(sceneId);
    if (!state.isComplete) return false;
    return _repo.addIfAbsent(
      ScenePiece(
        sceneId: sceneId,
        modelId: '${ScenePuzzleState.petPrefix}$petId',
        slotId: ScenePuzzleState.petSlot,
        source: ScenePieceSource.reward,
        refKey: 'pet:$sceneId',
        acquiredAt: DateTime.now(),
      ),
    );
  }
}
