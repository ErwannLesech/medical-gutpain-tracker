import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service de gestion des notifications locales
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialise le service de notifications
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialise les fuseaux horaires
    tz.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Gère le tap sur une notification
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navigation vers l'écran du journal
    print('Notification tapped: ${response.payload}');
  }

  /// Demande les permissions de notification (iOS)
  Future<bool> requestPermissions() async {
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Envoie une notification de test immédiatement
  Future<void> showTestNotification() async {
    await _notifications.show(
      999, // ID unique pour le test
      'Test de notification 🔔',
      'Si vous voyez ceci, les notifications fonctionnent !',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_notifications',
          'Notifications de test',
          channelDescription: 'Notifications de test pour vérifier la configuration',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// Obtient des informations de diagnostic sur les notifications
  Future<Map<String, dynamic>> getDiagnostics() async {
    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    bool? notificationsEnabled;
    bool? exactAlarmsEnabled;
    
    if (androidImpl != null) {
      notificationsEnabled = await androidImpl.areNotificationsEnabled();
      // Android 12+ requiert la permission SCHEDULE_EXACT_ALARM
      try {
        exactAlarmsEnabled = await androidImpl.canScheduleExactNotifications();
      } catch (e) {
        exactAlarmsEnabled = null;
      }
    }

    final pendingNotifications = await _notifications.pendingNotificationRequests();
    
    return {
      'initialized': _initialized,
      'notificationsEnabled': notificationsEnabled,
      'exactAlarmsEnabled': exactAlarmsEnabled,
      'pendingNotificationsCount': pendingNotifications.length,
      'pendingNotifications': pendingNotifications.map((n) => {
        'id': n.id,
        'title': n.title,
        'body': n.body,
      }).toList(),
      'timezone': tz.local.name,
    };
  }

  /// Demande la permission pour les alarmes exactes (Android 12+)
  Future<bool> requestExactAlarmPermission() async {
    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImpl != null) {
      try {
        final canSchedule = await androidImpl.canScheduleExactNotifications();
        if (canSchedule == false) {
          // Ouvre les paramètres système pour activer la permission
          await androidImpl.requestExactAlarmsPermission();
          return await androidImpl.canScheduleExactNotifications() ?? false;
        }
        return canSchedule ?? false;
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  // CORRECTION 1 : ID fixe par type de notif pour pouvoir annuler/remplacer
  static const int _dailyNotificationId = 1;

  /// Planifie une notification journalière de rappel
  Future<void> scheduleDailyNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // CORRECTION 2 : androidScheduleMode en exactAllowWhileIdle
    // pour déclencher même en mode Doze (app killed)
    await _notifications.zonedSchedule(
      _dailyNotificationId,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Rappel journalier',
          channelDescription: 'Notification quotidienne pour remplir le journal',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // ✅ exact + passe en mode Doze/battery saver
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // CORRECTION 3 : matchDateTimeComponents pour répétition journalière
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Calcule le prochain déclenchement à l'heure choisie
  /// Si l'heure est déjà passée aujourd'hui → demain
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
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
  Future<void> cancelDailyNotification() async {
    await _notifications.cancel(_dailyNotificationId);
  }
}
