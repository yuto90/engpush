import 'dart:async';

import 'package:engpush/util/aws_dynamodb.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 非同期操作の結果を提供しつつ、複雑な状態管理を行うためのプロバイダー
final wordBookProvider =
    AsyncNotifierProvider<WordBookNotifier, List<WordBook>>(() {
  return WordBookNotifier();
});

class WordBookNotifier extends AsyncNotifier<List<WordBook>> {
  // 初期化処理
  @override
  FutureOr<List<WordBook>> build() async {
    await fetchWordBookList();
    return state.value ?? [];
  }

  final DynamodbUtil dynamodbUtil = DynamodbUtil();

  Future<void> fetchWordBookList() async {
    state = const AsyncLoading();

    // try-catchブロックを書くことなく、Futureの成功時と失敗時の両方を適切に処理できる
    final wordBooks =
        await AsyncValue.guard(() => dynamodbUtil.getWordBookList());

    state = wordBooks.when(
      data: (wordBooks) {
        return AsyncData(wordBooks.map((e) {
          return WordBook(
            name: e['Name'],
            wordBookId: e['WordBookId'],
            pushNotificationEnabled: e['PushNotificationEnabled'],
            lastWordIndex: e['LastWordIndex'],
            createdAt: e['CreatedAt'],
            updatedAt: e['UpdatedAt'],
          );
        }).toList());
      },
      loading: () => const AsyncLoading(),
      error: (err, stack) => AsyncError(err, stack),
    );
  }
}
