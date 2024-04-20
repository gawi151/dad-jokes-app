import 'package:dad_jokes/jokes_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const JokesPage(),
    ),
  ],
);
