import 'package:engpush/api_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DynamodbUtil {
  // todo: 環境によってURLを変更する
  final _apiClient = ApiClient();

  /// /word_book ==========================================
  ///

  // 単語帳一覧取得
  // GET /word_book
  Future<List<Map<String, dynamic>>> getWordBookList() async {
    final response = await _apiClient.get(
      endpointTemplate: '/word_book',
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  // 単語帳作成
  // POST /word_book
  // todo: レスポンスをただ返すだけじゃなくてデータを直接返していいかも
  Future<http.Response> createWordBook(String newWordBookName) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('cognitoUserId');

    final body = {
      'UserId': userId,
      'WordBookId': userId! + DateTime.now().millisecondsSinceEpoch.toString(),
      'Name': newWordBookName,
      'PushNotificationEnabled': false,
      'LastWordIndex': 0,
    };

    final response = await _apiClient.post(
      endpointTemplate: '/word_book',
      body: body,
    );

    return response;
  }

  /// /word ==========================================
  ///

  // 単語一覧取得
  // GET /word/{word_book_Id}
  Future<List<Map<String, dynamic>>> getWordList(String wordBookId) async {
    final response = await _apiClient.get(
      endpointTemplate: '/word/{word_book_Id}',
      pathParams: {'word_book_Id': wordBookId},
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  // 単語登録
  // GET /word/{word_book_Id}
  Future<Map<String, dynamic>> createWord(
    String wordBookId,
    String word,
    String mean,
    String partOfSpeech,
  ) async {
    final body = {
      'WordId': wordBookId + DateTime.now().millisecondsSinceEpoch.toString(),
      "Word": word,
      "Mean": mean,
      "PartOfSpeech": partOfSpeech,
    };

    final response = await _apiClient.post(
      endpointTemplate: '/word/{word_book_Id}',
      pathParams: {'word_book_Id': wordBookId},
      body: body,
    );

    return json.decode(response.body);
  }

  // 単語更新
  // PUT /word/{word_book_Id}
  Future<Map<String, dynamic>> updateWord(
    String wordBookId,
    String wordId,
    String newWord,
    String newMean,
    String newPartOfSpeech,
  ) async {
    final body = {
      'WordId': wordId,
      "NewWord": newWord,
      "NewMean": newMean,
      "NewPartOfSpeech": newPartOfSpeech,
    };

    final response = await _apiClient.put(
      endpointTemplate: '/word/{word_book_Id}',
      pathParams: {'word_book_Id': wordBookId},
      body: body,
    );

    return json.decode(response.body);
  }
}
