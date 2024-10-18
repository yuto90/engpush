import 'package:engpush/const/app_bar_title.dart';
import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewWordBookPage extends ConsumerWidget {
  const NewWordBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text(AppBarTitles.newWordBook)),
      body: Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '単語',
              ),
            ),
          )
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            bottomNavIndexNotifier.changeDisplay(index);
            context.pop();
          },
          selectedItemColor: Colors.amber[800],
          items: BottomNavBarItems.items),
    );
  }
}
