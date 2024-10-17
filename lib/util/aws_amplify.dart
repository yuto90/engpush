import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ユーザーが認証されているかどうかを確認する関数
Future<bool> isAuthenticated() async {
  try {
    // 現在の認証セッションを取得
    final session = await Amplify.Auth.fetchAuthSession();
    // ユーザーがサインインしているかどうかを返す
    return session.isSignedIn;
  } catch (e) {
    // 例外が発生した場合、エラーメッセージをログに記録し、falseを返す
    print('Error fetching auth session: $e');
    return false;
  }
}

/// Google認証を行う関数
Future<bool> signInWithGoogle() async {
  try {
    SignInResult res = await Amplify.Auth.signInWithWebUI(
      provider: AuthProvider.google,
    );

    final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    final result = await cognitoPlugin.fetchAuthSession();
    final idToken = result.userPoolTokensResult.value.idToken;

    // 取得したCognitoのIDトークンをローカルに保存
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cognitoIdToken', idToken.raw.toString());

    return res.isSignedIn;
  } catch (e) {
    // 例外が発生した場合、エラーメッセージをログに記録し、falseを返す
    print('Error signInWithGoogle: $e');
    return false;
  }
}

/// Cognitoに認証しているユーザーを取得する関数
Future<String> getCognitoCurrentUser() async {
  try {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    String userId = authUser.userId;
    // String username = authUser.username;
    // dynamic signInDetails = authUser.signInDetails;

    return userId;
  } catch (e) {
    // 例外が発生した場合、エラーメッセージをログに記録し、falseを返す
    print('Error getCognitoCurrentUser: $e');
    return '';
  }
}
