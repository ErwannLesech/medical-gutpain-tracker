import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service de gestion des notifications locales
class NotificationService {
  static late FlutterLocalNotificationsPlugin _plugin;

  /// Initialise le plugin (appelé depuis main.dart)
  static void init(FlutterLocalNotificationsPlugin plugin) {
    _plugin = plugin;
  }

  static const int _dailyNotificationId = 1;

  /// Détails de la notification Android
  static AndroidNotificationDetails _androidDetails() {
    return const AndroidNotificationDetails(
      'daily_reminder',
      'Rappel journalier',
      channelDescription: 'Notification quotidienne pour remplir le journal',
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  /// Détails de la notification
  static NotificationDetails _notificationDetails() {
    return NotificationDetails(android: _androidDetails());
  }

  /// Planifie une notification journalière de rappel
  static Future<void> scheduleDailyNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _plugin.zonedSchedule(
      _dailyNotificationId,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // ✅ exact + passe en mode Doze/battery saver
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // ✅ matchDateTimeComponents pour répétition journalière
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Calcule le prochain déclenchement à l'heure choisie
  /// Si l'heure est déjà passée aujourd'hui → demain
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Annule la notification journalière
  static Future<void> cancelDailyNotification() async {
    await _plugin.cancel(_dailyNotificationId);
  }
}
