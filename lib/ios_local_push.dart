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

  // 即時に通知を送るメソッド
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

  // 単発通知をスケジュールするメソッド
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

  // 通知を繰り返しスケジュールするメソッド
  Future<void> scheduleRepeatingNotification(
      String title, String body, Duration repeatInterval) async {
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.everyMinute, // 繰り返し間隔を設定
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  // 特定のIDの通知をキャンセルするメソッド
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // すべての通知をキャンセルするメソッド
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // 予約済みの通知を取得するメソッド
  Future<void> getScheduled() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var pendingNotificationRequest in pendingNotificationRequests) {
      print(
          '予約済みの通知: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, payload: ${pendingNotificationRequest.payload}]');
    }
  }
}
