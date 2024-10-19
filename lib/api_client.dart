import 'package:engpush/const.dart';
import 'package:engpush/error.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // todo: 環境によってURLを変更する
  static const String baseUrl =
      'https://aln6fgcqxj.execute-api.ap-northeast-1.amazonaws.com/dev';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json'
  };

  Future<SharedPreferences> _getPrefs() async =>
      await SharedPreferences.getInstance();

  Future<String?> _getCognitoIdToken() async {
    final prefs = await _getPrefs();
    final token = prefs.getString('cognitoIdToken');
    if (token == null) {
      throw TokenExpiredException();
    }
    return token;
  }

  void _handleResponse(http.Response response) {
    // 200番台以外だったらエラーに落とす
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load data from API');
    }
  }

  // 単語帳一覧取得
  // GET /word_book
  // Future<http.Response> getMessageList() async {
  //   final response =
  //       await http.get(Uri.parse('$baseUrl/messages'), headers: defaultHeaders);
  //   _handleResponse(response);
  //   return response;
  // }

  // 単語帳作成
  // POST /word_book
  Future<http.Response> createWordBook(String newWordBookName) async {
    final prefs = await _getPrefs();
    final cognitoIdToken = await _getCognitoIdToken();
    final userId = prefs.getString('cognitoUserId');

    //todo: cognitoIdTokenが期限切れだったら再度取得する
    if (cognitoIdToken == null) {
      throw Exception('cognitoIdToken is null');
    }

    final body = {
      'UserId': userId,
      'WordBookId': DateTime.now().millisecondsSinceEpoch.toString(),
      'Name': newWordBookName,
      'PushNotificationEnabled': false,
      'LastWordIndex': 0,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/word_book'),
      headers: {...defaultHeaders, 'Authorization': 'Bearer $cognitoIdToken'},
      body: jsonEncode(body),
    );

    _handleResponse(response);
    return response;
  }
}
