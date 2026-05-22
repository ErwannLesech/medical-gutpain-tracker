import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/cat_reward_service.dart';
import '../../core/services/providers.dart';
import '../../shared/theme/colors.dart';
import '../../shared/widgets/widgets.dart';

/// Écran de la galerie de chats (Pokédex)
class CatGalleryScreen extends ConsumerWidget {
  const CatGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(catGalleryStatsProvider);
    final catsAsync = ref.watch(allCatsWithStatusProvider);
    final discoveredAsync = ref.watch(discoveredCatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma collection de chats'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // En-tête avec statistiques
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: statsAsync.when(
                  data: (stats) => _buildStatsHeader(context, stats),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Découvre un nouveau chat chaque jour en remplissant ton journal quotidien !',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Titre section chats découverts
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('🐱', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Chats découverts',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Grille des chats
            catsAsync.when(
              data: (cats) => _buildCatsGrid(context, ref, cats, discoveredAsync),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Center(child: Text('Erreur: $error')),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, CatGalleryStats stats) {
    return WakyCard(
      backgroundColor: WakyColors.primary.withValues(alpha: 0.05),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${stats.discoveredCount}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: WakyColors.primary,
                          ),
                    ),
                    Text(
                      'Chats découverts',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${stats.totalCount}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                    ),
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${stats.percentage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: WakyColors.success,
                          ),
                    ),
                    Text(
                      'Complété',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: stats.percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(WakyColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatsGrid(
    BuildContext context,
    WidgetRef ref,
    List<CatWithStatus> cats,
    AsyncValue<List<DiscoveredCatWithData>> discoveredAsync,
  ) {
    // Créer un map pour accéder rapidement aux dates de découverte
    final discoveryDates = <String, DateTime>{};
    discoveredAsync.whenData((discovered) {
      for (final d in discovered) {
        discoveryDates[d.catData.id] = d.discoveredCat.discoveredAt;
      }
    });

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final catWithStatus = cats[index];
            return CatGalleryItem(
              cat: catWithStatus.cat,
              isDiscovered: catWithStatus.isDiscovered,
              onTap: catWithStatus.isDiscovered
                  ? () => CatDetailDialog.show(
                        context,
                        catWithStatus.cat,
                        discoveredAt: discoveryDates[catWithStatus.cat.id],
                      )
                  : null,
            );
          },
          childCount: cats.length,
        ),
      ),
    );
  }
}

/// Widget compact pour afficher les stats de chats sur l'écran achievements
class CatGalleryPreviewCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const CatGalleryPreviewCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(catGalleryStatsProvider);
    final catsAsync = ref.watch(allCatsWithStatusProvider);

    return GestureDetector(
      onTap: onTap,
      child: WakyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🐱', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Collection de chats',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 12),

            // Stats
            statsAsync.when(
              data: (stats) => Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${stats.discoveredCount} / ${stats.totalCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: WakyColors.primary,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'chats découverts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: stats.percentage / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(WakyColors.success),
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox(
                height: 20,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (_, _) => const Text('Erreur'),
            ),

            const SizedBox(height: 12),

            // Aperçu des derniers chats découverts
            catsAsync.when(
              data: (cats) {
                final discovered = cats.where((c) => c.isDiscovered).take(6).toList();
                if (discovered.isEmpty) {
                  return Text(
                    'Remplis ton journal pour découvrir des chats !',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                  );
                }
                return Row(
                  children: [
                    ...discovered.map((c) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              c.cat.assetPath,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.pets, size: 20),
                              ),
                            ),
                          ),
                        )),
                    if (cats.where((c) => c.isDiscovered).length > 6)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '+${cats.where((c) => c.isDiscovered).length - 6}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
