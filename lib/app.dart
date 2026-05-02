import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/subscriptions/providers/subscription_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/home/screens/home_screen.dart';
import 'features/onboarding/screens/splash_screen.dart';

class SubPulseApp extends ConsumerWidget {
  const SubPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;
    
    return MaterialApp(
      title: 'SubPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}