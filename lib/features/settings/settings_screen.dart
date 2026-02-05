import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/models/app_settings.dart' as models;
import '../../core/utils/haptic_service.dart';
import '../../core/services/providers.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import '../export/export_screen.dart';
import '../daily/daily_provider.dart';
import '../home/home_provider.dart';

/// Écran des paramètres
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsNotifierProvider);
    final settings = settingsAsync.valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Text(
                'Paramètres',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 24),

              // Section Apparence
              _buildSectionTitle(context, 'Apparence'),
              const SizedBox(height: 12),

              WakyCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    // Mode de thème
                    ListTile(
                      leading: const Icon(Icons.brightness_6),
                      title: const Text('Thème'),
                      subtitle: Text(_getThemeModeName(settings?.themeMode)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showThemeModeDialog(context, ref, settings),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Comportement
              _buildSectionTitle(context, 'Comportement'),
              const SizedBox(height: 12),

              WakyCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    // Retour haptique
                    ListTile(
                      leading: const Icon(Icons.vibration),
                      title: const Text('Retour haptique'),
                      subtitle: const Text('Vibrations au toucher'),
                      trailing: Switch(
                        value: settings?.hapticFeedback ?? true,
                        onChanged: (value) {
                          if (value) HapticService.selection();
                          ref.read(appSettingsNotifierProvider.notifier).setHapticFeedback(value);
                          HapticService.setEnabled(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Horaires des repas
              _buildSectionTitle(context, 'Horaires par défaut'),
              const SizedBox(height: 12),

              WakyCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    _buildMealTimeTile(
                      context,
                      ref,
                      icon: Icons.wb_sunny_outlined,
                      title: 'Petit-déjeuner',
                      time: settings?.breakfastTime ?? '08:00',
                      onTap: () => _showTimePicker(
                        context,
                        ref,
                        TimeOfDay(
                          hour: settings?.breakfastHour ?? 8,
                          minute: settings?.breakfastMinute ?? 0,
                        ),
                        (time) async {
                          await ref.read(appSettingsNotifierProvider.notifier).updateSettings(
                            (settings ?? models.AppSettings()).copyWith(
                              breakfastHour: time.hour,
                              breakfastMinute: time.minute,
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    _buildMealTimeTile(
                      context,
                      ref,
                      icon: Icons.wb_sunny,
                      title: 'Déjeuner',
                      time: settings?.lunchTime ?? '12:30',
                      onTap: () => _showTimePicker(
                        context,
                        ref,
                        TimeOfDay(
                          hour: settings?.lunchHour ?? 12,
                          minute: settings?.lunchMinute ?? 30,
                        ),
                        (time) async {
                          await ref.read(appSettingsNotifierProvider.notifier).updateSettings(
                            (settings ?? models.AppSettings()).copyWith(
                              lunchHour: time.hour,
                              lunchMinute: time.minute,
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    _buildMealTimeTile(
                      context,
                      ref,
                      icon: Icons.nights_stay,
                      title: 'Dîner',
                      time: settings?.dinnerTime ?? '19:30',
                      onTap: () => _showTimePicker(
                        context,
                        ref,
                        TimeOfDay(
                          hour: settings?.dinnerHour ?? 19,
                          minute: settings?.dinnerMinute ?? 30,
                        ),
                        (time) async {
                          await ref.read(appSettingsNotifierProvider.notifier).updateSettings(
                            (settings ?? models.AppSettings()).copyWith(
                              dinnerHour: time.hour,
                              dinnerMinute: time.minute,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Export
              _buildSectionTitle(context, 'Données'),
              const SizedBox(height: 12),

              WakyCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: const Text('Exporter en PDF'),
                      subtitle: const Text('Rapport pour votre médecin'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        HapticService.light();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ExportScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.backup),
                      title: const Text('Sauvegarder les données'),
                      subtitle: Text(
                        settings?.lastBackupDate != null
                            ? 'Dernière: ${_formatDate(settings!.lastBackupDate!)}'
                            : 'Jamais sauvegardé',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _backupData(context, ref),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Administration
              _buildSectionTitle(context, 'Administration'),
              const SizedBox(height: 12),

              WakyCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Réinitialiser toutes les données'),
                      subtitle: const Text('Supprime tous vos journaux, repas et douleurs'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmResetDatabase(context, ref),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section À propos
              _buildSectionTitle(context, 'À propos'),
              const SizedBox(height: 12),

              WakyCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('🦊', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WakyGut',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Version 1.0.0',
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
                    Text(
                      'Application de suivi médical digestif personnel.\n'
                      'Ce n\'est pas un dispositif médical.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Bouton de réinitialisation
              Center(
                child: TextButton.icon(
                  onPressed: () => _confirmReset(context, ref),
                  icon: const Icon(Icons.restore, color: Colors.red),
                  label: const Text(
                    'Réinitialiser les paramètres',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildMealTimeTile(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  String _getThemeModeName(models.ThemeMode? mode) {
    switch (mode) {
      case models.ThemeMode.light:
        return 'Clair';
      case models.ThemeMode.dark:
        return 'Sombre';
      case models.ThemeMode.system:
      case null:
        return 'Système';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showThemeModeDialog(BuildContext context, WidgetRef ref, models.AppSettings? settings) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final currentSettings = ref.read(appSettingsNotifierProvider).valueOrNull;
          return AlertDialog(
            title: const Text('Thème'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: models.ThemeMode.values.map((mode) {
                return RadioListTile<models.ThemeMode>(
                  title: Text(_getThemeModeName(mode)),
                  value: mode,
                  groupValue: currentSettings?.themeMode ?? models.ThemeMode.system,
                  onChanged: (value) {
                    HapticService.selection();
                    ref.read(appSettingsNotifierProvider.notifier).setThemeMode(value!);
                    setState(() {}); // Rafraîchit l'UI de la dialog
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay initialTime,
    Future<void> Function(TimeOfDay) onSave,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (time != null) {
      await onSave(time);
      HapticService.success();
    }
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser ?'),
        content: const Text(
          'Tous vos paramètres seront remis aux valeurs par défaut.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(appSettingsNotifierProvider.notifier).resetSettings();
              Navigator.of(context).pop();
              HapticService.medium();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }

  void _confirmResetDatabase(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Attention'),
        content: const Text(
          'Cette action va supprimer TOUTES vos données :\n\n'
          '• Tous les journaux\n'
          '• Tous les repas\n'
          '• Toutes les douleurs\n'
          '• Tous les aliments\n'
          '• Tous les badges\n\n'
          'Cette action est IRRÉVERSIBLE !',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _resetDatabase(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Tout supprimer'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetDatabase(BuildContext context, WidgetRef ref) async {
    try {
      // Importer le service de base de données
      final dbService = ref.read(databaseServiceProvider);
      
      // Effacer toutes les données
      await dbService.clearAll();
      
      // Invalider tous les providers pour forcer le rechargement
      ref.invalidate(dailyReportProvider);
      ref.invalidate(todayReportProvider);
      ref.invalidate(recentReportsProvider);
      ref.invalidate(consecutiveDaysProvider);
      ref.invalidate(wellbeingStatsProvider);
      ref.invalidate(allAchievementsProvider);
      ref.invalidate(upcomingMealsCountProvider);
      
      HapticService.heavy();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Base de données réinitialisée avec succès'),
            backgroundColor: WakyColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur : $e'),
            backgroundColor: WakyColors.error,
          ),
        );
      }
    }
  }

  Future<void> _backupData(BuildContext context, WidgetRef ref) async {
    try {
      HapticService.medium();
      
      // Afficher un indicateur de chargement
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Création de la sauvegarde...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Exporter les données
      final dbService = ref.read(databaseServiceProvider);
      final jsonData = await dbService.exportToJson();
      
      // Convertir en JSON formaté
      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(jsonData);
      
      // Créer un fichier temporaire
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final file = File('${directory.path}/wakygut_backup_$timestamp.json');
      await file.writeAsString(jsonString);
      
      // Mettre à jour la date de dernière sauvegarde
      final settings = ref.read(appSettingsNotifierProvider).valueOrNull;
      if (settings != null) {
        await ref.read(appSettingsNotifierProvider.notifier).updateSettings(
          settings.copyWith(lastBackupDate: DateTime.now()),
        );
      }
      
      // Fermer le dialogue de chargement
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // Partager le fichier
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Sauvegarde WakyGut',
        text: 'Sauvegarde de vos données WakyGut du ${_formatDate(DateTime.now())}',
      );
      
      HapticService.success();
      
      if (context.mounted && result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sauvegarde créée et partagée avec succès !'),
            backgroundColor: WakyColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Fermer le dialogue de chargement en cas d'erreur
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur lors de la sauvegarde : $e'),
            backgroundColor: WakyColors.error,
          ),
        );
      }
    }
  }
}
