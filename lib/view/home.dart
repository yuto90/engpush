import 'package:engpush/provider/word_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/word_book/word_book_model.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    // todo: ホーム画面に画面切り替えする度にDynamoDBからデータを取得するのは非効率だからRiverpodから取得するようにする
    // todo: 代わりにデータ同期処理を実装する(MVPではない)
    ref.read(wordBookProvider.notifier).getWordBookList();
  }

  @override
  Widget build(BuildContext context) {
    final List<WordBook> wordBooks = ref.watch(wordBookProvider);

    return Center(
      child: ListView.builder(
        itemCount: wordBooks.length,
        itemBuilder: (context, index) {
          final wordBook = wordBooks[index];
          return ListTile(
            title: Text(wordBook.name),
            onTap: () => {
              context.push('/word_book', extra: wordBook),
            },
          );
        },
      ),
    );
  }
}
