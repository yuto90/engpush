import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_book_model.freezed.dart';
part 'word_book_model.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs
@freezed
class WordBook with _$WordBook {
  const factory WordBook({
    required String name,
    required String wordBookId,
    required bool pushNotificationEnabled,
    required int lastWordIndex,
    required int createdAt,
    required int updatedAt,
  }) = _WordBook;

  factory WordBook.fromJson(Map<String, dynamic> json) =>
      _$WordBookFromJson(json);
}
