import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/scene_piece.dart';
import '../../core/services/coin_service.dart';
import '../../core/services/providers.dart';
import '../../core/services/scene_puzzle.dart';
import '../../core/services/scene_service.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/theme/colors.dart';
import '../../shared/widgets/coin_widgets.dart';
import 'scene_widgets.dart';

/// Puzzle de scène : glisser les pièces du tiroir à leur place dans la scène.
class ScenePuzzleScreen extends ConsumerStatefulWidget {
  /// Scène à ouvrir (par défaut : la scène en cours)
  final String? sceneId;

  const ScenePuzzleScreen({super.key, this.sceneId});

  @override
  ConsumerState<ScenePuzzleScreen> createState() => _ScenePuzzleScreenState();
}

class _ScenePuzzleScreenState extends ConsumerState<ScenePuzzleScreen> {
  /// Erreurs avant qu'un indice devienne gratuit
  static const int freeHintAfterMistakes = 3;

  /// Taille du repère et tolérance de dépôt, en points d'écran
  static const double markerScreenSize = 30;
  static const double dropScreenTolerance = 30;

  final _sceneKey = GlobalKey();
  final _viewer = TransformationController();

  ScenePuzzleState? _state;
  List<PetDef> _pets = const [];
  String? _selectedModel;
  String? _hintModel;
  Timer? _hintTimer;
  final Map<String, int> _mistakes = {};
  final Set<String> _justPlaced = {};
  double _fitScale = 1;
  bool _initialZoomDone = false;
  bool _petDialogShown = false;

  /// Zoom d'ouverture sur téléphone en portrait
  static const double initialZoom = 1.6;

  SceneService get _service => ref.read(sceneServiceProvider);

  @override
  void initState() {
    super.initState();
    _load(first: true);
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _viewer.dispose();
    super.dispose();
  }

