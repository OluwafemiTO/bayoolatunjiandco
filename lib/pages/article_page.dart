import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../layout/footer.dart';
import '../layout/site_app_bar.dart';
import '../layout/site_drawer.dart';
import '../widgets/article_view.dart';
import '../widgets/brand_button.dart';

class ArticlePage extends StatelessWidget {
  final String slug;
  const ArticlePage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final article = findArticle(slug);
    void home(String _) => context.go('/');
    return Scaffold(
      appBar: SiteAppBar(items: navItems, onNav: home),
      endDrawer: SiteDrawer(items: navItems, onNav: home),
      body: SingleChildScrollView(
        child: Column(children: [
          Section(
            bg: context.pal.page,
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: article == null ? _notFound(context) : ArticleView(article),
              ),
            ),
          ),
          Footer(links: footerLinks, onNav: home),
        ]),
      ),
    );
  }

  Widget _notFound(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading(context, 'Article not found'),
        const SizedBox(height: 16),
        body('This article may have moved or is not published yet.'),
        const SizedBox(height: 24),
        BrandButton('Back to home', style: BrandButtonStyle.primary, onPressed: () => context.go('/')),
      ]);
}
