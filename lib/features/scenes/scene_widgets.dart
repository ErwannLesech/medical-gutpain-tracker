import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/providers.dart';
import '../../core/services/scene_puzzle.dart';
import '../../core/services/scene_service.dart';
import '../../shared/theme/colors.dart';
import '../../shared/widgets/coin_widgets.dart';

/// Repère d'un emplacement libre : petite dalle isométrique (ellipse 2:1).
/// [size] est exprimé en pixels de scène pour garder une taille constante
/// à l'écran quel que soit le zoom.
class SlotMarker extends StatefulWidget {
  final double size;
  final bool highlighted;

  const SlotMarker({super.key, required this.size, this.highlighted = false});

  @override
  State<SlotMarker> createState() => _SlotMarkerState();
}

class _SlotMarkerState extends State<SlotMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void initState() {
    super.initState();
    if (widget.highlighted) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(SlotMarker old) {
    super.didUpdateWidget(old);
    if (widget.highlighted && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.highlighted && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          final grow = 1 + _pulse.value * 0.35;
          return CustomPaint(
            size: Size(widget.size * grow, widget.size * 0.5 * grow),
            painter: _MarkerPainter(highlighted: widget.highlighted),
          );
        },
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {
  final bool highlighted;
  _MarkerPainter({required this.highlighted});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final fill = Paint()
      ..color = highlighted
          ? WakyColors.sunshine.withValues(alpha: 0.75)
          : Colors.white.withValues(alpha: 0.55);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.12
      ..color = highlighted ? const Color(0xFFE08A00) : Colors.white;
    canvas.drawOval(rect.deflate(size.height * 0.06), fill);
    canvas.drawOval(rect.deflate(size.height * 0.06), stroke);
    // petit "+" au centre
    final plus = Paint()
      ..strokeWidth = size.height * 0.1
      ..strokeCap = StrokeCap.round
      ..color = highlighted
          ? const Color(0xFFE08A00)
          : WakyColors.primary.withValues(alpha: 0.7);
    final c = rect.center;
    final r = size.height * 0.2;
    canvas.drawLine(c - Offset(r, 0), c + Offset(r, 0), plus);
    canvas.drawLine(c - Offset(0, r * 0.8), c + Offset(0, r * 0.8), plus);
  }

  @override
  bool shouldRepaint(_MarkerPainter old) => old.highlighted != highlighted;
}

/// Image d'un modèle (icône du tiroir), avec repli si l'image manque
class ModelIcon extends StatelessWidget {
  final String asset;
  final double size;
  const ModelIcon({super.key, required this.asset, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text('🧩', style: TextStyle(fontSize: size * 0.5)),
        ),
      ),
    );
  }
}

/// Fenêtre affichée quand le journal fait gagner une pièce de scène.
/// Retourne true si l'utilisateur veut aller la poser tout de suite.
class ScenePieceDrawDialog extends StatefulWidget {
  final ScenePieceDrawResult result;
  const ScenePieceDrawDialog({super.key, required this.result});

  static Future<bool> show(
    BuildContext context,
    ScenePieceDrawResult result,
  ) async {
    final go = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ScenePieceDrawDialog(result: result),
    );
    return go ?? false;
  }

  @override
  State<ScenePieceDrawDialog> createState() => _ScenePieceDrawDialogState();
}

