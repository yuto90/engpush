// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordImpl _$$WordImplFromJson(Map<String, dynamic> json) => _$WordImpl(
      wordBookId: json['wordBookId'] as String,
      wordId: json['wordId'] as String,
      word: json['word'] as String,
      mean: json['mean'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      lastNotified: (json['lastNotified'] as num).toInt(),
      pushNotificationEnabled: json['pushNotificationEnabled'] as bool,
      notificationCount: (json['notificationCount'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );

Map<String, dynamic> _$$WordImplToJson(_$WordImpl instance) =>
    <String, dynamic>{
      'wordBookId': instance.wordBookId,
      'wordId': instance.wordId,
      'word': instance.word,
      'mean': instance.mean,
      'partOfSpeech': instance.partOfSpeech,
      'lastNotified': instance.lastNotified,
      'pushNotificationEnabled': instance.pushNotificationEnabled,
      'notificationCount': instance.notificationCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
