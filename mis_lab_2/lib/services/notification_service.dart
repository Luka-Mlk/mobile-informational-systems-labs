import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> printPendingNotifications() async {
    final pendingRequests = await _localNotificationsPlugin.pendingNotificationRequests();

    if (pendingRequests.isEmpty) {
      print('DEBUG: No pending scheduled notifications found.');
    } else {
      print('DEBUG: Found ${pendingRequests.length} pending scheduled notification(s):');
      for (var req in pendingRequests) {
        print('  - ID: ${req.id}, Title: ${req.title}, Payload: ${req.payload}');
      }
    }
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print('Notification payload received: ${response.payload}');
      },
    );

    tz.initializeTimeZones();
    // Attempt to set local location based on the host platform.
    tz.setLocalLocation(tz.local);

    // FIX: If tz.local incorrectly resolves to UTC, explicitly set it to a known European location.
    if (tz.local.name == 'UTC') {
      try {
        final location = tz.getLocation('Europe/Skopje');
        tz.setLocalLocation(location);
        print('DEBUG: Timezone fix applied: Switched from UTC to Europe/Skopje.');
      } catch (e) {
        print('DEBUG: Failed to load Europe/Skopje, remaining in UTC. Error: $e');
      }
    }

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for FCM');
    } else {
      print('User declined or has not yet granted permission');
    }
  }

  Future<void> scheduleDailyRecipeReminder({
    required int hour,
    required int minute,
    required int notificationId,
    required String title,
    required String body,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_recipe_channel',
      'Daily Recipe Reminder',
      channelDescription: 'Reminder to check the recipe of the day.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.cancel(notificationId);

    await _localNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.inexact,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_recipe_reminder',
    );

    print('DEBUG: Daily reminder scheduled for $hour:$minute in local time.');
    print('DEBUG: Calculated Scheduled Date (TZ): $scheduledDate');
    print('DEBUG: Current Local Timezone: ${tz.local.name}');
  }
}
