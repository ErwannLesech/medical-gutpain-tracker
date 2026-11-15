import 'dart:math';
import 'dart:ui';

import '../models/scene_piece.dart';

/// Rectangle en pixels de l'image de scène
class SceneRect {
  final double x, y, w, h;
  const SceneRect(this.x, this.y, this.w, this.h);

  factory SceneRect.fromJson(Map<String, dynamic> j) => SceneRect(
    (j['x'] as num).toDouble(),
    (j['y'] as num).toDouble(),
    (j['w'] as num).toDouble(),
    (j['h'] as num).toDouble(),
  );
}

/// Modèle 3D utilisable dans une scène (nom affiché + prix en Catcoins)
class SceneModelInfo {
  final String id;
  final String name;
  final int price;
  const SceneModelInfo({
    required this.id,
    required this.name,
    required this.price,
  });
}

/// Emplacement d'une scène : où se pose un modèle donné
class SceneSlot {
  final String id;
  final String model;

  /// Cadre du sprite dans l'image de scène
  final SceneRect rect;

  /// Ancre = centre de la base de la pièce (là où s'affiche le repère)
  final Offset anchor;

  /// Emplacements qui doivent être remplis avant (ex: le toit sur le plancher)
  final List<String> requires;

  const SceneSlot({
    required this.id,
    required this.model,
    required this.rect,
    required this.anchor,
    this.requires = const [],
  });

  factory SceneSlot.fromJson(Map<String, dynamic> j) => SceneSlot(
    id: j['id'] as String,
    model: j['model'] as String,
    rect: SceneRect.fromJson(j),
    anchor: Offset((j['ax'] as num).toDouble(), (j['ay'] as num).toDouble()),
    requires: (j['requires'] as List? ?? const []).cast<String>(),
  );
}

/// Définition d'une scène (générée par tool/scene_render)
class SceneDef {
  final String id;
  final String name;
  final String emoji;
  final double width;
  final double height;
  final List<Color> background;
  final SceneRect reference;
  final SceneRect? terrain;
  final Offset? petSpot;
  final Map<String, SceneModelInfo> models;
  final List<String> starter;

  /// Animaux proposés quand la scène est terminée
  final List<String> petChoices;

  /// Emplacements dans l'ordre d'affichage (du fond vers l'avant)
  final List<SceneSlot> slots;

  const SceneDef({
    required this.id,
    required this.name,
    required this.emoji,
    required this.width,
    required this.height,
    required this.background,
    required this.reference,
    required this.terrain,
    required this.petSpot,
    required this.models,
    required this.starter,
    this.petChoices = const [],
    required this.slots,
  });

