import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/food_reward_service.dart';
import '../../core/services/providers.dart';
import '../../shared/theme/colors.dart';
import '../../shared/widgets/widgets.dart';

/// Ecran de la galerie de plats (collection)
class FoodGalleryScreen extends ConsumerWidget {
  const FoodGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(foodCardGalleryStatsProvider);
    final cardsAsync = ref.watch(allFoodCardsWithStatusProvider);
    final discoveredAsync = ref.watch(discoveredFoodCardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma collection de plats'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Decouvre une nouvelle carte en remplissant ton journal quotidien.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.restaurant_menu, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Cartes decouvertes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            cardsAsync.when(
              data: (cards) => _buildCardsGrid(context, ref, cards, discoveredAsync),
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

  Widget _buildStatsHeader(BuildContext context, FoodCardGalleryStats stats) {
    return WakyCard(
      backgroundColor: WakyColors.sunshine.withValues(alpha: 0.08),
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
                            color: WakyColors.sunshine,
                          ),
                    ),
                    Text(
                      'Cartes decouvertes',
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
                      'Complete',
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

  Widget _buildCardsGrid(
    BuildContext context,
    WidgetRef ref,
    List<FoodCardWithStatus> cards,
    AsyncValue<List<DiscoveredFoodCardWithData>> discoveredAsync,
  ) {
    final discoveryDates = <String, DateTime>{};
    discoveredAsync.whenData((discovered) {
      for (final d in discovered) {
        discoveryDates[d.cardData.id] = d.discoveredCard.discoveredAt;
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
            final cardWithStatus = cards[index];
            return FoodCardGalleryItem(
              card: cardWithStatus.card,
              isDiscovered: cardWithStatus.isDiscovered,
              onTap: cardWithStatus.isDiscovered
                  ? () => FoodCardDetailDialog.show(
                        context,
                        cardWithStatus.card,
                        discoveredAt: discoveryDates[cardWithStatus.card.id],
                      )
                  : null,
            );
          },
          childCount: cards.length,
        ),
      ),
    );
  }
}

/// Widget compact pour afficher les stats de plats sur l'ecran achievements
class FoodGalleryPreviewCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const FoodGalleryPreviewCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(foodCardGalleryStatsProvider);
    final cardsAsync = ref.watch(allFoodCardsWithStatusProvider);

    return GestureDetector(
      onTap: onTap,
      child: WakyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant_menu, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Collection de plats',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            statsAsync.when(
              data: (stats) => Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${stats.discoveredCount} / ${stats.totalCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: WakyColors.sunshine,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'cartes decouvertes',
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
                      valueColor: const AlwaysStoppedAnimation<Color>(WakyColors.success),
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
            cardsAsync.when(
              data: (cards) {
                final discovered = cards.where((c) => c.isDiscovered).take(6).toList();
                if (discovered.isEmpty) {
                  return Text(
                    'Remplis ton journal pour decouvrir des cartes.',
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
                              c.card.assetPath,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.restaurant, size: 20),
                              ),
                            ),
                          ),
                        )),
                    if (cards.where((c) => c.isDiscovered).length > 6)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '+${cards.where((c) => c.isDiscovered).length - 6}',
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
