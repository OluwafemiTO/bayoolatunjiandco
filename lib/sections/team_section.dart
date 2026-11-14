import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/team_member_card.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) => Section(
        bg: context.pal.alt,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          heading(context, 'Our team'),
          const SizedBox(height: 40),
          ResponsiveGrid(maxColumns: 4, children: [for (final m in team) TeamMemberCard(m)]),
        ]),
      );
}
