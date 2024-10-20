import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:engpush/amplifyconfiguration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:engpush/aws_sns_init.dart';
import 'package:engpush/firebase_options.dart';
import 'package:engpush/route.dart';
import 'package:google_fonts/google_fonts.dart';

// バックグラウンドメッセージハンドラ
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
    print('Successfully configured');
  } catch (e) {
    print('Error configuring Amplify: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // dotenvの初期化
  await dotenv.load(fileName: '.env');

  await _configureAmplify();

  // Firebaseの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 通知権限のリクエスト
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // todo: ローカルプッシュの方がいいかもなので一旦コメントアウト
  // todo: エラーハンドリング
  // // FCMトークンの取得
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('FCM Token: $fcmToken');
  // // AWS SNSのセットアップ
  // await initAwsSns(fcmToken!);

  // バックグラウンドメッセージハンドラの設定
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // フォアグラウンドでのメッセージハンドラ
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message: ${message.notification?.title}');
    // フォアグラウンドでの通知処理
  });

  // アプリが開かれた時のメッセージハンドラ
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message opened app: ${message.notification?.title}');
    // バックグラウンドでアプリを開いた時の処理
  });
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'engpush',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansJavaneseTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      locale: const Locale('ja', 'JP'),
      routerConfig: createRouter(),
    );
  }
}
