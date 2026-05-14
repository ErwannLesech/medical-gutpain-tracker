import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/models.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/services/providers.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import 'daily_provider.dart';
import '../home/home_provider.dart';

/// Écran de formulaire pour créer/éditer un rapport journalier
class DailyFormScreen extends ConsumerStatefulWidget {
  final DailyReport? report;
  final DateTime? date;

  const DailyFormScreen({
    super.key,
    this.report,
    this.date,
  });

  @override
  ConsumerState<DailyFormScreen> createState() => _DailyFormScreenState();
}

class _DailyFormScreenState extends ConsumerState<DailyFormScreen> {
  bool _isSaving = false;
  late DailyReport _editingReport;

  @override
  void initState() {
    super.initState();
    _editingReport = widget.report ??
        DailyReport(
          date: DailyReport.normalizeDate(widget.date ?? DateTime.now()),
        );
  }

  Future<void> _saveReport() async {
    setState(() => _isSaving = true);

    try {
      // Vérifie si c'est la première création du rapport pour cette date
      final catService = ref.read(catRewardServiceProvider);
      final foodService = ref.read(foodRewardServiceProvider);
      final canDrawCat = await catService.canDrawForDate(_editingReport.date);
      final isCatCollectionComplete = await catService.isCollectionComplete();
      final canDrawFood = isCatCollectionComplete
          ? await foodService.canDrawForDate(_editingReport.date)
          : false;
      
      final success = await ref
          .read(dailyReportProvider.notifier)
          .saveReport(_editingReport);

      if (success && mounted) {
        HapticService.success();
        
        // Tirage de chat si c'est la premiere sauvegarde du jour
        if (canDrawCat) {
          final catResult = await catService.drawCatForDate(_editingReport.date);
          if (catResult != null && mounted) {
            // Invalider les providers pour rafraichir les donnees
            ref.invalidate(catGalleryStatsProvider);
            ref.invalidate(allCatsWithStatusProvider);
            ref.invalidate(discoveredCatsProvider);

            // Afficher le dialog de recompense
            await CatDrawResultDialog.show(context, catResult);
          }
        } else if (canDrawFood) {
          final foodResult = await foodService.drawFoodCardForDate(_editingReport.date);
          if (foodResult != null && mounted) {
            ref.invalidate(foodCardGalleryStatsProvider);
            ref.invalidate(allFoodCardsWithStatusProvider);
            ref.invalidate(discoveredFoodCardsProvider);

            await FoodCardDrawResultDialog.show(context, foodResult);
          }
        }
        
        // Vérifier les achievements
        ref.invalidate(consecutiveDaysProvider);
        final streak = await ref.read(consecutiveDaysProvider.future);
        
        // Exécuter la vérification des achievements (pas juste invalider)
        try {
          final unlockedBadges = await ref.read(checkAchievementsProvider(streak).future);
          
          // Rafraîchir les achievements après la vérification
          ref.invalidate(allAchievementsProvider);
          ref.invalidate(unseenAchievementsProvider);
          ref.invalidate(achievementStatsProvider);
          
          // Afficher un message si des badges ont été débloqués
          if (unlockedBadges.isNotEmpty && mounted) {
            final badgeNames = unlockedBadges.map((b) => b.title).join(', ');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🏆 Badge${unlockedBadges.length > 1 ? 's' : ''} débloqué${unlockedBadges.length > 1 ? 's' : ''} : $badgeNames'),
                backgroundColor: WakyColors.sunshine,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        } catch (e) {
          // Continuer même si la vérification des achievements échoue
          debugPrint('Erreur lors de la vérification des achievements: $e');
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Journal enregistré avec succès !'),
              backgroundColor: WakyColors.success,
            ),
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: WakyColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _updateReport(DailyReport Function(DailyReport) updater) {
    setState(() {
      _editingReport = updater(_editingReport);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.report != null ? 'Modifier le journal' : 'Nouveau journal',
        ),
        actions: [
          if (widget.report != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date du rapport
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                        .format(_editingReport.date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // État global de la journée
              Text(
                'Comment s\'est passée cette journée ?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              _buildDayStatusSelector(context),

              const SizedBox(height: 32),

              // Sliders de niveau
              _buildLevelSection(
                context,
                title: 'Niveau de stress',
                value: _editingReport.stressLevel,
                onChanged: (value) {
                  _updateReport((r) => r.copyWith(stressLevel: value));
                  HapticService.selection();
                },
                labels: ['Très bas', 'Bas', 'Moyen', 'Élevé', 'Très élevé'],
                color: WakyColors.warning,
              ),

              const SizedBox(height: 24),

              _buildLevelSection(
                context,
                title: 'Niveau de fatigue',
                value: _editingReport.fatigueLevel,
                onChanged: (value) {
                  _updateReport((r) => r.copyWith(fatigueLevel: value));
                  HapticService.selection();
                },
                labels: ['En forme', 'Bien', 'Moyen', 'Fatigué', 'Épuisé'],
                color: WakyColors.info,
              ),

              const SizedBox(height: 32),

              // Transit
              Text(
                'Transit',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              _buildTransitSelector(context),

              const SizedBox(height: 24),

              // Nombre de selles
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Nombre de selles',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_editingReport.bowelMovements > 0) {
                            _updateReport((r) => r.copyWith(
                                bowelMovements: r.bowelMovements - 1));
                            HapticService.selection();
                          }
                        },
                      ),
                      Container(
                        width: 48,
                        alignment: Alignment.center,
                        child: Text(
                          '${_editingReport.bowelMovements}',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          _updateReport((r) =>
                              r.copyWith(bowelMovements: r.bowelMovements + 1));
                          HapticService.selection();
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Sommeil
              Text(
                'Sommeil (nuit précédente)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),

              _buildLevelSection(
                context,
                title: 'Qualité du sommeil',
                value: _editingReport.sleepQuality,
                onChanged: (value) {
                  _updateReport((r) => r.copyWith(sleepQuality: value));
                  HapticService.selection();
                },
                labels: ['Très mauvais', 'Mauvais', 'Moyen', 'Bon', 'Excellent'],
                color: WakyColors.primary,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.bedtime_outlined),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Heures de sommeil',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _editingReport.hoursSlept,
                      min: 6,
                      max: 11,
                      divisions: 5,
                      onChanged: (value) {
                        _updateReport((r) => r.copyWith(hoursSlept: value));
                      },
                    ),
                  ),
                  Text(
                    '${_editingReport.hoursSlept.toStringAsFixed(1)}h',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Notes
              Text(
                'Notes du jour',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              NotesField(
                value: _editingReport.notes,
                hintText: 'Comment s\'est passée votre journée ?',
                onChanged: (value) {
                  _updateReport(
                      (r) => r.copyWith(notes: value.isEmpty ? null : value));
                },
              ),

              const SizedBox(height: 32),

              // Bouton d'enregistrement
              WakyGradientButton(
                label: 'Enregistrer le journal',
                icon: Icons.save,
                isLoading: _isSaving,
                onPressed: _saveReport,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayStatusSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: DayStatus.values.map((status) {
        final isSelected = _editingReport.status == status;
        return GestureDetector(
          onTap: () {
            _updateReport((r) => r.copyWith(status: status));
            HapticService.selection();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(_editingReport.statusColorValue).withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(
                      color: Color(_editingReport.statusColorValue),
                      width: 2,
                    )
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  _getStatusEmoji(status),
                  style: TextStyle(fontSize: isSelected ? 32 : 24),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusShortName(status),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? Color(_editingReport.statusColorValue)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLevelSection(
    BuildContext context, {
    required String title,
    required int value,
    required ValueChanged<int> onChanged,
    required List<String> labels,
    required Color color,
  }) {
    return LevelSlider(
      label: title,
      value: value,
      onChanged: onChanged,
      activeColor: color,
      levelLabels: labels,
    );
  }

  Widget _buildTransitSelector(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TransitQuality.values.map((transit) {
        final isSelected = _editingReport.transitQuality == transit;
        return WakySelectButton(
          label: _getTransitName(transit),
          isSelected: isSelected,
          onTap: () {
            _updateReport((r) => r.copyWith(transitQuality: transit));
            HapticService.selection();
          },
        );
      }).toList(),
    );
  }

  String _getStatusEmoji(DayStatus status) {
    switch (status) {
      case DayStatus.excellent:
        return '😄';
      case DayStatus.good:
        return '🙂';
      case DayStatus.average:
        return '😐';
      case DayStatus.difficult:
        return '😔';
      case DayStatus.terrible:
        return '😢';
    }
  }

  String _getStatusShortName(DayStatus status) {
    switch (status) {
      case DayStatus.excellent:
        return 'Super';
      case DayStatus.good:
        return 'Bien';
      case DayStatus.average:
        return 'Moyen';
      case DayStatus.difficult:
        return 'Difficile';
      case DayStatus.terrible:
        return 'Dur';
    }
  }

  String _getTransitName(TransitQuality transit) {
    switch (transit) {
      case TransitQuality.normal:
        return 'Normal';
      case TransitQuality.diarrhea:
        return 'Diarrhée';
      case TransitQuality.constipation:
        return 'Constipation';
      case TransitQuality.mixed:
        return 'Alternance';
      case TransitQuality.none:
        return 'Pas de selles';
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le rapport'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce rapport journalier ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: WakyColors.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted && widget.report != null) {
      final success = await ref.read(dailyReportProvider.notifier).deleteReport(widget.report!.id);
      if (success && mounted) {
        HapticService.medium();
        ref.invalidate(recentReportsProvider);
        ref.invalidate(dailyReportProvider);
        ref.invalidate(todayReportProvider);
        ref.invalidate(consecutiveDaysProvider);
        ref.invalidate(wellbeingStatsProvider);
        Navigator.of(context).pop(true);
      }
    }
  }
}
