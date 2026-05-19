import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'shared/services/hive_service.dart';
import 'shared/services/notification_service.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/main_shell.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive via Service
  await HiveService.init();

  // Handle one-time reset for a "new start"
  final prefs = await SharedPreferences.getInstance();
  final isFirstStart = prefs.getBool('is_first_start_v2') ?? true;
  if (isFirstStart) {
    await HiveService.clearAllData();
    await prefs.setBool('is_first_start_v2', false);
  }
  
  // Initialize Notifications
  await NotificationService.init();

  // Set system UI overlay style for a seamless pitch-dark look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(
    const ProviderScope(
      child: ForgeRoutineApp(),
    ),
  );
}

class ForgeRoutineApp extends ConsumerWidget {
  const ForgeRoutineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainShell(),
    );
  }
}
