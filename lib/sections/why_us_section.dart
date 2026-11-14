import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';

class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final w = isMobile(context) ? double.infinity : 250.0;
    return Section(
      bg: context.pal.page,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading(context, 'Why choose us'),
        const SizedBox(height: 40),
        Wrap(spacing: 32, runSpacing: 32, children: [
          for (final t in whyUs)
            SizedBox(
              width: w,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 32, height: 3, color: brass),
                const SizedBox(height: 14),
                Text(t, style: serif(24, c: context.pal.heading)),
              ]),
            ),
        ]),
      ]),
    );
  }
}
