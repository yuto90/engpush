import 'package:engpush/api_client.dart';
import 'package:engpush/const/app_bar_title.dart';
import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showAddNewWordBookModal(BuildContext context) {
  final ApiClient api = ApiClient();
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('新しい単語帳を作成'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: '単語帳名: 中学英単語'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '必須項目です';
              }
              if (value.length > 50) {
                return '最大50文字まで入力できます';
              }
              return null;
            },
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
                api.createWordBook(controller.text);
                context.pop();
              }
            },
          ),
        ],
      );
    },
  );
}

class Base extends ConsumerWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);

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
