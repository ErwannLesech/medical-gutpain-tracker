import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/providers.dart';
import '../../core/services/scene_puzzle.dart';
import '../../core/services/scene_service.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/theme/colors.dart';
import '../../shared/widgets/widgets.dart';
import 'scene_puzzle_screen.dart';

/// Animaux (chargés une fois) pour afficher l'habitant des scènes terminées
final scenePetsProvider = FutureProvider<List<PetDef>>((ref) {
  return ref.watch(sceneServiceProvider).loadPets();
});

/// Collection des scènes : débloquées dans l'ordre, les autres restent « ? »
class SceneGalleryScreen extends ConsumerWidget {
  const SceneGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenes = ref.watch(scenesProvider);
    final pets = ref.watch(scenePetsProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Collection de scènes')),
      body: scenes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          final finished = list.where((s) => s.isFinished).length;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    '$finished / ${list.length} scènes terminées',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'Chaque journal t\'apporte une pièce. Termine une scène pour découvrir la suivante.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, i) => _SceneTile(
                    status: list[i],
                    number: i + 1,
                    pets: pets,
                    onTap: list[i].unlocked
                        ? () async {
                            HapticService.medium();
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ScenePuzzleScreen(sceneId: list[i].def.id),
                              ),
                            );
                            ref.invalidate(scenesProvider);
                            ref.invalidate(currentSceneProvider);
                          }
                        : () => ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Termine la scène précédente pour la découvrir 🔒',
                                ),
                              ),
                            ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SceneTile extends StatelessWidget {
  final SceneStatus status;
  final int number;
  final List<PetDef> pets;
  final VoidCallback onTap;

  const _SceneTile({
    required this.status,
    required this.number,
    required this.pets,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!status.unlocked) {
      return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '?',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Scène $number',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final state = status.state;
    final def = status.def;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: def.background,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SceneThumbnail(state: state, pets: pets),
              ),
              const SizedBox(height: 6),
              Text(
                '${def.emoji} ${def.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              if (status.isFinished)
                Text(
                  'Terminée 🌟',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                )
              else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: state.progress,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.6),
                    color: WakyColors.success,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${state.placedCount} / ${state.totalSlots} pièces',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Miniature d'une scène telle qu'elle est : terrain + pièces posées + animal
class SceneThumbnail extends StatelessWidget {
  final ScenePuzzleState state;
  final List<PetDef> pets;

  const SceneThumbnail({super.key, required this.state, required this.pets});

  @override
  Widget build(BuildContext context) {
    final def = state.def;
    final pet = state.petId == null
        ? null
        : pets.where((p) => p.id == state.petId).firstOrNull;
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: def.width,
        height: def.height,
        child: Stack(
          children: [
            if (def.terrain != null)
              Positioned(
                left: def.terrain!.x,
                top: def.terrain!.y,
                width: def.terrain!.w,
                height: def.terrain!.h,
                child: Image.asset(def.terrainImage, fit: BoxFit.fill),
              ),
            for (final slot in def.slots)
              if (state.isPlaced(slot))
                Positioned(
                  left: slot.rect.x,
                  top: slot.rect.y,
                  width: slot.rect.w,
                  height: slot.rect.h,
                  child: Image.asset(def.slotImage(slot), fit: BoxFit.fill),
                ),
            if (pet != null && def.petSpot != null)
              Positioned(
                left: def.petSpot!.dx - pet.anchor.dx,
                top: def.petSpot!.dy - pet.anchor.dy,
                width: pet.w,
                height: pet.h,
                child: Image.asset(pet.image, fit: BoxFit.fill),
              ),
          ],
        ),
      ),
    );
  }
}

/// Encart de la collection de scènes (écran « Mes badges »)
class SceneGalleryPreviewCard extends ConsumerWidget {
  final VoidCallback? onTap;
  const SceneGalleryPreviewCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenes = ref.watch(scenesProvider).valueOrNull;
    final theme = Theme.of(context);
    final finished = scenes?.where((s) => s.isFinished).length ?? 0;
    final current = scenes
        ?.where((s) => s.unlocked && !s.isFinished)
        .firstOrNull;

    return GestureDetector(
      onTap: onTap,
      child: WakyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.landscape_outlined, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Collection de scènes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            if (scenes == null)
              const SizedBox(
                height: 20,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else ...[
              Row(
                children: [
                  Text(
                    '$finished / ${scenes.length}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: WakyColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'scènes terminées',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              if (current != null) ...[
                const SizedBox(height: 8),
                Text(
                  'En cours : ${current.def.emoji} ${current.def.name} · ${current.state.placedCount}/${current.state.totalSlots}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final s in scenes)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: s.unlocked
                            ? LinearGradient(colors: s.def.background)
                            : null,
                        color: s.unlocked ? null : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        border: s.isFinished
                            ? Border.all(color: WakyColors.success, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          s.unlocked ? s.def.emoji : '?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
