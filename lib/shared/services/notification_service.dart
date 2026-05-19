import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'hive_service.dart';
import '../../core/constants/routine_data.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );

    // Schedule all standard notifications
    await scheduleDailyRoutineNotifications();
    await schedulePostureReminders();
  }

  static Future<void> schedulePostureReminders() async {
    final enabled = HiveService.getSetting('notificationsEnabled', defaultValue: true);
    if (!enabled) return;

    final customBlocks = HiveService.getRoutineBlocks();
    final blocks = customBlocks.isEmpty ? RoutineData.defaultBlocks : customBlocks;
    
    int reminderId = 200; // Starting ID for posture reminders

    for (var block in blocks) {
      if (block.name.toLowerCase().contains('study') || block.name.toLowerCase().contains('deep work')) {
        // Assume study blocks might be long, check every 2 hours
        final startParts = block.startTime.split(':');
        final endParts = block.endTime.split(':');
        
        int startHour = int.parse(startParts[0]);
        int endHour = int.parse(endParts[0]);
        
        // If endHour is less than startHour, it wraps to next day (unlikely for study but possible)
        if (endHour < startHour) endHour += 24;

        for (int h = startHour + 2; h < endHour; h += 2) {
          await _scheduleNotification(
            id: reminderId++,
            title: 'Posture Check 🧘',
            body: 'Straighten your back. Hydrate. Keep forging.',
            scheduledDate: _nextInstanceOfTime(h % 24, 0),
          );
        }
      }
    }
  }

  static Future<void> scheduleDailyRoutineNotifications() async {
    // Check if notifications are enabled in settings
    final enabled = HiveService.getSetting('notificationsEnabled', defaultValue: true);
    if (!enabled) {
      await _notifications.cancelAll();
      return;
    }

    // Clear existing to avoid duplicates
    await _notifications.cancelAll();

    final customBlocks = HiveService.getRoutineBlocks();
    final blocks = customBlocks.isEmpty ? RoutineData.defaultBlocks : customBlocks;

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final timeParts = block.startTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Schedule 5 minutes before
      var scheduleTime = DateTime(2000, 1, 1, hour, minute).subtract(const Duration(minutes: 5));

      await _scheduleNotification(
        id: i + 1,
        title: 'Incoming: ${block.name}',
        body: 'Starts at ${block.startTime}. Prepare yourself.',
        scheduledDate: _nextInstanceOfTime(scheduleTime.hour, scheduleTime.minute),
      );
    }
    
    // Add a sleep/wind-down notification
    await _scheduleNotification(
      id: 99,
      title: 'Wind Down',
      body: 'Journal. Reflect. Tomorrow is earned tonight.',
      scheduledDate: _nextInstanceOfTime(21, 00),
    );
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'routine_reminders',
        'Routine Reminders',
        channelDescription: 'Notifications for daily discipline blocks',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on PlatformException catch (error) {
      if (error.code != 'exact_alarms_not_permitted') {
        rethrow;
      }

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
