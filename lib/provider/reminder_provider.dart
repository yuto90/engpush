import 'package:engpush/model/reminder/reminder_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reminderProvider =
    StateNotifierProvider.autoDispose<ReminderNotifier, Reminder>(
        (ref) => ReminderNotifier());

class ReminderNotifier extends StateNotifier<Reminder> {
  ReminderNotifier() : super(const Reminder(number: 1, time: 0));

  void changeNumber(int selectedIndex) {
    state = state.copyWith(number: selectedIndex);
  }

  void changeTime(int selectedIndex) {
    state = state.copyWith(time: selectedIndex);
  }
}
