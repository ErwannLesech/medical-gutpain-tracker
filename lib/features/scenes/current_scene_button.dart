import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/providers.dart';
import '../../core/services/scene_service.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/theme/colors.dart';
import 'scene_gallery_screen.dart';
import 'scene_puzzle_screen.dart';

/// Gros bouton horizontal « Continuer ma scène » : ouvre directement le puzzle
/// de la scène en cours (ou la collection quand toutes les scènes sont finies).
///
/// Les scènes sont la collection prioritaire : elles se jouent tant qu'il
/// reste des pièces à gagner, alors que les chats et les plats passent au
/// second plan une fois complétés.
class CurrentSceneButton extends ConsumerWidget {
  const CurrentSceneButton({super.key});

  static const double height = 88;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(currentSceneProvider).valueOrNull;
    // Même hauteur pendant le chargement : la page ne saute pas
    if (overview == null) return const SizedBox(height: height);

    Future<void> open() async {
      HapticService.medium();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => overview.allDone
              ? const SceneGalleryScreen()
              : const ScenePuzzleScreen(),
        ),
      );
      if (!context.mounted) return;
      ref.invalidate(currentSceneProvider);
      ref.invalidate(scenesProvider);
    }

    return _SceneButtonBody(overview: overview, onTap: open);
  }
}

class _SceneButtonBody extends StatelessWidget {
  final SceneOverview overview;
  final VoidCallback onTap;

  const _SceneButtonBody({required this.overview, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final def = overview.def;
    final state = overview.state;
    final allDone = overview.allDone;
    final needsPet = !allDone && state.isComplete && state.pet == null;
    final toPlace = allDone || state.isComplete ? 0 : state.inventoryCount;

    final title = allDone ? 'Toutes tes scènes sont terminées 🎉' : 'Continuer ma scène';
    final subtitle = allDone
        ? 'Revoir ma collection'
        : needsPet
        ? '${def.emoji} ${def.name} · choisis son habitant 🐾'
        : '${def.emoji} ${def.name}';

    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: Container(
        height: CurrentSceneButton.height,
        decoration: BoxDecoration(
          gradient: WakyColors.kpopGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: WakyColors.primary.withValues(alpha: 0.30),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _EmojiBubble(
                    emoji: allDone ? '🏆' : def.emoji,
                    badge: toPlace,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 13,
                          ),
                        ),
                        if (!allDone) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: state.progress,
                                    minHeight: 6,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.28,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${state.placedCount}/${state.totalSlots}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: WakyColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Emoji de la scène dans une pastille, avec le nombre de pièces à poser
class _EmojiBubble extends StatelessWidget {
  final String emoji;

  /// Pièces du tiroir encore à poser (0 : pas de pastille)
  final int badge;

  const _EmojiBubble({required this.emoji, required this.badge});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
          if (badge > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                key: const ValueKey('scene-button-badge'),
                constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: WakyColors.sunshine,
                  shape: badge > 9 ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: badge > 9 ? BorderRadius.circular(11) : null,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
