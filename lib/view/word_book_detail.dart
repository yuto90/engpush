import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/model/word/word_model.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/provider/word_provider.dart';
import 'package:engpush/ui/show_word_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WordBookDetailPage extends ConsumerStatefulWidget {
  final WordBook wordBook;

  const WordBookDetailPage({
    super.key,
    required this.wordBook,
  });

  @override
  WordBookDetailPageState createState() => WordBookDetailPageState();
}

class WordBookDetailPageState extends ConsumerState<WordBookDetailPage> {
  @override
  void initState() {
    super.initState();

    // 画面の描画が始まったタイミングで状態の変更
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wordProvider.notifier).fetchWordList(widget.wordBook.wordBookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);
    final asyncWords = ref.watch(wordProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.wordBook.name)),
      body: asyncWords.when(
        data: (words) {
          // word内のwordBookIdがwidget.wordBook.wordBookIdと一致するものだけを抽出
          // todo: Viewにロジック書きたくない
          words = words
              .where((word) => word.wordBookId == widget.wordBook.wordBookId)
              .toList();

          return words.isEmpty
              ? const Text('まだ単語が登録されていません')
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                words[index].word,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(words[index].mean),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(words[index].partOfSpeech),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showWordModal(
                                        context,
                                        ref,
                                        widget.wordBook.wordBookId,
                                        words[index].wordId,
                                        word: {
                                          'word': words[index].word,
                                          'meaning': words[index].mean,
                                          'partOfSpeech':
                                              words[index].partOfSpeech,
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: words.length,
                      ),
                    ),
                  ],
                );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                showWordModal(context, ref, widget.wordBook.wordBookId, null);
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            bottomNavIndexNotifier.changeDisplay(index);
            context.push('/base', extra: index);
          },
          selectedItemColor: Colors.amber[800],
          items: BottomNavBarItems.items),
    );
  }
}
