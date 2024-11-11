import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engpush/provider/word_provider.dart';
import 'package:engpush/model/word/word_model.dart';
import 'package:engpush/provider/reminder_provider.dart';
import 'package:engpush/ios_local_push.dart';

final wordBookDetailViewModelProvider = Provider((ref) {
  return WordBookDetailViewModel(ref);
});

final checkedWordsProvider = StateProvider<Set<String>>((ref) => {});

class WordBookDetailViewModel {
  final ProviderRef ref;
  final IOSLocalPush iosLocalPush = IOSLocalPush();
  final List<String> numbers =
      List.generate(59, (index) => (index + 1).toString());
  final List<String> times = ["時間", "分", "秒"];

  WordBookDetailViewModel(this.ref);

  Future<void> fetchWords(String wordBookId) async {
    await ref.read(wordProvider.notifier).fetchWordList(wordBookId);
  }

  List<Word> filterWords(List<Word> words, String wordBookId) {
    return words.where((word) => word.wordBookId == wordBookId).toList();
  }

  void scheduleReminder() {
    final reminder = ref.read(reminderProvider);
    iosLocalPush.scheduleNotification(
      '通知タイトル',
      '通知内容',
      DateTime.now().add(
        Duration(
          hours: reminder.time == 0 ? reminder.number : 0,
          minutes: reminder.time == 1 ? reminder.number : 0,
          seconds: reminder.time == 2 ? reminder.number : 0,
        ),
      ),
    );
    print(reminder);
  }

  void scheduleRepeatingReminder() {
    final reminder = ref.read(reminderProvider);
    final repeatInterval = Duration(
      hours: reminder.time == 0 ? reminder.number : 0,
      minutes: reminder.time == 1 ? reminder.number : 0,
      seconds: reminder.time == 2 ? reminder.number : 0,
    );

    // todo: 任意の間隔で通知を繰り返す
    // 現状1分毎固定
    iosLocalPush.scheduleRepeatingNotification(
      '繰り返し通知タイトル',
      '繰り返し通知内容',
      repeatInterval,
    );
    print('繰り返しリマインダーを設定しました: $reminder');
  }

  void cancelReminder() {
    iosLocalPush.cancelNotification(0);
    print('リマインダーを解除しました');
  }

  void toggleWordCheck(String wordId) {
    final checkedWords = ref.read(checkedWordsProvider).toSet();
    if (checkedWords.contains(wordId)) {
      checkedWords.remove(wordId);
    } else {
      checkedWords.add(wordId);
    }
    ref.read(checkedWordsProvider.notifier).state = checkedWords;
  }

  bool isWordChecked(String wordId) {
    return ref.read(checkedWordsProvider).contains(wordId);
  }
}
