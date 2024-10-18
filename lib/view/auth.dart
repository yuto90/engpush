import 'package:engpush/util/aws_amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ConsumerWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final notifier = ref.read(counterProvider.notifier);
    // final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
