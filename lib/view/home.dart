import 'package:engpush/provider/word_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWordBooks = ref.watch(wordBookProvider);

    return asyncWordBooks.when(
      data: (wordBooks) => Center(
        child: wordBooks.isEmpty
            ? const Text('まだ単語帳が作成されていません')
            : CustomScrollView(
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
      ),
      error: (error, _) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
