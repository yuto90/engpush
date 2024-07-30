import 'package:engpush/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(counterProvider.notifier);
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('単語帳選択'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
        ),
      ),
    );
  }
}
