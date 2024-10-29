import 'dart:async';
import 'package:engpush/model/word/word_model.dart';
import 'package:engpush/util/aws_dynamodb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordProvider = AsyncNotifierProvider<WordNotifier, List<Word>>(() {
  return WordNotifier();
});

class WordNotifier extends AsyncNotifier<List<Word>> {
  // 初期化処理
  @override
  FutureOr<List<Word>> build() {
    return state.value ?? [];
  }

  final DynamodbUtil dynamodbUtil = DynamodbUtil();

  Future<void> fetchWordList(String wordBookId) async {
    // fetchedWordBookProviderのstateにすでにwordBookIdの単語があれば、関数を終了
    if (ref.read(fetchedWordBookProvider).contains(wordBookId)) {
      return;
    }

    //fetchedWordBookProvideのstateにwordBookIdを追加
    ref.read(fetchedWordBookProvider.notifier).addId(wordBookId);

    // ローディング状態に変更
    state = const AsyncLoading();

    final words =
        await AsyncValue.guard(() => dynamodbUtil.getWordList(wordBookId));

    state = words.when(
      data: (words) {
        return AsyncData([
          ...state.value ?? [],
          ...words.map((e) {
            return Word(
              wordBookId: e['WordBookId'],
              wordId: e['WordId'],
              word: e['Word'],
              mean: e['Mean'],
              partOfSpeech: e['PartOfSpeech'],
              lastNotified: e['LastNotified'],
              pushNotificationEnabled: e['PushNotificationEnabled'],
              notificationCount: e['NotificationCount'],
              createdAt: e['CreatedAt'],
              updatedAt: e['UpdatedAt'],
            );
          }).toList()
        ]);
      },
      loading: () => const AsyncLoading(),
      error: (err, stack) => AsyncError(err, stack),
    );
  }

  Future<void> addNewWord(Map<String, dynamic> newWord) async {
    final word = Word(
      wordBookId: newWord['WordBookId'],
      wordId: newWord['WordId'],
      word: newWord['Word'],
      mean: newWord['Mean'],
      partOfSpeech: newWord['PartOfSpeech'],
      lastNotified: newWord['LastNotified'],
      pushNotificationEnabled: newWord['PushNotificationEnabled'],
      notificationCount: newWord['NotificationCount'],
      createdAt: newWord['CreatedAt'],
      updatedAt: newWord['UpdatedAt'],
    );

    state = AsyncData([...state.value ?? [], word]);
  }

  Future<void> deleteWord(String wordId) async {
    // stateのwordIdが一致するWordを削除
    state = AsyncData(
        state.value?.where((element) => element.wordId != wordId).toList() ??
            []);
  }
}

// アプリ起動から初回Fetchした単語帳IDを保持するProvider
final fetchedWordBookProvider =
    StateNotifierProvider<FetchedWordBookNotifier, List<String>>(
        (ref) => FetchedWordBookNotifier());

class FetchedWordBookNotifier extends StateNotifier<List<String>> {
  FetchedWordBookNotifier() : super([]);

  void addId(String wordBookId) {
    state = [...state, wordBookId];
  }
}
