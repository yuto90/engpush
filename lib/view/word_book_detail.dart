import 'package:engpush/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WordBookDetailPage extends ConsumerWidget {
  final int id;

  const WordBookDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(counterProvider.notifier);
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('単語帳詳細'),
      ),
      body: Center(child: Text('詳細：$id')),
    );
  }
}
