class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() {
    return 'ApiException{statusCode: $statusCode, message: $message}';
  }
}

class TokenExpiredException implements Exception {}

class NetworkException implements Exception {}
