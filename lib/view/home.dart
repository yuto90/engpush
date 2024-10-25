import 'package:engpush/provider/word_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/word_book/word_book_model.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<WordBook> wordBooks = ref.watch(wordBookProvider);
    print('wordBooks: $wordBooks');

    if (wordBooks.isEmpty) {
      ref.read(wordBookProvider.notifier).getWordBookList();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final wordBook = wordBooks[index];
                return ListTile(
                  title: Text(wordBook.name),
                  onTap: () => {
                    context.push('/word_book', extra: wordBook),
                  },
                );
              },
              childCount: wordBooks.length,
            ),
          ),
        ],
      ),
    );
  }
}
