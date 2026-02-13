import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'core/database/database_service.dart';
import 'core/models/app_settings.dart' as settings;
import 'core/services/providers.dart';
import 'core/services/notification_service.dart';
import 'shared/theme/theme.dart';
import 'features/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize date formatting for French locale
  await initializeDateFormatting('fr_FR', null);
  
  // Initialize timezone
  tz.initializeTimeZones();
  
  // Récupère le nom de timezone via DateTime.now().timeZoneName
  final String timezoneName = DateTime.now().timeZoneName;
  try {
    tz.setLocalLocation(tz.getLocation(timezoneName));
  } catch (_) {
    // Fallback : cherche par offset UTC si le nom n'est pas reconnu
    final Duration offset = DateTime.now().timeZoneOffset;
    final String fallback = tz.timeZoneDatabase.locations.keys.firstWhere(
      (name) {
        final loc = tz.getLocation(name);
        return tz.TZDateTime.now(loc).timeZoneOffset == offset;
      },
      orElse: () => 'UTC',
    );
    tz.setLocalLocation(tz.getLocation(fallback));
  }
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Isar database
  final databaseService = DatabaseService.instance;
  await databaseService.initialize();
  
  // Initialize notification service
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  
  NotificationService.init(flutterLocalNotificationsPlugin);
  
  runApp(
    ProviderScope(
      overrides: [
        databaseServiceProvider.overrideWithValue(databaseService),
      ],
      child: const WakyGutApp(),
    ),
  );
}

class WakyGutApp extends ConsumerWidget {
  const WakyGutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsNotifierProvider);
    final appSettings = settingsAsync.valueOrNull;

    // Déterminer le mode de thème
    final themeMode = appSettings?.themeMode ?? settings.ThemeMode.system;

    // Utiliser uniquement le thème sobre
    final lightTheme = WakyTheme.soberLight;
    final darkTheme = WakyTheme.soberDark;

    // Convertir notre ThemeMode en Flutter ThemeMode
    final flutterThemeMode = _convertThemeMode(themeMode);

    return MaterialApp(
      title: 'WakyGut',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: flutterThemeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      locale: const Locale('fr', 'FR'),
      home: const HomeScreen(),
      builder: (context, child) {
        // Mise à jour du style de la barre système selon le thème actif
        final brightness = Theme.of(context).brightness;
        SystemChrome.setSystemUIOverlayStyle(
          brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
        );

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(appSettings?.textScale ?? 1.0),
          ),
          child: child!,
        );
      },
    );
  }

  ThemeMode _convertThemeMode(settings.ThemeMode mode) {
    switch (mode) {
      case settings.ThemeMode.light:
        return ThemeMode.light;
      case settings.ThemeMode.dark:
        return ThemeMode.dark;
      case settings.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}
