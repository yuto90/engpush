import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'view/home.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        // pageBuilder: (context, state) => const MaterialPage(child: Example()),
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
      ),
      // GoRoute(
      //   path: '/detail/:id',
      //   pageBuilder: (context, state) {
      //     final id = state.params['id'];
      //     return MaterialPage(child: DetailPage(id: id));
      //   },
      // ),
    ],
  );
}
