import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/models.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/services/providers.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import 'daily_provider.dart';
import 'daily_form_screen.dart';
import 'date_selector_screen.dart';
import '../home/home_provider.dart';

/// Écran de suivi du journal journalier
class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentReports = ref.watch(recentReportsProvider);

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Journal',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Suivez votre bien-être au quotidien',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                        // Badge aujourd'hui
                        Consumer(
                          builder: (context, ref, _) {
                            return FutureBuilder<DailyReport?>(
                              future: ref.read(dailyReportProvider.notifier).getTodayReport(),
                              builder: (context, snapshot) {
                                final todayReport = snapshot.data;
                                if (todayReport == null) return const SizedBox.shrink();
                                
                                return InkWell(
                                  onTap: () => _navigateToEditReport(context, ref, todayReport),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: WakyColors.success.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: WakyColors.success.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          todayReport.statusEmoji,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Aujourd\'hui',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: WakyColors.success,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bouton création de journal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WakyCard(
                  backgroundColor: WakyColors.primary.withValues(alpha: 0.05),
                  onTap: () => _navigateToCreateJournal(context, ref),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: WakyColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: WakyColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Créer un journal',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Pour aujourd\'hui ou un jour passé',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
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

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Titre de la liste
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Journaux récents',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Liste des rapports récents
            recentReports.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun journal enregistré',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Commencez par créer votre journal du jour',
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

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final report = reports[index];
                      final isToday = DailyReport.normalizeDate(report.date)
                          .isAtSameMomentAs(
                              DailyReport.normalizeDate(DateTime.now()));

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: DailyReportCard(
                          report: report,
                          isToday: isToday,
                          onTap: () => _navigateToEditReport(context, ref, report),
                        ),
                      );
                    },
                    childCount: reports.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Erreur: $error',
                    style: const TextStyle(color: WakyColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToCreateJournal(
    BuildContext context,
    WidgetRef ref,
  ) async {
    HapticService.medium();
    
    // Ouvrir le sélecteur de date
    final selectedDate = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (context) => const DateSelectorScreen(),
      ),
    );

    if (selectedDate != null && context.mounted) {
      // Vérifier si un rapport existe déjà pour cette date
      final existingReport = await ref.read(dailyReportRepositoryProvider).getByDate(selectedDate);
      
      DailyReport reportToEdit;
      if (existingReport != null) {
        // Éditer le rapport existant
        reportToEdit = existingReport;
      } else {
        // Créer un nouveau rapport pour cette date
        reportToEdit = DailyReport(
          date: DailyReport.normalizeDate(selectedDate),
        );
      }
      
      if (context.mounted) {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => DailyFormScreen(
              report: reportToEdit,
              date: selectedDate,
            ),
          ),
        );

        if (result == true) {
          ref.invalidate(recentReportsProvider);
          ref.invalidate(dailyReportProvider);
          ref.invalidate(todayReportProvider);
          ref.invalidate(allReportsForCalendarProvider);
          ref.invalidate(consecutiveDaysProvider);
        }
      }
    }
  }

  Future<void> _navigateToEditReport(
    BuildContext context,
    WidgetRef ref,
    DailyReport report,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => DailyFormScreen(report: report),
      ),
    );

    if (result == true) {
      ref.invalidate(recentReportsProvider);
      ref.invalidate(todayReportProvider);
      ref.invalidate(consecutiveDaysProvider);
    }
  }
}

/// Widget pour afficher une carte de rapport journalier
class DailyReportCard extends StatelessWidget {
  final DailyReport report;
  final bool isToday;
  final VoidCallback onTap;

  const DailyReportCard({
    super.key,
    required this.report,
    required this.onTap,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = Color(report.statusColorValue);

    return WakyCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Emoji du statut
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    report.statusEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('EEEE d MMM', 'fr_FR').format(report.date),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: WakyColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Aujourd\'hui',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: WakyColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.statusName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          // Résumé rapide
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                context,
                icon: Icons.local_fire_department_outlined,
                label: 'Stress',
                value: report.stressLevel.toString(),
                color: WakyColors.warning,
              ),
              _buildInfoChip(
                context,
                icon: Icons.battery_charging_full,
                label: 'Fatigue',
                value: report.fatigueLevel.toString(),
                color: WakyColors.info,
              ),
              _buildInfoChip(
                context,
                icon: Icons.bedtime_outlined,
                label: 'Sommeil',
                value: '${report.hoursSlept.toStringAsFixed(1)}h',
                color: WakyColors.primary,
              ),
            ],
          ),
          if (report.notes != null && report.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              report.notes!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
      ],
    );
  }
}
