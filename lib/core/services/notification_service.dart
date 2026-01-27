import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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
    tz.setLocalLocation(tz.getLocation('Europe/Paris'));

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

  /// Programme la notification quotidienne du journal à 21h
  Future<void> scheduleDailyJournalReminder() async {
    await _notifications.zonedSchedule(
      0, // ID unique pour cette notification
      'Journal du jour 📝',
      'Prenez un moment pour noter votre journée',
      _nextInstanceOf21(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_journal',
          'Rappel journal quotidien',
          channelDescription: 'Rappel pour remplir le journal du jour',
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Calcule la prochaine occurrence de 21h
  tz.TZDateTime _nextInstanceOf21() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      21, // 21h
      0,  // 0 minutes
    );

    // Si 21h est déjà passé aujourd'hui, programme pour demain
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Annule toutes les notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Annule une notification spécifique
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// Vérifie si les notifications sont activées
  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      final enabled = await androidImplementation.areNotificationsEnabled();
      return enabled ?? false;
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

  /// Programme une notification de test du journal dans 1 minute
  Future<void> scheduleTestJournalReminder() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 1));
    
    await _notifications.zonedSchedule(
      998, // ID unique pour le test programmé
      'Test journal dans 1 minute ⏰',
      'Cette notification devrait apparaître dans 1 minute',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_journal',
          'Rappel journal quotidien',
          channelDescription: 'Rappel pour remplir le journal du jour',
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
    final next21h = _nextInstanceOf21();
    
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
      'next21hScheduled': next21h.toIso8601String(),
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
}
