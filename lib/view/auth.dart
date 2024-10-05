import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
              SignInResult res = await Amplify.Auth.signInWithWebUI(
                provider: AuthProvider.google,
              );
              print('res =====>');
              print(res);
              if (res.isSignedIn) {
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
