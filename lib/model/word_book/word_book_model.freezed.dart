// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WordBook _$WordBookFromJson(Map<String, dynamic> json) {
  return _WordBook.fromJson(json);
}

/// @nodoc
mixin _$WordBook {
  String get name => throw _privateConstructorUsedError;
  String get wordBookId => throw _privateConstructorUsedError;
  bool get pushNotificationEnabled => throw _privateConstructorUsedError;
  int get lastWordIndex => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;
  int get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WordBookCopyWith<WordBook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordBookCopyWith<$Res> {
  factory $WordBookCopyWith(WordBook value, $Res Function(WordBook) then) =
      _$WordBookCopyWithImpl<$Res, WordBook>;
  @useResult
  $Res call(
      {String name,
      String wordBookId,
      bool pushNotificationEnabled,
      int lastWordIndex,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class _$WordBookCopyWithImpl<$Res, $Val extends WordBook>
    implements $WordBookCopyWith<$Res> {
  _$WordBookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? wordBookId = null,
    Object? pushNotificationEnabled = null,
    Object? lastWordIndex = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      wordBookId: null == wordBookId
          ? _value.wordBookId
          : wordBookId // ignore: cast_nullable_to_non_nullable
              as String,
      pushNotificationEnabled: null == pushNotificationEnabled
          ? _value.pushNotificationEnabled
          : pushNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastWordIndex: null == lastWordIndex
          ? _value.lastWordIndex
          : lastWordIndex // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordBookImplCopyWith<$Res>
    implements $WordBookCopyWith<$Res> {
  factory _$$WordBookImplCopyWith(
          _$WordBookImpl value, $Res Function(_$WordBookImpl) then) =
      __$$WordBookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String wordBookId,
      bool pushNotificationEnabled,
      int lastWordIndex,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class __$$WordBookImplCopyWithImpl<$Res>
    extends _$WordBookCopyWithImpl<$Res, _$WordBookImpl>
    implements _$$WordBookImplCopyWith<$Res> {
  __$$WordBookImplCopyWithImpl(
      _$WordBookImpl _value, $Res Function(_$WordBookImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? wordBookId = null,
    Object? pushNotificationEnabled = null,
    Object? lastWordIndex = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WordBookImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      wordBookId: null == wordBookId
          ? _value.wordBookId
          : wordBookId // ignore: cast_nullable_to_non_nullable
              as String,
      pushNotificationEnabled: null == pushNotificationEnabled
          ? _value.pushNotificationEnabled
          : pushNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastWordIndex: null == lastWordIndex
          ? _value.lastWordIndex
          : lastWordIndex // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WordBookImpl implements _WordBook {
  const _$WordBookImpl(
      {required this.name,
      required this.wordBookId,
      required this.pushNotificationEnabled,
      required this.lastWordIndex,
      required this.createdAt,
      required this.updatedAt});

  factory _$WordBookImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordBookImplFromJson(json);

  @override
  final String name;
  @override
  final String wordBookId;
  @override
  final bool pushNotificationEnabled;
  @override
  final int lastWordIndex;
  @override
  final int createdAt;
  @override
  final int updatedAt;

  @override
  String toString() {
    return 'WordBook(name: $name, wordBookId: $wordBookId, pushNotificationEnabled: $pushNotificationEnabled, lastWordIndex: $lastWordIndex, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordBookImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.wordBookId, wordBookId) ||
                other.wordBookId == wordBookId) &&
            (identical(
                    other.pushNotificationEnabled, pushNotificationEnabled) ||
                other.pushNotificationEnabled == pushNotificationEnabled) &&
            (identical(other.lastWordIndex, lastWordIndex) ||
                other.lastWordIndex == lastWordIndex) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, wordBookId,
      pushNotificationEnabled, lastWordIndex, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WordBookImplCopyWith<_$WordBookImpl> get copyWith =>
      __$$WordBookImplCopyWithImpl<_$WordBookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordBookImplToJson(
      this,
    );
  }
}

abstract class _WordBook implements WordBook {
  const factory _WordBook(
      {required final String name,
      required final String wordBookId,
      required final bool pushNotificationEnabled,
      required final int lastWordIndex,
      required final int createdAt,
      required final int updatedAt}) = _$WordBookImpl;

  factory _WordBook.fromJson(Map<String, dynamic> json) =
      _$WordBookImpl.fromJson;

  @override
  String get name;
  @override
  String get wordBookId;
  @override
  bool get pushNotificationEnabled;
  @override
  int get lastWordIndex;
  @override
  int get createdAt;
  @override
  int get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WordBookImplCopyWith<_$WordBookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
