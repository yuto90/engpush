import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/model/word/word_model.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/provider/word_provider.dart';
import 'package:engpush/ui/show_word_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WordBookDetailPage extends ConsumerWidget {
  final WordBook wordBook;

  const WordBookDetailPage({
    super.key,
    required this.wordBook,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);
    final List<Word> words = ref.watch(wordProvider);

    if (words.isEmpty) {
      ref.read(wordProvider.notifier).getWordList(wordBook.wordBookId);
    }

    return Scaffold(
      appBar: AppBar(title: Text(wordBook.name)),
      body: words.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(words[index].mean),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(words[index].partOfSpeech),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Add your onPressed code here!
                                  showWordModal(
                                    context,
                                    wordBook.wordBookId,
                                    words[index].wordId,
                                    word: {
                                      'word': words[index].word,
                                      'meaning': words[index].mean,
                                      'partOfSpeech': words[index].partOfSpeech,
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
            ),

      // body: FutureBuilder(
      //   future: fetchedWordBook,
      //   builder: (context, snapshot) {
      //     // 通信中はローディングのぐるぐるを表示
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     // 通信が失敗した場合
      //     if (snapshot.hasError) {
      //       return Center(child: Text('通信エラーが発生しました: ${snapshot.error}'));
      //     }

      //     // shapshot.dataがnullの場合
      //     if (snapshot.data == null || snapshot.data!.isEmpty) {
      //       return const Center(child: Text('単語が登録されていません'));
      //     }

      //     // snapshot.dataにデータが格納されていれば
      //     if (snapshot.hasData) {
      //       return CustomScrollView(
      //         slivers: [
      //           SliverList(
      //             delegate: SliverChildBuilderDelegate(
      //               (context, index) {
      //                 final word = snapshot.data;
      //                 return Container(
      //                   decoration: const BoxDecoration(
      //                     border: Border(
      //                       bottom: BorderSide(color: Colors.grey),
      //                     ),
      //                   ),
      //                   child: ListTile(
      //                     title: Text(
      //                       word![index]['Word'],
      //                       style: const TextStyle(fontWeight: FontWeight.bold),
      //                     ),
      //                     subtitle: Text(word[index]['Mean']),
      //                     trailing: Row(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         Text(word[index]['PartOfSpeech']),
      //                         IconButton(
      //                           icon: const Icon(Icons.edit),
      //                           onPressed: () {
      //                             // Add your onPressed code here!
      //                             showWordModal(
      //                               context,
      //                               wordBook.wordBookId,
      //                               word[index]['WordId'],
      //                               word: {
      //                                 'word': word[index]['Word'],
      //                                 'meaning': word[index]['Mean'],
      //                                 'partOfSpeech': word[index]
      //                                     ['PartOfSpeech'],
      //                               },
      //                             );
      //                           },
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //               childCount: snapshot.data!.length,
      //             ),
      //           ),
      //         ],
      //       );
      //     }
      //     return const Center(child: Text('単語が登録されていません'));
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showWordModal(context, wordBook.wordBookId, null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
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
