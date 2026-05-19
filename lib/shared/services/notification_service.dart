import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  }

  static Future<void> scheduleDailyRoutineNotifications() async {
    // Clear existing to avoid duplicates
    await _notifications.cancelAll();

    final List<Map<String, dynamic>> schedule = [
      {
        'id': 1,
        'time': '03:50',
        'title': 'Rise & Forge',
        'body': '4 AM. Your future self is already awake.'
      },
      {
        'id': 2,
        'time': '04:25',
        'title': 'Deep Work',
        'body': 'Study Block 1 starts. No phone.'
      },
      {
        'id': 3,
        'time': '06:25',
        'title': 'Body Discipline',
        'body': 'Workout time. No excuses.'
      },
      {
        'id': 4,
        'time': '17:25',
        'title': 'Focus Reset',
        'body': 'Evening study block. Show up.'
      },
      {
        'id': 5,
        'time': '20:50',
        'title': 'Wind Down',
        'body': 'Journal. Reflect. Sleep wins.'
      },
      {
        'id': 6,
        'time': '21:25',
        'title': 'Lights Out',
        'body': 'Tomorrow starts now. Sleep.'
      },
    ];

    for (var item in schedule) {
      final timeParts = (item['time'] as String).split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      await _scheduleNotification(
        id: item['id'] as int,
        title: item['title'] as String,
        body: item['body'] as String,
        scheduledDate: _nextInstanceOfTime(hour, minute),
      );
    }
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
