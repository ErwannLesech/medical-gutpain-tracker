import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/models/models.dart';
import '../core/utils/haptic_service.dart';
import '../shared/theme/colors.dart';
import '../shared/widgets/widgets.dart';
import 'meals/meals_screen.dart';
import 'pain/pain_screen.dart';
import 'pain/pain_form_screen.dart';
import 'daily/daily_screen.dart';
import 'daily/daily_provider.dart';
import 'daily/daily_form_screen.dart';
import 'settings/settings_screen.dart';
import 'home/home_provider.dart';
import 'home/achievements_screen.dart';

/// Écran d'accueil / Dashboard
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    _DashboardTab(),
    MealsScreen(),
    PainScreen(),
    DailyScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          HapticService.selection();
          setState(() => _currentIndex = index);
          
          // Rafraîchir les stats quand on revient sur la page d'accueil
          if (index == 0) {
            ref.invalidate(todayReportProvider);
            ref.invalidate(consecutiveDaysProvider);
            ref.invalidate(upcomingMealsCountProvider);
            ref.invalidate(allAchievementsProvider);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Repas',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning_amber),
            label: 'Douleurs',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Réglages',
          ),
        ],
      ),
    );
  }
}

/// Tab Dashboard
class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Salutation
              _buildGreeting(context),
              
              const SizedBox(height: 24),

              // Actions rapides (avec journal du jour)
              Text(
                'Actions rapides',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(context, ref),

              const SizedBox(height: 24),

              // Statistiques de motivation
              Text(
                'Progression',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              _buildProgressStats(context, ref),

              const SizedBox(height: 24),

              // Badge le plus récent
              _buildLatestBadge(context, ref),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Première ligne : Journal du jour
        _buildJournalCard(context, ref),
        
        const SizedBox(height: 12),
        
        // Deuxième ligne : Repas et Douleur
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                emoji: '🍽️',
                label: 'Nouveau repas',
                color: WakyColors.primary,
                onTap: () {
                  HapticService.medium();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MealsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                emoji: '⚠️',
                label: 'Douleur',
                color: WakyColors.error,
                onTap: () {
                  HapticService.medium();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PainFormScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJournalCard(BuildContext context, WidgetRef ref) {
    final hour = DateTime.now().hour;
    final isEvening = hour >= 20;
    
    // Utiliser un FutureProvider pour pouvoir l'invalider facilement
    final todayReportAsync = ref.watch(todayReportProvider);
    
    return todayReportAsync.when(
      data: (todayReport) {
        final hasJournal = todayReport != null && todayReport.id != 0;
        
        return WakyCard(
          backgroundColor: isEvening
              ? (hasJournal 
                  ? WakyColors.success.withValues(alpha: 0.1)
                  : WakyColors.primary.withValues(alpha: 0.15))
              : Colors.grey.withValues(alpha: 0.05),
          onTap: isEvening
              ? () async {
                  HapticService.medium();
                  final reportToEdit = todayReport ??
                      await ref
                          .read(dailyReportProvider.notifier)
                          .getOrCreateToday();
                  if (context.mounted) {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) =>
                            DailyFormScreen(report: reportToEdit),
                      ),
                    );

                    // Rafraîchir la page d'accueil après modification/suppression
                    if (result == true) {
                      ref.invalidate(todayReportProvider);
                      ref.invalidate(consecutiveDaysProvider);
                    }
                  }
                }
              : null,
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isEvening
                      ? (hasJournal 
                          ? WakyColors.success.withValues(alpha: 0.2)
                          : WakyColors.primary.withValues(alpha: 0.2))
                      : Colors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    hasJournal ? '✅' : '📝',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasJournal 
                          ? 'Journal du jour rempli'
                          : 'Remplir le journal du jour',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isEvening ? null : Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEvening
                          ? (hasJournal
                              ? 'Vous pouvez le modifier'
                              : 'Prenez un moment pour noter votre journée')
                          : 'Disponible à partir de 20h',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isEvening ? Colors.grey : Colors.grey.shade400,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isEvening 
                    ? (hasJournal ? WakyColors.success : WakyColors.primary)
                    : Colors.grey.shade400,
              ),
            ],
          ),
        );
      },
      loading: () => WakyCard(
        backgroundColor: Colors.grey.withValues(alpha: 0.05),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => WakyCard(
        backgroundColor: Colors.grey.withValues(alpha: 0.05),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStats(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final streak = ref.watch(consecutiveDaysProvider);
              return streak.when(
                data: (count) => _ProgressCard(
                  emoji: _getStreakEmoji(count),
                  title: 'Série de jours',
                  value: '$count',
                  subtitle: count > 1 ? 'jours' : 'jour',
                  color: WakyColors.success,
                  description: _getStreakMessage(count),
                ),
                loading: () => const _ProgressCard(
                  emoji: '🔥',
                  title: 'Série de jours',
                  value: '-',
                  subtitle: 'jours',
                  color: WakyColors.success,
                ),
                error: (_, __) => const _ProgressCard(
                  emoji: '🔥',
                  title: 'Série de jours',
                  value: '0',
                  subtitle: 'jours',
                  color: WakyColors.success,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final upcomingMeals = ref.watch(upcomingMealsCountProvider);
              return upcomingMeals.when(
                data: (count) => _ProgressCard(
                  emoji: '🗓️',
                  title: 'Jours de repas planifiés',
                  value: '$count',
                  subtitle: count > 1 ? 'repas' : 'repas',
                  color: WakyColors.primary,
                  description: count > 0 ? 'Planification active' : 'Aucun repas prévu',
                ),
                loading: () => const _ProgressCard(
                  emoji: '🗓️',
                  title: 'Repas prévus',
                  value: '-',
                  subtitle: 'repas',
                  color: WakyColors.primary,
                ),
                error: (_, __) => const _ProgressCard(
                  emoji: '🗓️',
                  title: 'Repas prévus',
                  value: '0',
                  subtitle: 'repas',
                  color: WakyColors.primary,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getStreakEmoji(int streak) {
    if (streak == 0) return '🌱';
    if (streak < 3) return '🔥';
    if (streak < 7) return '⭐';
    if (streak < 14) return '🌟';
    if (streak < 30) return '💫';
    if (streak < 60) return '✨';
    return '🏆';
  }

  String _getStreakMessage(int streak) {
    if (streak == 0) return 'Commencez votre série !';
    if (streak < 3) return 'Bon début !';
    if (streak < 7) return 'Continuez comme ça !';
    if (streak < 14) return 'Excellente régularité !';
    if (streak < 30) return 'Vous êtes sur la bonne voie !';
    if (streak < 60) return 'Impressionnant !';
    return 'Légendaire !';
  }

  Widget _buildLatestBadge(BuildContext context, WidgetRef ref) {
    final allAchievements = ref.watch(allAchievementsProvider);
    
    return allAchievements.when(
      data: (achievements) {
        if (achievements.isEmpty) {
          return WakyCard(
            backgroundColor: WakyColors.primary.withValues(alpha: 0.05),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AchievementsScreen(),
                ),
              );
            },
            child: Row(
              children: [
                const Text('🏅', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commencez à débloquer des badges',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Suivez vos progrès et gagnez des récompenses',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          );
        }

        final latest = achievements.first;
        final badgeType = latest.badgeType;
        
        return WakyCard(
          backgroundColor: WakyColors.sunshine.withValues(alpha: 0.1),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AchievementsScreen(),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: WakyColors.sunshine.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badgeType.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dernier badge débloqué',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badgeType.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '${achievements.length} badge${achievements.length > 1 ? 's' : ''} au total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildJournalReminder(BuildContext context, WidgetRef ref) {
    // Cette méthode n'est plus utilisée mais gardée pour compatibilité
    return const SizedBox.shrink();
  }

  Widget _buildGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;

    if (hour < 12) {
      greeting = 'Bonjour';
      emoji = '';
    } else if (hour < 18) {
      greeting = 'Bon après-midi';
      emoji = '';
    } else {
      greeting = 'Bonsoir';
      emoji = '';
    }

    final affectionateTerms = [
      "chérie",
      "mon coeur",
      "mon amour",
      "ma chère",
      "ma déesse",
      "ma princesse",
      "mon chaton",
      "mon chat",
      "ma p'tite chérie",
      "mon p'tit chat",
      "mon p'tit chaton",
      "chère copine"
    ];
    final random = Random();
    final randomTerm = affectionateTerms[random.nextInt(affectionateTerms.length)];

    greeting = '$greeting $randomTerm';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final String? description;

  const _ProgressCard({
    required this.emoji,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return WakyCard(
      backgroundColor: color.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return WakyCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
