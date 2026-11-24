import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart' show ValueKey;
import 'admin/admin_shell.dart';
import 'admin/admin_widgets.dart' show AdminSplash;
import 'admin/article_editor_page.dart';
import 'admin/articles_page.dart';
import 'admin/inquiries_page.dart';
import 'admin/login_page.dart';
import 'admin/team_admin_page.dart';
import 'pages/article_page.dart';
import 'pages/home_page.dart';
import 'services/auth_service.dart';

/// Decides where an /admin address should go, based on whether you are signed in.
String? _guard(_, GoRouterState state) {
  final path = state.matchedLocation;

  // On admin.yourdomain.com, the front page is the admin, not the public website.
  if (path == '/' && Uri.base.host.startsWith('admin.')) return '/admin';

  if (!path.startsWith('/admin')) return null;

  switch (auth.status) {
    case AuthStatus.unknown:
      auth.restore(); // checks the cookie once; this guard runs again when it finishes
      return null;
    case AuthStatus.signedOut:
      return path == '/admin/login' ? null : '/admin/login';
    case AuthStatus.signedIn:
      if (path == '/admin/login' || path == '/admin' || path == '/admin/') return '/admin/inquiries';
      return null;
  }
}

final appRouter = GoRouter(
  refreshListenable: auth,
  redirect: _guard,
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/insights/:slug',
      builder: (_, state) => ArticlePage(slug: state.pathParameters['slug']!),
    ),

    // ── Admin ──
    GoRoute(path: '/admin', builder: (_, __) => const AdminSplash()), // only seen briefly while checking the login
    GoRoute(path: '/admin/login', builder: (_, __) => const AdminLoginPage()),
    ShellRoute(
      builder: (_, state, child) => AdminShell(location: state.matchedLocation, child: child),
      routes: [
        GoRoute(path: '/admin/inquiries', builder: (_, __) => const InquiriesPage()),
        GoRoute(path: '/admin/articles', builder: (_, __) => const ArticlesPage()),
        GoRoute(path: '/admin/articles/new', builder: (_, __) => const ArticleEditorPage()),
        GoRoute(
          path: '/admin/articles/:id',
          builder: (_, state) =>
              ArticleEditorPage(key: ValueKey(state.pathParameters['id']), id: state.pathParameters['id']),
        ),
        GoRoute(path: '/admin/team', builder: (_, __) => const TeamAdminPage()),
      ],
    ),
  ],
);