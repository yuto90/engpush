import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs
@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required int number,
    required int time,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}