class _ScenePieceDrawDialogState extends State<ScenePieceDrawDialog> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    final scene = widget.result.scene;
    final model = widget.result.model;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${scene.emoji} ${scene.name}',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => _opened = true),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: CurvedAnimation(
                    parent: anim,
                    curve: Curves.elasticOut,
                  ),
                  child: child,
                ),
                child: _opened
                    ? Container(
                        key: const ValueKey('piece'),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: scene.background),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(18),
                        child: ModelIcon(
                          asset: scene.iconImage(model.id),
                          size: 114,
                        ),
                      )
                    : Container(
                        key: const ValueKey('gift'),
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          gradient: WakyColors.kpopGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🎁', style: TextStyle(fontSize: 56)),
                            SizedBox(height: 4),
                            Text(
                              'Touche ici',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: _opened ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Text(
                    widget.result.isDuplicate
                        ? 'Doublon !'
                        : 'Nouvelle pièce !',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: WakyColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.result.isDuplicate) ...[
                    Text(
                      'Tu as déjà toutes les pièces de ce modèle : elle est transformée en Catcoins.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CoinGainLabel(
                      amount: widget.result.coins,
                      iconSize: 26,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else
                    Text(
                      'Elle t\'attend dans le tiroir : à toi de trouver où elle va dans la scène.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_opened)
              const SizedBox(height: 48)
            else
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Plus tard'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        widget.result.isDuplicate
                            ? 'Voir la scène'
                            : 'La poser',
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Image de la scène finie : le « couvercle de la boîte » du puzzle
Future<void> showSceneReference(BuildContext context, SceneDef def) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Le modèle à reconstruire',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: def.background,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: def.reference.w / def.reference.h,
              child: InteractiveViewer(
                maxScale: 4,
                child: Image.asset(def.referenceImage, fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              'Pince pour zoomer. Les repères ⭕ de la scène montrent où il manque une pièce.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Boutique : acheter précisément la pièce qui manque
class SceneShopSheet extends ConsumerStatefulWidget {
  final ScenePuzzleState state;
  const SceneShopSheet({super.key, required this.state});

  /// Retourne true si au moins un achat a été fait
  static Future<bool> show(BuildContext context, ScenePuzzleState state) async {
    final bought = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SceneShopSheet(state: state),
    );
    return bought ?? false;
  }

  @override
  ConsumerState<SceneShopSheet> createState() => _SceneShopSheetState();
}

class _SceneShopSheetState extends ConsumerState<SceneShopSheet> {
  late ScenePuzzleState _state = widget.state;
  bool _bought = false;
  bool _busy = false;

  Future<void> _buy(SceneModelInfo model) async {
    setState(() => _busy = true);
    final service = ref.read(sceneServiceProvider);
    final ok = await service.buy(_state.def.id, model.id);
    final fresh = await service.getState(_state.def.id);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _state = fresh;
      _bought = _bought || ok;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          ok
              ? '${model.name} ajouté au tiroir 🧩'
              : 'Pas assez de Catcoins pour l\'instant',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(coinBalanceProvider).valueOrNull ?? 0;
    final missing = _state.missingByModel.entries.toList()
      ..sort(
        (a, b) => _state.def
            .model(a.key)
            .price
            .compareTo(_state.def.model(b.key).price),
      );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_bought);
      },
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Boutique',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const CoinBalanceChip(),
                  ],
                ),
              ),
              if (missing.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Tu as déjà toutes les pièces de cette scène ✨',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: missing.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final model = _state.def.model(missing[i].key);
                      final count = missing[i].value;
                      final affordable = balance >= model.price;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            ModelIcon(
                              asset: _state.def.iconImage(model.id),
                              size: 52,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$count à trouver',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.tonal(
                              onPressed: affordable && !_busy
                                  ? () => _buy(model)
                                  : null,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${model.price}'),
                                  const SizedBox(width: 4),
                                  const CatCoinIcon(size: 18),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fin de scène : choisir l'animal qui vient l'habiter
class ScenePetChooser extends StatelessWidget {
  final SceneDef def;
  final List<PetDef> pets;
  final bool hasNextScene;

  const ScenePetChooser({
    super.key,
    required this.def,
    required this.pets,
    required this.hasNextScene,
  });

  /// Retourne l'id de l'animal choisi (null si fermé)
  static Future<String?> show(
    BuildContext context,
    SceneDef def,
    List<PetDef> pets, {
    required bool hasNextScene,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) =>
          ScenePetChooser(def: def, pets: pets, hasNextScene: hasNextScene),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final choices = def.petChoices
        .map((id) => pets.where((p) => p.id == id).firstOrNull)
        .whereType<PetDef>()
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              'Scène terminée !',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choisis l\'animal qui vient s\'installer ici :',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final pet in choices)
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.of(context).pop(pet.id),
                    child: Container(
                      width: 84,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: def.background),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ModelIcon(asset: pet.icon, size: 60),
                          const SizedBox(height: 4),
                          Text(
                            pet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              hasNextScene
                  ? 'La scène suivante est débloquée ✨'
                  : 'Une nouvelle scène arrive très bientôt ✨',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
