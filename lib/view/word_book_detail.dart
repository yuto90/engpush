import 'package:engpush/const/app_bar_title.dart';
import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WordBookDetailPage extends ConsumerWidget {
  final int id;

  const WordBookDetailPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text(AppBarTitles.detail)),
      body: Center(child: Text('詳細：$id')),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            bottomNavIndexNotifier.changeDisplay(index);
            context.push('/', extra: index);
          },
          selectedItemColor: Colors.amber[800],
          items: BottomNavBarItems.items),
    );
  }
}
