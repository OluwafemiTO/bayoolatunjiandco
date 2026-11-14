import 'package:go_router/go_router.dart';
import 'pages/article_page.dart';
import 'pages/home_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/insights/:slug',
      builder: (_, state) => ArticlePage(slug: state.pathParameters['slug']!),
    ),
  ],
);
