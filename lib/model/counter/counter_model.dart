import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'counter_model.freezed.dart';
part 'counter_model.g.dart';

// freezed = イミュータブルなモデルを自動作成してくれたり、管理が楽にできるメソッドを提供してくれるライブラリ
// ↓コマンドを実行するとfreezedがイミュータブルなモデルを自動生成してくれる
// flutter pub run build_runner build --delete-conflicting-outputs
@freezed
class Counter with _$Counter {
  const factory Counter({
    // 管理したいstateを記載
    required int count,
  }) = _Counter;

  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);
}
