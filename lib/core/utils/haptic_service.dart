import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Service de retour haptique
class HapticService {
  HapticService._();

  static bool _isEnabled = true;
  static bool? _hasVibrator;

  /// Active ou désactive le retour haptique
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Vérifie si l'appareil supporte la vibration
  static Future<bool> get hasVibrator async {
    if (_hasVibrator == null) {
      final result = await Vibration.hasVibrator();
      _hasVibrator = result == true;
    }
    return _hasVibrator!;
  }

  /// Retour haptique léger (sélection)
  static Future<void> light() async {
    if (!_isEnabled) return;
    
    if (await hasVibrator) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Retour haptique moyen (action)
  static Future<void> medium() async {
    if (!_isEnabled) return;
    
    if (await hasVibrator) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Retour haptique fort (confirmation importante)
  static Future<void> heavy() async {
    if (!_isEnabled) return;
    
    if (await hasVibrator) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Retour haptique de sélection
  static Future<void> selection() async {
    if (!_isEnabled) return;
    
    if (await hasVibrator) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Retour haptique de succès (double vibration)
  static Future<void> success() async {
    if (!_isEnabled) return;
    
    if (await hasVibrator) {
      await Vibration.vibrate(duration: 50);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 50);
    }
  }

  /// Retour haptique d'erreur (vibration longue)
  static Future<void> error() async {
    if (!_isEnabled) return;
    
    if (await hasVibrator) {
      await Vibration.vibrate(duration: 200);
    }
  }

  /// Retour haptique de notification
  static Future<void> notification() async {
    if (!_isEnabled) return;
    
    if (await hasVibrator) {
      await Vibration.vibrate(duration: 100);
    }
  }
}
