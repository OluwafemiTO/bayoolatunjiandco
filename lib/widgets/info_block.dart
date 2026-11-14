import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/core.dart';

/// Small brass label above a value, used in the contact details.
class InfoBlock extends StatelessWidget {
  final String label;
  final Widget child;
  const InfoBlock(this.label, this.child, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: sans(13, c: brass, w: FontWeight.w600)),
          const SizedBox(height: 4),
          child,
        ]),
      );
}

class LinkText extends StatelessWidget {
  final String text, url;
  const LinkText(this.text, this.url, {super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        child: Text(text, style: sans(16, c: context.pal.heading, w: FontWeight.w500)),
      );
}
