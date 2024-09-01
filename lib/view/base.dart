import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Base extends ConsumerWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);

    final List<Widget> appBars = [
      const Text('search'),
      const Text('select word book'),
      const Text('settings'),
    ];

    final List<Widget> screens = [
      const Center(child: Text('search')),
      const Home(),
      const Center(child: Text('設定画面')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: appBars[currentIndex],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          bottomNavIndexNotifier.changeDisplay(index);
        },
        selectedItemColor: Colors.amber[800],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
