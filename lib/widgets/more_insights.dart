import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import 'insight_row.dart';

class MoreInsights extends StatefulWidget {
  final Article current;
  const MoreInsights({super.key, required this.current});

  @override
  State<MoreInsights> createState() => _MoreInsightsState();
}

class _MoreInsightsState extends State<MoreInsights> {
  late final Future<List<Article>> _articles = content.articles();

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Article>>(
        future: _articles,
        builder: (context, snap) {
          // Shows nothing while loading, or if the request fails.
          final others = (snap.data ?? const <Article>[]).where((a) => a.slug != widget.current.slug).take(3).toList();
          if (others.isEmpty) return const SizedBox.shrink();
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('More insights', style: serif(30, c: context.pal.heading)),
            const SizedBox(height: 8),
            for (final a in others) InsightRow(a),
          ]);
        },
      );
}