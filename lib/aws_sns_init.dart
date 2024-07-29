import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:aws_sns_api/sns-2010-03-31.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getAndroidId() async {
  const androidIdPlugin = AndroidId();
  return await androidIdPlugin.getId();
}

Future<void> _saveEndpointArn(String arn) async {
  // エンドポイントARNをローカルストレージに保存する
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('aws_sns_endpoint_arn', arn);
}

Future<void> initAwsSns(String fcmToken) async {
  final deviceInfo = DeviceInfoPlugin();
  String deviceId;

  if (Platform.isAndroid) {
    deviceId = await _getAndroidId() as String;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor!;
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  // SharedPreferencesからエンドポイントARNを読み込む
  final prefs = await SharedPreferences.getInstance();
  final savedEndpointArn = prefs.getString('aws_sns_endpoint_arn');

  if (savedEndpointArn != null && savedEndpointArn.isNotEmpty) {
    // エンドポイントARNが存在する場合、処理をスキップ
    print('Endpoint already exists: $savedEndpointArn');
    return;
  }

  final sns = SNS(
    region: 'ap-northeast-1',
    credentials: AwsClientCredentials(
      accessKey: dotenv.get('AWS_ACCESS_KEY'),
      secretKey: dotenv.get('AWS_SECRET_KEY'),
    ),
  );

  try {
    final response = await sns.createPlatformEndpoint(
      platformApplicationArn: dotenv.get('AWS_PLATFORM_APPLICATION_ARN'),
      token: fcmToken,
      customUserData: deviceId,
    );

    print('Endpoint ARN: ${response.endpointArn}');
    // エンドポイントARNを保存する
    await _saveEndpointArn(response.endpointArn!);
  } catch (e) {
    print('Error registering device: $e');
  }

  // FCMトークン毎にサブスクリプションを作成
  // todo: ユーザー識別子を付与する
  final response = await sns.subscribe(
    protocol: 'application',
    endpoint: prefs.getString('aws_sns_endpoint_arn'),
    topicArn: dotenv.get('AWS_TOPIC_ARN'),
  );

  if (response.subscriptionArn == null) {
    throw Exception('Failed to create subscription');
  }

  print('Subscription ARN: ${response.subscriptionArn}');
}
