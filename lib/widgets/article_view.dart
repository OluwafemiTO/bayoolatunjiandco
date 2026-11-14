import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../models/article.dart';
import 'article_cta.dart';
import 'article_section_view.dart';
import 'more_insights.dart';

class ArticleView extends StatelessWidget {
  final Article article;
  const ArticleView(this.article, {super.key});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: context.pal.heading, padding: EdgeInsets.zero),
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Back to home'),
        ),
        const SizedBox(height: 16),
        Text('LEGAL INSIGHT  ·  ${article.readMinutes} MIN READ', style: sans(12, c: brass, w: FontWeight.w600)),
        const SizedBox(height: 12),
        Text(article.title, style: serif(isMobile(context) ? 38 : 54, c: context.pal.heading)),
        const SizedBox(height: 16),
        Text(article.summary, style: sans(18, c: context.pal.text.withOpacity(.75))),
        for (final s in article.sections) ArticleSectionView(s),
        const SizedBox(height: 48),
        ArticleCta(article),
        const SizedBox(height: 56),
        MoreInsights(current: article),
      ]);
}
