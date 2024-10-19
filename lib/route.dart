import 'package:engpush/model/word_book/word_book_model.dart';
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
        pageBuilder: (context, state) => const MaterialPage(child: Auth()),
      ),
      GoRoute(
        path: '/base',
        pageBuilder: (context, state) => const MaterialPage(child: Base()),
      ),
      GoRoute(
        path: '/word_book',
        pageBuilder: (context, state) {
          final wordBook = state.extra as WordBook;
          return MaterialPage(child: WordBookDetailPage(wordBook: wordBook));
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
