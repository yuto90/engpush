import 'package:engpush/util/aws_amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  @override
  void initState() {
    super.initState();
    // todo: セッションの有効期限を確認
    // todo: 認証済みとアクセストークンの期限は同期してないっぽい
    // _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // 認証済みかどうかを確認
    final session = await isAuthenticated();
    if (session) {
      context.push('/base');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              bool isSignedIn = await signInWithGoogle();
              String userId = await getCognitoCurrentUser();

              final prefs = await SharedPreferences.getInstance();
              prefs.setString('cognitoUserId', userId);

              if (isSignedIn) {
                context.push('/base');
              }
            } catch (e) {
              print('Error signing in with Google: $e');
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
