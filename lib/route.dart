import 'package:engpush/view/auth.dart';
import 'package:engpush/view/new_word_book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'view/base.dart';
import 'view/word_book_detail.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        // todo: 認証状態によってAuthに遷移するかBaseに遷移するかを判定する
        pageBuilder: (context, state) => const MaterialPage(child: Auth()),
        // pageBuilder: (context, state) => const MaterialPage(child: Base()),
      ),
      GoRoute(
        path: '/base',
        pageBuilder: (context, state) => const MaterialPage(child: Base()),
      ),
      GoRoute(
        path: '/word_book',
        pageBuilder: (context, state) {
          final id = state.extra as int;
          return MaterialPage(child: WordBookDetailPage(id: id));
        },
      ),
      GoRoute(
        path: '/new_word_book',
        pageBuilder: (context, state) {
          return const MaterialPage(child: NewWordBookPage());
        },
      ),
    ],
  );
}
