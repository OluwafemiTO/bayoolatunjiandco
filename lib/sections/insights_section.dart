import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
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
        Wrap(spacing: 40, children: [
          for (final a in publishedArticles) SizedBox(width: w, child: InsightRow(a)),
        ]),
      ]),
    );
  }
}
