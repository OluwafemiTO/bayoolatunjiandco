import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import 'insight_row.dart';

class MoreInsights extends StatelessWidget {
  final Article current;
  const MoreInsights({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final others = publishedArticles.where((a) => a.slug != current.slug).take(3).toList();
    if (others.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('More insights', style: serif(30, c: context.pal.heading)),
      const SizedBox(height: 8),
      for (final a in others) InsightRow(a),
    ]);
  }
}
