import 'package:engpush/api_client.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordBookProvider =
    StateNotifierProvider.autoDispose<WordBookNotifier, List<WordBook>>(
        (ref) => WordBookNotifier());

class WordBookNotifier extends StateNotifier<List<WordBook>> {
  WordBookNotifier() : super(const [WordBook()]);

  final ApiClient apiClient = ApiClient();

  Future<void> getWordBookList() async {
    final wordBooks = await apiClient.getWordBookList();

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