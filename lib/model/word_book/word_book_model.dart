import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_book_model.freezed.dart';
part 'word_book_model.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs
@freezed
class WordBook with _$WordBook {
  const factory WordBook({
    @Default('') String name,
    @Default('') String wordBookId,
    @Default(false) bool pushNotificationEnabled,
    @Default(0) int lastWordIndex,
    @Default(0) int createdAt,
    @Default(0) int updatedAt,
  }) = _WordBook;

  factory WordBook.fromJson(Map<String, dynamic> json) =>
      _$WordBookFromJson(json);
}
