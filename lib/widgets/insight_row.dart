import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../models/article.dart';

/// A tappable article title + summary that opens the article page.
class InsightRow extends StatelessWidget {
  final Article article;
  const InsightRow(this.article, {super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context.go('/insights/${article.slug}'),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: context.pal.text.withOpacity(.2))),
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(article.title, style: serif(24, c: context.pal.heading)),
                const SizedBox(height: 4),
                Text(
                  article.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(14, c: context.pal.text.withOpacity(.7)),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward, size: 18, color: brass),
          ]),
        ),
      );
}
