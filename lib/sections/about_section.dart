import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});
  @override
  Widget build(BuildContext context) => Section(
        bg: context.pal.page,
        child: split(
          context,
          heading(context, 'Who we are'),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            body('BAYO OLATUNJI & CO. is a full-service law firm based in Lagos, Nigeria, providing comprehensive legal and corporate consultancy services to clients across Nigeria and internationally.'),
            const SizedBox(height: 16),
            body("We pride ourselves on offering practical legal solutions tailored to each client's unique needs while maintaining the highest standards of professionalism, confidentiality, and ethical practice."),
            const SizedBox(height: 16),
            body('Our commitment is to build lasting relationships through trusted legal representation and exceptional client service.'),
            const SizedBox(height: 40),
            Text('Vision', style: serif(30, c: context.pal.heading)),
            const SizedBox(height: 8),
            body("To be one of Nigeria's most trusted and innovative law firms, delivering world-class legal and corporate solutions."),
            const SizedBox(height: 28),
            Text('Mission', style: serif(30, c: context.pal.heading)),
            const SizedBox(height: 8),
            body('To provide prompt, practical, ethical, and cost-effective legal services that consistently exceed client expectations.'),
            const SizedBox(height: 28),
            Text('Core Values', style: serif(30, c: context.pal.heading)),
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 10, children: [
              for (final v in coreValues)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(border: Border.all(color: brass)),
                  child: Text(v, style: sans(14, c: context.pal.heading, w: FontWeight.w500)),
                ),
            ]),
          ]),
        ),
      );
}
