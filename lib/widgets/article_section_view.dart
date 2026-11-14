import 'package:flutter/material.dart';
import '../core/core.dart';
import '../models/article.dart';

class ArticleSectionView extends StatelessWidget {
  final ArticleSection section;
  const ArticleSectionView(this.section, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (section.heading != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(section.heading!, style: serif(30, c: context.pal.heading)),
            ),
          for (final p in section.paragraphs)
            Padding(padding: const EdgeInsets.only(bottom: 12), child: body(p)),
          for (final b in section.bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(width: 6, height: 6, color: brass),
                ),
                const SizedBox(width: 12),
                Expanded(child: body(b)),
              ]),
            ),
        ]),
      );
}
