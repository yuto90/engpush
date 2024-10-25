import 'package:engpush/model/word/word_model.dart';
import 'package:engpush/util/aws_dynamodb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordProvider =
    StateNotifierProvider<WordNotifier, List<Word>>((ref) => WordNotifier());

class WordNotifier extends StateNotifier<List<Word>> {
  WordNotifier() : super(const []);

  final DynamodbUtil dynamodbUtil = DynamodbUtil();

  Future<void> getWordList(String wordBookId) async {
    final words = await dynamodbUtil.getWordList(wordBookId);

    List<Word> wordList = words.map((e) {
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
    }).toList();

    state = wordList;
  }
}