  Future<void> _load({bool first = false}) async {
    final id = widget.sceneId ?? (await _service.currentScene()).def.id;
    if (first) {
      await _service.ensureStarterPieces(id);
      _pets = await _service.loadPets();
    }
    final state = await _service.getState(id);
    if (!mounted) return;
    setState(() {
      _state = state;
      if (_selectedModel != null &&
          !state.inventory.containsKey(_selectedModel)) {
        _selectedModel = null;
      }
    });
    if (state.isComplete && state.pet == null && !_petDialogShown) {
      _petDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _choosePet());
    }
  }

  /// Écran en portrait : la scène (plus large que haute) n'occuperait qu'une
  /// bande. On ouvre donc zoomé, centré sur le terrain.
  void _applyInitialZoom(SceneDef def, Size viewport) {
    if (!mounted) return;
    final sceneAspect = def.width / def.height;
    final viewAspect = viewport.width / viewport.height;
    if (viewAspect >= sceneAspect) return; // paysage / tablette : tout tient
    final s = math.min(initialZoom, sceneAspect / viewAspect);
    final focus = def.terrain == null
        ? Offset(def.width / 2, def.height / 2)
        // un peu au-dessus du centre : le bas du terrain n'est que sa tranche
        : Offset(
            def.terrain!.x + def.terrain!.w / 2,
            def.terrain!.y + def.terrain!.h * 0.42,
          );
    final offset = Offset(
      (viewport.width - def.width * _fitScale) / 2,
      (viewport.height - def.height * _fitScale) / 2,
    );
    final f = offset + focus * _fitScale;
    final c = viewport.center(Offset.zero);
    _viewer.value = Matrix4.diagonal3Values(s, s, 1)
      ..setTranslationRaw(c.dx - s * f.dx, c.dy - s * f.dy, 0);
  }

  /// Échelle totale scène -> écran (ajustement + zoom de l'utilisateur)
  double get _screenScale => _fitScale * _viewer.value.getMaxScaleOnAxis();

  // ---------------------------------------------------------------------------
  // Dépôt d'une pièce
  // ---------------------------------------------------------------------------

  Future<void> _onDrop(ScenePiece piece, Offset globalPointer) async {
    final state = _state;
    final box = _sceneKey.currentContext?.findRenderObject() as RenderBox?;
    if (state == null || box == null) return;
    final local = box.globalToLocal(globalPointer);
    final tolerance = math.max(
      ScenePuzzleState.dropTolerance * 0.75,
      dropScreenTolerance / _screenScale,
    );
    final slot = state.findDropSlot(piece.modelId, local, tolerance: tolerance);

    if (slot != null) {
      final ok = await _service.place(state, piece, slot);
      if (!ok) return;
      HapticService.success();
      _mistakes.remove(piece.modelId);
      if (_hintModel == piece.modelId) _hintModel = null;
      _justPlaced.add(slot.id);
      Timer(
        const Duration(milliseconds: 900),
        () => _justPlaced.remove(slot.id),
      );
      await _load();
      ref.invalidate(currentSceneProvider);
      ref.invalidate(scenesProvider);
      return;
    }

    // Raté : on ne compte une erreur que si la pièce a été posée sur un repère
    final nearMarker = state.availableSlots.any(
      (s) => (s.anchor - local).distance <= tolerance,
    );
    HapticService.light();
    if (nearMarker) {
      setState(
        () => _mistakes[piece.modelId] = (_mistakes[piece.modelId] ?? 0) + 1,
      );
    }
    _toast(
      nearMarker
          ? 'Pas ici… regarde bien le modèle 👀'
          : 'Dépose la pièce sur un repère ⭕',
    );
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1600),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 140),
        ),
      );
  }

  // ---------------------------------------------------------------------------
  // Indice, boutique, modèle, animal
  // ---------------------------------------------------------------------------

  bool get _hintIsFree =>
      (_mistakes[_selectedModel] ?? 0) >= freeHintAfterMistakes;

  Future<void> _useHint() async {
    final state = _state;
    final model = _selectedModel;
    if (state == null || model == null) return;
    if (state.slotsFor(model).isEmpty) {
      _toast('Pose d\'abord ce qui doit se trouver en dessous 🧱');
      return;
    }
    if (!_hintIsFree) {
      final paid = await _service.buyHint(state.def.id);
      if (!paid) {
        _toast('Il faut ${CoinRewards.sceneHint} Catcoin pour un indice');
        return;
      }
    }
    HapticService.medium();
    setState(() {
      _hintModel = model;
      _mistakes.remove(model);
    });
    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _hintModel = null);
    });
  }

  Future<void> _openShop() async {
    final state = _state;
    if (state == null) return;
    final bought = await SceneShopSheet.show(context, state);
    if (bought) {
      await _load();
      ref.invalidate(currentSceneProvider);
      ref.invalidate(scenesProvider);
    }
  }

  Future<void> _choosePet() async {
    final state = _state;
    if (state == null || !mounted) return;
    final index = sceneOrder.indexOf(state.def.id);
    final petId = await ScenePetChooser.show(
      context,
      state.def,
      _pets,
      hasNextScene: index >= 0 && index < sceneOrder.length - 1,
    );
    if (petId == null) return;
    await _service.choosePet(state.def.id, petId);
    HapticService.success();
    await _load();
    ref.invalidate(currentSceneProvider);
    ref.invalidate(scenesProvider);
  }

  // ---------------------------------------------------------------------------
  // Construction
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final state = _state;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          state == null ? 'Scène' : '${state.def.emoji} ${state.def.name}',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (state != null) ...[
            IconButton(
              tooltip: 'Le modèle',
              icon: const Icon(Icons.image_outlined),
              onPressed: () => showSceneReference(context, state.def),
            ),
            IconButton(
              tooltip: 'Boutique',
              icon: const Icon(Icons.storefront_outlined),
              onPressed: _openShop,
            ),
          ],
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CoinBalanceChip(),
          ),
        ],
      ),
      body: state == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _ProgressHeader(state: state),
                Expanded(child: _buildScene(state)),
                _buildTray(state),
              ],
            ),
    );
  }

  Widget _buildScene(ScenePuzzleState state) {
    final def = state.def;
    return DragTarget<ScenePiece>(
      onAcceptWithDetails: (details) => _onDrop(details.data, details.offset),
      builder: (context, candidates, _) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: def.background,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            _fitScale = math.min(
              constraints.maxWidth / def.width,
              constraints.maxHeight / def.height,
            );
            if (!_initialZoomDone) {
              _initialZoomDone = true;
              final viewport = constraints.biggest;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _applyInitialZoom(def, viewport),
              );
            }
            return InteractiveViewer(
              transformationController: _viewer,
              minScale: 1,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(80),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    key: _sceneKey,
                    width: def.width,
                    height: def.height,
                    child: _buildSceneLayers(state),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSceneLayers(ScenePuzzleState state) {
    final def = state.def;
    final pet = state.petId == null
        ? null
        : _pets.where((p) => p.id == state.petId).firstOrNull;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (def.terrain != null)
          Positioned(
            left: def.terrain!.x,
            top: def.terrain!.y,
            width: def.terrain!.w,
            height: def.terrain!.h,
            child: Image.asset(
              def.terrainImage,
              fit: BoxFit.fill,
              gaplessPlayback: true,
            ),
          ),
        // Pièces posées, du fond vers l'avant
        for (final slot in def.slots)
          if (state.isPlaced(slot))
            Positioned(
              key: ValueKey('slot-${slot.id}'),
              left: slot.rect.x,
              top: slot.rect.y,
              width: slot.rect.w,
              height: slot.rect.h,
              child: _PlacedPiece(
                asset: def.slotImage(slot),
                animate: _justPlaced.contains(slot.id),
                anchor: Alignment(
                  (slot.anchor.dx - slot.rect.x) / slot.rect.w * 2 - 1,
                  (slot.anchor.dy - slot.rect.y) / slot.rect.h * 2 - 1,
                ),
              ),
            ),
        if (pet != null && def.petSpot != null)
          Positioned(
            left: def.petSpot!.dx - pet.anchor.dx,
            top: def.petSpot!.dy - pet.anchor.dy,
            width: pet.w,
            height: pet.h,
            child: Image.asset(pet.image, fit: BoxFit.fill),
          ),
        // Repères des emplacements libres, toujours au premier plan
        AnimatedBuilder(
          animation: _viewer,
          builder: (context, _) {
            final size = markerScreenSize / _screenScale;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                for (final slot in state.availableSlots)
                  Positioned(
                    left: slot.anchor.dx - size * 0.7,
                    top: slot.anchor.dy - size * 0.35,
                    width: size * 1.4,
                    height: size * 0.7,
                    child: Center(
                      child: SlotMarker(
                        size: size,
                        highlighted: _hintModel == slot.model,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTray(ScenePuzzleState state) {
    final theme = Theme.of(context);
    final models = state.inventory.keys.toList()
      ..sort(
        (a, b) => state.def.model(a).name.compareTo(state.def.model(b).name),
      );

    Widget content;
    if (state.isComplete) {
      final pet = state.petId == null
          ? null
          : _pets.where((p) => p.id == state.petId).firstOrNull;
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Text('🌟', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                pet == null
                    ? 'Scène terminée ! Choisis son habitant.'
                    : 'Scène terminée, avec ${pet.name.toLowerCase()} 💛',
                style: theme.textTheme.titleSmall,
              ),
            ),
            if (pet == null)
              FilledButton(onPressed: _choosePet, child: const Text('Choisir')),
          ],
        ),
      );
    } else if (models.isEmpty) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Text('🧺', style: TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tiroir vide. Une pièce t\'attend à chaque journal, ou passe à la boutique.',
                style: theme.textTheme.bodySmall,
              ),
            ),
            IconButton.filledTonal(
              onPressed: _openShop,
              icon: const Icon(Icons.storefront_outlined),
            ),
          ],
        ),
      );
    } else {
      content = ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: models.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final model = models[i];
          final pieces = state.inventory[model]!;
          return _TrayPiece(
            key: ValueKey('tray-$model'),
            piece: pieces.first,
            count: pieces.length,
            name: state.def.model(model).name,
            icon: state.def.iconImage(model),
            selected: _selectedModel == model,
            onSelect: () => setState(() => _selectedModel = model),
          );
        },
      );
    }

    return Material(
      color: theme.colorScheme.surface,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hauteur fixe : la scène ne doit pas bouger quand on prend une pièce
            if (!state.isComplete && models.isNotEmpty)
              Container(
                height: 48,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedModel == null
                            ? 'Glisse une pièce sur son repère ⭕'
                            : 'Glisse « ${state.def.model(_selectedModel!).name} » sur son repère',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_selectedModel != null)
                      ActionChip(
                        avatar: const Text('💡'),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _hintIsFree
                                  ? 'Indice offert'
                                  : 'Indice  ${CoinRewards.sceneHint}',
                            ),
                            if (!_hintIsFree) ...[
                              const SizedBox(width: 2),
                              const CatCoinIcon(size: 14),
                            ],
                          ],
                        ),
                        onPressed: _useHint,
                      ),
                  ],
                ),
              ),
            SizedBox(height: 104, child: content),
          ],
        ),
      ),
    );
  }
}

