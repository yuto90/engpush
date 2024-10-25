import 'package:engpush/util/aws_dynamodb.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordBookProvider =
    StateNotifierProvider<WordBookNotifier, List<WordBook>>(
        (ref) => WordBookNotifier());

class WordBookNotifier extends StateNotifier<List<WordBook>> {
  WordBookNotifier() : super(const []);

  final DynamodbUtil dynamodbUtil = DynamodbUtil();

  Future<void> getWordBookList() async {
    final wordBooks = await dynamodbUtil.getWordBookList();

    List<WordBook> wordBookList = wordBooks.map((e) {
      return WordBook(
        name: e['Name'],
        wordBookId: e['WordBookId'],
        pushNotificationEnabled: e['PushNotificationEnabled'],
        lastWordIndex: e['LastWordIndex'],
        createdAt: e['CreatedAt'],
        updatedAt: e['UpdatedAt'],
      );
    }).toList();

    state = wordBookList;
  }
}
