import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/service_card.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) => Section(
        bg: context.pal.alt,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          heading(context, 'Practice areas'),
          const SizedBox(height: 40),
          ResponsiveGrid(children: [for (final s in services) ServiceCard(s)]),
        ]),
      );
}
