import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/models.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import 'pain_provider.dart';
import 'pain_form_screen.dart';

/// Écran de suivi des douleurs
class PainScreen extends ConsumerWidget {
  const PainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final painState = ref.watch(painEventsProvider);
    final recentEvents = ref.watch(recentPainEventsProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // En-tête
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suivi douleurs',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enregistrez rapidement vos douleurs',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Bouton de saisie rapide
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WakyCard(
                  backgroundColor: WakyColors.primary.withValues(alpha: 0.05),
                  onTap: () => _navigateToQuickPain(context),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: WakyColors.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: WakyColors.error,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enregistrer une douleur',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Saisie en moins de 30 secondes',
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
                ),
              ),
            ),

            // Statistiques rapides
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cette semaine',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final weeklyCount = ref.watch(weeklyPainEventsCountProvider);
                              return weeklyCount.when(
                                data: (count) => StatCard(
                                  title: 'Événements',
                                  value: '$count',
                                  icon: Icons.warning_amber,
                                  color: WakyColors.warning,
                                ),
                                loading: () => const StatCard(
                                  title: 'Événements',
                                  value: '-',
                                  icon: Icons.warning_amber,
                                  color: WakyColors.warning,
                                ),
                                error: (_, __) => const StatCard(
                                  title: 'Événements',
                                  value: '-',
                                  icon: Icons.warning_amber,
                                  color: WakyColors.warning,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final stats = ref.watch(painStatsProvider);
                              return stats.when(
                                data: (data) => StatCard(
                                  title: 'Intensité moy.',
                                  value: data.averageIntensity.toStringAsFixed(1),
                                  subtitle: '/5',
                                  icon: Icons.show_chart,
                                  color: WakyColors.getIntensityColor(
                                    data.averageIntensity.round(),
                                  ),
                                ),
                                loading: () => const StatCard(
                                  title: 'Intensité moy.',
                                  value: '-',
                                  icon: Icons.show_chart,
                                ),
                                error: (_, __) => const StatCard(
                                  title: 'Intensité moy.',
                                  value: '-',
                                  icon: Icons.show_chart,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Liste des événements récents
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Événements récents',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Naviguer vers l'historique complet
                      },
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),
            ),

            // Liste
            recentEvents.when(
              data: (events) {
                if (events.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Text('😌', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune douleur enregistrée',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'C\'est une bonne nouvelle !',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = events[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: PainCard(
                          time: _formatDateTime(event.dateTime),
                          intensity: event.intensity,
                          description: event.description,
                          symptoms: event.symptoms.map((s) => s.name).toList(),
                          linkedMealInfo: event.delayFromMealFormatted,
                          onTap: () => _navigateToEditPain(context, event),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Center(child: Text('Erreur: $error')),
              ),
            ),

            // Espace en bas
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToQuickPain(context),
        backgroundColor: WakyColors.error,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dayPart;
    if (eventDate == today) {
      dayPart = 'Aujourd\'hui';
    } else if (eventDate == today.subtract(const Duration(days: 1))) {
      dayPart = 'Hier';
    } else {
      dayPart = DateFormat('EEE d MMM', 'fr_FR').format(dateTime);
    }

    return '$dayPart à ${DateFormat('HH:mm').format(dateTime)}';
  }

  void _navigateToQuickPain(BuildContext context) {
    HapticService.medium();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PainFormScreen(),
      ),
    );
  }

  void _navigateToEditPain(BuildContext context, PainEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PainFormScreen(event: event),
      ),
    );
  }
}
