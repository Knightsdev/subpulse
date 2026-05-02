import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'features/subscriptions/providers/subscription_provider.dart';
import 'features/settings/providers/settings_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  await StorageService.init();
  
  await NotificationService.init();
  
  await MobileAds.instance.initialize();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    ProviderScope(
      overrides: [
        subscriptionProvider.overrideWith((ref) => SubscriptionNotifier()),
        settingsProvider.overrideWith((ref) => SettingsNotifier()),
      ],
      child: const SubPulseApp(),
    ),
  );
}