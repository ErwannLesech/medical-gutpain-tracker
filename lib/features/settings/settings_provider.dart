import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../../core/models/app_settings.dart' as models;
import '../../core/database/repositories/repositories.dart';
import '../../core/services/providers.dart';

/// État des paramètres de l'application
class SettingsState {
  final models.AppSettings? settings;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.settings,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    models.AppSettings? settings,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier pour la gestion des paramètres
class SettingsNotifier extends StateNotifier<SettingsState> {
  final AppSettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const SettingsState()) {
    loadSettings();
  }

  /// Charge les paramètres
  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final settings = await _repository.get();
      state = state.copyWith(settings: settings, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Met à jour les paramètres
  Future<bool> updateSettings(models.AppSettings Function(models.AppSettings) updater) async {
    try {
      final current = state.settings ?? models.AppSettings();
      final updated = updater(current);
      await _repository.save(updated);
      state = state.copyWith(settings: updated);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Change le mode de thème
  Future<void> setThemeMode(models.ThemeMode mode) async {
    await updateSettings((s) => s.copyWith(themeMode: mode));
  }

  /// Active/désactive le retour haptique
  Future<void> setHapticFeedback(bool enabled) async {
    await updateSettings((s) => s.copyWith(hapticFeedback: enabled));
  }

  /// Réinitialise les paramètres
  Future<void> resetSettings() async {
    try {
      final settings = await _repository.reset();
      state = state.copyWith(settings: settings);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provider des paramètres
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref.watch(appSettingsRepositoryProvider));
});

/// Provider du mode de thème Flutter
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsProvider).settings;
  if (settings == null) return ThemeMode.system;
  
  switch (settings.themeMode) {
    case models.ThemeMode.light:
      return ThemeMode.light;
    case models.ThemeMode.dark:
      return ThemeMode.dark;
    case models.ThemeMode.system:
      return ThemeMode.system;
  }
});
