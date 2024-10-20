import 'package:engpush/const/app_bar_title.dart';
import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text(AppBarTitles.detail)),
      body: Column(
        children: [
          Center(child: Text('詳細：$wordBook')),
          // ElevatedButton(
          //   child: const Text('追加'),
          //   onPressed: () {
          //     dynamodbUtil.getWordList(wordBook.wordBookId);
          //   },
          // )
        ],
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