/// Bandeau d'avancement : « 12 / 38 pièces posées »
class _ProgressHeader extends StatelessWidget {
  final ScenePuzzleState state;
  const _ProgressHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.progress,
                minHeight: 8,
                backgroundColor: WakyColors.primary.withValues(alpha: 0.12),
                color: WakyColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${state.placedCount} / ${state.totalSlots} pièces',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Pièce qui vient d'être posée : petit rebond depuis sa base
class _PlacedPiece extends StatelessWidget {
  final String asset;
  final bool animate;
  final Alignment anchor;

  const _PlacedPiece({
    required this.asset,
    required this.animate,
    required this.anchor,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(asset, fit: BoxFit.fill, gaplessPlayback: true);
    if (!animate) return image;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.elasticOut,
      builder: (context, t, child) =>
          Transform.scale(scale: t, alignment: anchor, child: child),
      child: image,
    );
  }
}

/// Pièce du tiroir, à glisser sur la scène
class _TrayPiece extends StatelessWidget {
  final ScenePiece piece;
  final int count;
  final String name;
  final String icon;
  final bool selected;
  final VoidCallback onSelect;

  const _TrayPiece({
    super.key,
    required this.piece,
    required this.count,
    required this.name,
    required this.icon,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 84,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? WakyColors.primary.withValues(alpha: 0.12)
            : Colors.grey.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? WakyColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModelIcon(asset: icon, size: 52),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (count > 1)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: WakyColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '×$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return Draggable<ScenePiece>(
      data: piece,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () {
        HapticService.light();
        onSelect();
      },
      // La pièce flotte au-dessus du doigt : sa base est au niveau du doigt
      feedback: Material(
        type: MaterialType.transparency,
        child: Transform.translate(
          offset: const Offset(-40, -86),
          child: ModelIcon(asset: icon, size: 80),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: tile),
      child: GestureDetector(onTap: onSelect, child: tile),
    );
  }
}
