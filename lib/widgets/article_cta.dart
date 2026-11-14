import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/core.dart';
import '../data/data.dart';
import 'brand_button.dart';

class ArticleCta extends StatelessWidget {
  final Article article;
  const ArticleCta(this.article, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        color: context.pal.alt,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Need advice on this topic?', style: serif(28, c: context.pal.heading)),
          const SizedBox(height: 8),
          body('Speak to our team for practical guidance tailored to your situation.'),
          const SizedBox(height: 20),
          BrandButton(
            'Book a Consultation',
            style: BrandButtonStyle.primary,
            onPressed: () => launchUrl(Uri.parse(
                'mailto:$firmEmail?subject=${Uri.encodeComponent("Enquiry: ${article.title}")}')),
          ),
        ]),
      );
}
