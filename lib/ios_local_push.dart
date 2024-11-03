import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class IOSLocalPush {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  IOSLocalPush() {
    _initializeNotifications();
    tz.initializeTimeZones();
    // デバイスのタイムゾーンを取得する
    local = tz.local;
  }

  late final tz.Location local;

  void _initializeNotifications() async {
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Future<void> showNotification(int id, String title, String body) async {
  //   const DarwinNotificationDetails iOSPlatformChannelSpecifics =
  //       DarwinNotificationDetails();
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(iOS: iOSPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //     id,
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //   );
  // }

  // 即時に通知を送る関数
  Future<void> showImmediateNotification(String title, String body) async {
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // 通知IDを0に設定
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // 通知をスケジュールする関数
  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledTime) async {
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    // TZDateTimeに変換する
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
