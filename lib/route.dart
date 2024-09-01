import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'view/base.dart';
import 'view/word_book_detail.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: Base()),
      ),
      GoRoute(
        path: '/word_book',
        pageBuilder: (context, state) {
          final id = state.extra as int;
          return MaterialPage(child: WordBookDetailPage(id: id));
        },
      ),
    ],
  );
}
