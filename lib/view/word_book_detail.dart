import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/ui/show_add_new_word_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../util/aws_dynamodb.dart';

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
    final DynamodbUtil dynamodbUtil = DynamodbUtil();
    // todo: 一度取得したデータはReverpodで管理する
    final fetchedWordBook = dynamodbUtil.getWordList(wordBook.wordBookId);

    return Scaffold(
      appBar: AppBar(title: Text(wordBook.name)),
      body: FutureBuilder(
        future: fetchedWordBook,
        builder: (context, snapshot) {
          // 通信中はローディングのぐるぐるを表示
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 通信が失敗した場合
          if (snapshot.hasError) {
            return Center(child: Text('通信エラーが発生しました: ${snapshot.error}'));
          }

          // shapshot.dataがnullの場合
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('単語が登録されていません'));
          }

          // snapshot.dataにデータが格納されていれば
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final word = snapshot.data;
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            word![index]['Word'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(word[index]['Mean']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(word[index]['PartOfSpeech']),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Add your onPressed code here!
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('単語が登録されていません'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddNewWordModal(context, wordBook.wordBookId);
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
