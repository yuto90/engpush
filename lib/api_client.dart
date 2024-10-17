import 'package:engpush/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// todo: エラーハンドリングを追加する
class ApiClient {
  dynamic headers = const {'Content-Type': 'application/json'};

  void _handleResponse(http.Response response) {
    // 200番台以外だったらエラーに落とす
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load data from API');
    }
  }

  // 単語帳一覧取得
  // GET /word_book
  Future<http.Response> getMessageList() async {
    final response =
        await http.get(Uri.parse('$baseUrl/messages'), headers: headers);
    _handleResponse(response);
    return response;
  }

  // 単語帳作成
  // POST /word_book
  Future<http.Response> createWordBook(String newWordBookName) async {
    final prefs = await SharedPreferences.getInstance();
    final cognitoIdToken = prefs.getString('cognitoIdToken');
    final userId = prefs.getString('cognitoUserId');

    //todo: cognitoIdTokenが期限切れだったら再度取得する
    if (cognitoIdToken == null) {
      throw Exception('cognitoIdToken is null');
    }

    final body = {
      'UserId': userId,
      'WordBookId': "3",
      'Name': newWordBookName,
      'PushNotificationEnabled': false,
      'LastWordIndex': 0,
    };

    final response = await http.post(
      Uri.parse(
          'https://aln6fgcqxj.execute-api.ap-northeast-1.amazonaws.com/dev/word_book'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $cognitoIdToken',
      },
      body: jsonEncode(body),
    );

    _handleResponse(response);
    return response;
  }
}