  factory SceneDef.fromJson(Map<String, dynamic> j) {
    Color parse(String hex) =>
        Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
    final models = <String, SceneModelInfo>{};
    (j['models'] as Map<String, dynamic>).forEach((id, v) {
      final m = v as Map<String, dynamic>;
      models[id] = SceneModelInfo(
        id: id,
        name: m['name'] as String,
        price: m['price'] as int,
      );
    });
    final pet = j['petSpot'] as Map<String, dynamic>?;
    return SceneDef(
      id: j['id'] as String,
      name: j['name'] as String,
      emoji: j['emoji'] as String? ?? '🏝️',
      width: (j['width'] as num).toDouble(),
      height: (j['height'] as num).toDouble(),
      background: (j['background'] as List? ?? const ['#E8F1EC', '#F6EEDD'])
          .cast<String>()
          .map(parse)
          .toList(),
      reference: SceneRect.fromJson(j['reference'] as Map<String, dynamic>),
      terrain: j['terrain'] == null
          ? null
          : SceneRect.fromJson(j['terrain'] as Map<String, dynamic>),
      petSpot: pet == null
          ? null
          : Offset((pet['x'] as num).toDouble(), (pet['y'] as num).toDouble()),
      models: models,
      starter: (j['starter'] as List? ?? const []).cast<String>(),
      petChoices: (j['pets'] as List? ?? const []).cast<String>(),
      slots: (j['slots'] as List)
          .map((s) => SceneSlot.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  String get basePath => 'assets/scenes/$id';
  String get referenceImage => '$basePath/reference.webp';
  String get terrainImage => '$basePath/terrain.webp';
  String slotImage(SceneSlot s) => '$basePath/slots/${s.id}.webp';
  String iconImage(String model) => '$basePath/icons/$model.webp';

  SceneModelInfo model(String id) =>
      models[id] ?? SceneModelInfo(id: id, name: id, price: 10);

  int slotCount(String model) => slots.where((s) => s.model == model).length;
}

/// Animal (Cube Pets) qui vient habiter une scène terminée
class PetDef {
  final String id;
  final String name;
  final double w, h;

  /// Ancre (centre de la base) dans l'image de l'animal
  final Offset anchor;

  const PetDef({
    required this.id,
    required this.name,
    required this.w,
    required this.h,
    required this.anchor,
  });

  factory PetDef.fromJson(Map<String, dynamic> j) => PetDef(
    id: j['id'] as String,
    name: j['name'] as String,
    w: (j['w'] as num).toDouble(),
    h: (j['h'] as num).toDouble(),
    anchor: Offset((j['ax'] as num).toDouble(), (j['ay'] as num).toDouble()),
  );

  String get image => 'assets/scenes/pets/$id.webp';
  String get icon => 'assets/scenes/pets/icons/$id.webp';
}

/// Modèle de la scène flouté, découpé en quadrillage : on peut dévoiler
/// une zone à la fois contre des Catcoins. Les zones dévoilées sont retrouvées
/// dans le registre des Catcoins (une dépense par zone), sans table dédiée.
class SceneReveal {
  SceneReveal._();

  static const int columns = 4;
  static const int rows = 2;
  static const int cells = columns * rows;

  static String refKeyPrefix(String sceneId) => 'reveal:$sceneId:';

  static String refKey(String sceneId, int cell) =>
      '${refKeyPrefix(sceneId)}$cell';

  /// Zones dévoilées d'après les clés du registre
  static Set<int> parse(String sceneId, Iterable<String> refKeys) {
    final prefix = refKeyPrefix(sceneId);
    return {
      for (final key in refKeys)
        if (key.startsWith(prefix))
          if (int.tryParse(key.substring(prefix.length)) case final cell?)
            if (cell >= 0 && cell < cells) cell,
    };
  }
}

/// État d'avancement d'une scène, calculé à partir des pièces possédées.
/// Classe pure (sans base de données) : toute la logique du puzzle est ici.
class ScenePuzzleState {
  static const String petPrefix = 'pet:';
  static const String petSlot = 'pet';

  /// Distance max (pixels de scène) entre le doigt et le repère d'un emplacement
  static const double dropTolerance = 80;

  final SceneDef def;
  final Map<String, ScenePiece> placedBySlot;
  final Map<String, List<ScenePiece>> inventory;
  final Map<String, int> ownedByModel;
  final ScenePiece? pet;

  ScenePuzzleState._(
    this.def,
    this.placedBySlot,
    this.inventory,
    this.ownedByModel,
    this.pet,
  );

  factory ScenePuzzleState(SceneDef def, List<ScenePiece> pieces) {
    final placed = <String, ScenePiece>{};
    final inventory = <String, List<ScenePiece>>{};
    final owned = <String, int>{};
    ScenePiece? pet;
    final slotIds = {for (final s in def.slots) s.id};
    for (final p in pieces) {
      if (p.modelId.startsWith(petPrefix)) {
        pet = p;
        continue;
      }
      owned[p.modelId] = (owned[p.modelId] ?? 0) + 1;
      if (p.slotId != null && slotIds.contains(p.slotId)) {
        placed[p.slotId!] = p;
      } else {
        inventory.putIfAbsent(p.modelId, () => []).add(p);
      }
    }
    return ScenePuzzleState._(def, placed, inventory, owned, pet);
  }

  int get totalSlots => def.slots.length;
  int get placedCount => placedBySlot.length;
  bool get isComplete => placedCount >= totalSlots;
  double get progress => totalSlots == 0 ? 0 : placedCount / totalSlots;
  int get inventoryCount => inventory.values.fold(0, (n, l) => n + l.length);

  String? get petId => pet?.modelId.substring(petPrefix.length);

  bool isPlaced(SceneSlot slot) => placedBySlot.containsKey(slot.id);

  /// Un emplacement est disponible s'il est vide et que ses supports sont posés
  bool isAvailable(SceneSlot slot) =>
      !isPlaced(slot) && slot.requires.every(placedBySlot.containsKey);

  List<SceneSlot> get availableSlots => def.slots.where(isAvailable).toList();

  /// Exemplaires encore à obtenir, par modèle (emplacements - possédés)
  Map<String, int> get missingByModel {
    final out = <String, int>{};
    for (final s in def.slots) {
      out[s.model] = (out[s.model] ?? 0) + 1;
    }
    out.updateAll((model, needed) => needed - (ownedByModel[model] ?? 0));
    out.removeWhere((_, n) => n <= 0);
    return out;
  }

  bool get hasEverything => missingByModel.isEmpty;

  /// Emplacements libres qui acceptent ce modèle
  List<SceneSlot> slotsFor(String model) =>
      availableSlots.where((s) => s.model == model).toList();

  /// Emplacement visé par un dépôt au point [p] (coordonnées de scène).
  /// Seuls les emplacements disponibles du même modèle sont acceptés.
  SceneSlot? findDropSlot(
    String model,
    Offset p, {
    double tolerance = dropTolerance,
  }) {
    SceneSlot? best;
    var bestDist = double.infinity;
    for (final s in slotsFor(model)) {
      final d = (s.anchor - p).distance;
      if (d <= tolerance && d < bestDist) {
        best = s;
        bestDist = d;
      }
    }
    return best;
  }

  /// Probabilité minimale qu'un tirage du journal donne une pièce nouvelle
  static const double minNewProbability = 0.5;

  /// Tirage du journal : pièce nouvelle ou doublon.
  ///
  /// Chance de nouveauté = max(part des pièces manquantes, 50 %), comme pour
  /// les chats et les plats. Un doublon est un modèle déjà complet (on a
  /// toutes ses pièces) ; il sera transformé en Catcoins.
  /// Retourne (modèle, estDoublon), ou null si rien n'est tirable.
  (String, bool)? drawForJournal(Random random) {
    final missing = missingByModel;
    final missingTotal = missing.values.fold(0, (a, b) => a + b);
    final complete = <String, int>{};
    for (final s in def.slots) {
      if (!missing.containsKey(s.model)) {
        complete[s.model] = (complete[s.model] ?? 0) + 1;
      }
    }
    if (missingTotal == 0 && complete.isEmpty) return null;

    final newChance = complete.isEmpty
        ? 1.0
        : missingTotal == 0
        ? 0.0
        : max(missingTotal / totalSlots, minNewProbability);
    if (random.nextDouble() < newChance) {
      return (drawMissingModel(random)!, false);
    }
    return (_weightedPick(complete, random), true);
  }

  static String _weightedPick(Map<String, int> weights, Random random) {
    final total = weights.values.fold(0, (a, b) => a + b);
    var r = random.nextInt(total);
    for (final e in weights.entries) {
      if (r < e.value) return e.key;
      r -= e.value;
    }
    return weights.keys.last;
  }

  /// Tire un modèle manquant, pondéré par le nombre d'exemplaires manquants.
  /// Retourne null si tout est déjà possédé.
  String? drawMissingModel(Random random) {
    final missing = missingByModel;
    if (missing.isEmpty) return null;
    return _weightedPick(missing, random);
  }
}
