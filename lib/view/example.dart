import 'package:engpush/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ProviderにアクセスできるConsumerWidgetを継承
class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  // ConsumerWidgetを継承すると引数にrefが渡ってくる
  // refを通じて任意のProviderを参照できる
  Widget build(BuildContext context, WidgetRef ref) {
    // Notifierを通じてcounterProvider内部のメソッドにアクセスできる
    final notifier = ref.read(counterProvider.notifier);
    // counterProvider内部で管理してるstateを監視
    // 変更があった場合は検知して利用箇所だけ再描画する
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              // stateを取得
              // stateに変更があった場合は自動で変更される
              '${counter.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                // Provider内のメソッドを実行
                notifier.incrementCounter();
              },
              child: const Text('increment'),
            ),
          ],
        ),
      ),
    );
  }
}
