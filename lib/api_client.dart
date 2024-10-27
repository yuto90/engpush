import 'dart:convert';
import 'package:engpush/error.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String _baseUrl =
      'https://aln6fgcqxj.execute-api.ap-northeast-1.amazonaws.com/dev';
  final Map<String, String> _defaultHeaders = {
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

  void _handleResponse(http.Response response, String methodName) {
    print(methodName);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Failed to $methodName: ${response.statusCode} ${response.body}');
    }
  }

  String _buildEndpoint(
      String endpointTemplate, Map<String, String>? pathParams) {
    if (pathParams == null) return endpointTemplate;
    pathParams.forEach((key, value) {
      endpointTemplate = endpointTemplate.replaceAll('{$key}', value);
    });
    return endpointTemplate;
  }

  Future<http.Response> get({
    required String endpointTemplate,
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
  }) async {
    //todo: cognitoIdTokenが期限切れだったら再度取得する
    final cognitoIdToken = await _getCognitoIdToken();
    final endpoint = _buildEndpoint(endpointTemplate, pathParams);
    final uri =
        Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $cognitoIdToken'},
    );
    _handleResponse(response, 'GET $endpoint');
    return response;
  }

  Future<http.Response> post({
    required String endpointTemplate,
    Map<String, String>? pathParams,
    dynamic body,
  }) async {
    final cognitoIdToken = await _getCognitoIdToken();
    final endpoint = _buildEndpoint(endpointTemplate, pathParams);

    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $cognitoIdToken'},
      body: jsonEncode(body),
    );
    _handleResponse(response, 'POST $endpoint');
    return response;
  }

  Future<http.Response> put({
    required String endpointTemplate,
    Map<String, String>? pathParams,
    dynamic body,
  }) async {
    final cognitoIdToken = await _getCognitoIdToken();
    final endpoint = _buildEndpoint(endpointTemplate, pathParams);
    final response = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $cognitoIdToken'},
      body: jsonEncode(body),
    );
    _handleResponse(response, 'PUT $endpoint');
    return response;
  }

  Future<http.Response> delete({
    required String endpointTemplate,
    Map<String, String>? pathParams,
  }) async {
    final cognitoIdToken = await _getCognitoIdToken();
    final endpoint = _buildEndpoint(endpointTemplate, pathParams);
    final response = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $cognitoIdToken'},
    );
    _handleResponse(response, 'DELETE $endpoint');
    return response;
  }
}
