import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../widgets/async_view.dart';
import '../widgets/insight_row.dart';

class InsightsSection extends StatelessWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = isMobile(context) ? double.infinity : 520.0;
    return Section(
      bg: context.pal.page,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading(context, 'Legal insights'),
        const SizedBox(height: 12),
        body('Stay informed with articles on:'),
        const SizedBox(height: 32),
        AsyncView<List<Article>>(
          load: (refresh) => content.articles(refresh: refresh),
          builder: (_, articles) => articles.isEmpty
              ? body('New articles are coming soon.')
              : Wrap(spacing: 40, children: [
                  for (final a in articles) SizedBox(width: w, child: InsightRow(a)),
                ]),
        ),
      ]),
    );
  }
}