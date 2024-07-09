import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/counter/counter_model.dart';

// 登場人物
// =============================================================
// - Provider
//   - stateを管理する箱みたいなやつ
//   - イメージは透明な箱
//   - ConsumerWidgetを継承したWidgetなら参照できるけど、アクセスしてデータの変更はできない
// =============================================================
// - Notifier
//   - Provider内のstateに唯一アクセスできる存在
//   - イメージはProviderの管理人
// =============================================================
// - ConsumerWidget
//   - Provider内のstateを参照できるWidget
// =============================================================

// Providerを定義
// 管理するstateによってProviderの種類を使い分ける
// Notifierって奴だけアクセスができる
final counterProvider =
    // StateNotifierProvider = 外部から変更可能な状態と、状態操作メソッドをセットで提供するProvider
    // このProviderで扱うデータとNotifierを一緒に指定
    // ここではfreezedで作成したカウントを管理するモデルを指定
    StateNotifierProvider.autoDispose<CounterNotifier, Counter>(
        (ref) => CounterNotifier());

// Notifierを定義
class CounterNotifier extends StateNotifier<Counter> {
  // stateの初期データを定義
  // Counterクラスはcountがrequiredなので引数に入れる
  CounterNotifier() : super(const Counter(count: 0));

  void incrementCounter() {
    // Provider管理しているデータにはstateでアクセスできる
    // copyWithを使うとイミュータブルオブジェクトのコピーを作成できる
    // モデルはfreezedによってイミュータブルになっていて中身の変更は不可にっているので、変更する場合は新しいモデルオブジェクトを作成して上書きする
    state = state.copyWith(count: state.count + 1);
  }
}
