import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../util/aws_dynamodb.dart';

void showAddNewWordModal(BuildContext context, String wordBookId) {
  final DynamodbUtil dynamodbUtil = DynamodbUtil();
  final formKey = GlobalKey<FormState>();
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meanController = TextEditingController();
  String selectedPartOfSpeech = 'noSelected';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('新しい単語を作成'),
        content: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: wordController,
                decoration: const InputDecoration(labelText: '単語: apple'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '必須項目です';
                  }
                  if (value.length > 300) {
                    return '最大300文字まで入力できます';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: meanController,
                decoration: const InputDecoration(labelText: '意味: りんご'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '必須項目です';
                  }
                  if (value.length > 300) {
                    return '最大300文字まで入力できます';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '品詞'),
                items: const [
                  DropdownMenuItem(value: 'noSelected', child: Text('-')),
                  DropdownMenuItem(value: 'noun', child: Text('名詞')),
                  DropdownMenuItem(value: 'verb', child: Text('動詞')),
                  DropdownMenuItem(value: 'adjective', child: Text('形容詞')),
                  DropdownMenuItem(value: 'adverb', child: Text('副詞')),
                  DropdownMenuItem(value: 'pronoun', child: Text('代名詞')),
                  DropdownMenuItem(value: 'preposition', child: Text('前置詞')),
                  DropdownMenuItem(value: 'conjunction', child: Text('接続詞')),
                  DropdownMenuItem(value: 'interjection', child: Text('間投詞')),
                ],
                onChanged: (value) {
                  selectedPartOfSpeech = value!;
                },
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return '必須項目です';
                //   }
                //   return null;
                // },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () => context.pop(),
          ),
          ElevatedButton(
            child: const Text('追加'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                dynamodbUtil.createWord(
                  wordBookId,
                  wordController.text,
                  meanController.text,
                  selectedPartOfSpeech,
                );
                context.pop();
              }
            },
          ),
        ],
      );
    },
  );
}

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
                      return ListTile(
                        title: Text(word![index]['Word']),
                        subtitle: Text(word[index]['Mean']),
                        trailing: Text(word[index]['PartOfSpeech']),
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
