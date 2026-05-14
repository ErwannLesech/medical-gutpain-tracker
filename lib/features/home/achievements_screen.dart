import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/achievement.dart';
import '../../core/services/achievement_service.dart';
import '../../shared/theme/colors.dart';
import '../../shared/widgets/widgets.dart';
import 'cat_gallery_screen.dart';
import 'food_gallery_screen.dart';
import 'home_provider.dart';

/// Écran de la galerie des achievements
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAchievements = ref.watch(allAchievementsProvider);
    final stats = ref.watch(achievementStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes badges'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Carte de la galerie de chats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CatGalleryPreviewCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CatGalleryScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Carte de la galerie de plats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: FoodGalleryPreviewCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FoodGalleryScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // En-tête avec statistiques
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: stats.when(
                  data: (data) => _buildStatsHeader(context, data),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Liste des achievements
            allAchievements.when(
              data: (achievements) {
                if (achievements.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Text('🏅', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun badge pour l\'instant',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Continuez à utiliser l\'application pour débloquer des badges !',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return _buildAchievementsList(context, achievements);
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Center(child: Text('Erreur: $error')),
              ),
            ),

            // Liste des badges disponibles (non débloqués)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Badges à débloquer',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            allAchievements.when(
              data: (achievements) {
                final unlockedTypes = achievements.map((a) => a.badgeType).toSet();
                final lockedBadges = BadgeType.values
                    .where((type) => !unlockedTypes.contains(type))
                    .toList();

                return _buildLockedBadgesList(context, lockedBadges);
              },
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, AchievementStats stats) {
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
                      '${stats.totalUnlocked}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: WakyColors.primary,
                          ),
                    ),
                    Text(
                      'Badges débloqués',
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RarityCount(
                emoji: '⚪',
                count: stats.commonCount,
                label: 'Commun',
              ),
              _RarityCount(
                emoji: '🔵',
                count: stats.rareCount,
                label: 'Rare',
              ),
              _RarityCount(
                emoji: '🟣',
                count: stats.epicCount,
                label: 'Épique',
              ),
              _RarityCount(
                emoji: '🟡',
                count: stats.legendaryCount,
                label: 'Légendaire',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(BuildContext context, List<Achievement> achievements) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final achievement = achievements[index];
          final badgeType = achievement.badgeType;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: _BadgeCard(
              badgeType: badgeType,
              isUnlocked: true,
              unlockedAt: achievement.unlockedAt,
            ),
          );
        },
        childCount: achievements.length,
      ),
    );
  }

  Widget _buildLockedBadgesList(BuildContext context, List<BadgeType> lockedBadges) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final badgeType = lockedBadges[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: _BadgeCard(
              badgeType: badgeType,
              isUnlocked: false,
            ),
          );
        },
        childCount: lockedBadges.length,
      ),
    );
  }
}

class _RarityCount extends StatelessWidget {
  final String emoji;
  final int count;
  final String label;

  const _RarityCount({
    required this.emoji,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeType badgeType;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const _BadgeCard({
    required this.badgeType,
    required this.isUnlocked,
    this.unlockedAt,
  });

  Color _getRarityColor() {
    switch (badgeType.rarity) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _getRarityName() {
    switch (badgeType.rarity) {
      case 1:
        return 'Commun';
      case 2:
        return 'Rare';
      case 3:
        return 'Épique';
      case 4:
        return 'Légendaire';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = _getRarityColor();

    return WakyCard(
      backgroundColor: isUnlocked
          ? rarityColor.withValues(alpha: 0.05)
          : Colors.grey.withValues(alpha: 0.05),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? rarityColor.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: rarityColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                isUnlocked ? badgeType.emoji : '🔒',
                style: TextStyle(
                  fontSize: 32,
                  color: isUnlocked ? null : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        badgeType.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isUnlocked ? null : Colors.grey,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: rarityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRarityName(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: rarityColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  badgeType.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isUnlocked ? Colors.grey : Colors.grey.shade400,
                      ),
                ),
                if (isUnlocked && unlockedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Débloqué le ${_formatDate(unlockedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: rarityColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'aujourd\'hui';
    if (diff == 1) return 'hier';
    if (diff < 7) return 'il y a $diff jours';
    if (diff < 30) return 'il y a ${(diff / 7).floor()} semaines';
    return 'il y a ${(diff / 30).floor()} mois';
  }
}
