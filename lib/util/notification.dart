import 'package:engpush/ios_local_push.dart';

/// 通知をスケジュールする関数
/// ex)
/// schedulePush('通知タイトル','スケジュールされた通知本文');
Future<void> schedulePush(String title, String body) async {
  final IOSLocalPush _iosLocalPush = IOSLocalPush();

  int id = DateTime.now().millisecondsSinceEpoch;

  DateTime scheduledTime = DateTime.now().add(Duration(minutes: 1));

  await _iosLocalPush.scheduleNotification(id, title, body, scheduledTime);
}
