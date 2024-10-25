import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs
@freezed
class Word with _$Word {
  const factory Word({
    required String wordBookId,
    required String wordId,
    required String word,
    required String mean,
    required String partOfSpeech,
    required int lastNotified,
    required bool pushNotificationEnabled,
    required int notificationCount,
    required int createdAt,
    required int updatedAt,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}
