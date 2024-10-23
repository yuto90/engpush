import 'package:engpush/const/app_bar_title.dart';
import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/ui/show_add_new_word_book_modal.dart';
import 'package:engpush/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Base extends ConsumerWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.read(bottomNavIndexProvider.notifier);

    final List<Widget> appBars = [
      const Text(AppBarTitles.search),
      const Text(AppBarTitles.home),
      const Text(AppBarTitles.settings),
    ];

    final List<Widget> screens = [
      const Center(child: Text('なんか画面')),
      const Home(),
      const Center(child: Text('設定画面')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: appBars[currentIndex],
        leading: Container(), // 戻るアイコンを非表示にする
      ),
      body: screens[currentIndex],
      floatingActionButton: currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                showAddNewWordBookModal(context);
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            bottomNavIndexNotifier.changeDisplay(index);
          },
          selectedItemColor: Colors.amber[800],
          items: BottomNavBarItems.items),
    );
  }
}
