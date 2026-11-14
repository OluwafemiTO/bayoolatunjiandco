import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    return Section(
      bg: lagoon,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading(context, 'Client testimonials', color: Colors.white),
        const SizedBox(height: 40),
        Wrap(spacing: 40, runSpacing: 32, children: [
          for (final t in testimonials)
            SizedBox(
              width: m ? double.infinity : 320,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: const BoxDecoration(border: Border(left: BorderSide(color: brass, width: 3))),
                child: Text('“$t”', style: serif(26, c: Colors.white, w: FontWeight.w500).copyWith(height: 1.3)),
              ),
            ),
        ]),
      ]),
    );
  }
}
