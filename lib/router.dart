import 'package:arturs_app_joke/jokes_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const JokesPage(),
    ),
  ],
);
