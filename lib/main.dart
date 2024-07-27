import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:aws_sns_api/sns-2010-03-31.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engpush/firebase_options.dart';
import 'package:engpush/view/example.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// バックグラウンドメッセージハンドラ
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<String?> getAndroidId() async {
  const androidIdPlugin = AndroidId();
  return await androidIdPlugin.getId();
}

Future<void> _saveEndpointArn(String arn) async {
  // エンドポイントARNをローカルストレージまたはサーバーに保存する
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('aws_sns_endpoint_arn', arn);
}

Future<void> _registerDeviceToken(String fcmToken) async {
  final deviceInfo = DeviceInfoPlugin();
  String deviceId;

  if (Platform.isAndroid) {
    deviceId = getAndroidId() as String;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor!;
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  final sns = SNS(
    region: 'ap-northeast-1',
    credentials: AwsClientCredentials(
      accessKey: dotenv.get('AWS_ACCESS_KEY'),
      secretKey: dotenv.get('AWS_SECRET_KEY'),
    ),
  );

  try {
    // TODO: ユーザー毎のエンドポイントとサブスクリプションを自動作成される様にする
    final response = await sns.createPlatformEndpoint(
      platformApplicationArn: 'YOUR_PLATFORM_APPLICATION_ARN',
      token: fcmToken,
      customUserData: deviceId,
    );

    print('Endpoint ARN: ${response.endpointArn}');
    // エンドポイントARNを保存する
    await _saveEndpointArn(response.endpointArn!);
  } catch (e) {
    print('Error registering device: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // dotenvの初期化
  await dotenv.load(fileName: '.env');

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

  // FCMトークンの取得
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $fcmToken');

  // AWS SNSにデバイストークンを追加
  await _registerDeviceToken(fcmToken!);

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const Example(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
