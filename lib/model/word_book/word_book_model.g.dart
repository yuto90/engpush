// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordBookImpl _$$WordBookImplFromJson(Map<String, dynamic> json) =>
    _$WordBookImpl(
      name: json['name'] as String,
      wordBookId: json['wordBookId'] as String,
      pushNotificationEnabled: json['pushNotificationEnabled'] as bool,
      lastWordIndex: (json['lastWordIndex'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );

Map<String, dynamic> _$$WordBookImplToJson(_$WordBookImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'wordBookId': instance.wordBookId,
      'pushNotificationEnabled': instance.pushNotificationEnabled,
      'lastWordIndex': instance.lastWordIndex,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
