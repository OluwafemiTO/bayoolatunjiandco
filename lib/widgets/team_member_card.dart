import 'package:flutter/material.dart';
import '../core/core.dart';
import '../models/member.dart';
import 'team_modal.dart';

class TeamMemberCard extends StatelessWidget {
  final Member member;
  const TeamMemberCard(this.member, {super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'View profile of ${member.name}',
        child: InkWell(
          onTap: () => showTeamModal(context, member),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Replace with Image.asset('assets/<name>.jpg', fit: BoxFit.cover, semanticLabel: 'Portrait of ${member.name}')
            Container(
              height: 260,
              width: double.infinity,
              color: lagoon,
              alignment: Alignment.center,
              child: Text(member.initials, style: serif(64, c: brass, w: FontWeight.w500)),
            ),
            const SizedBox(height: 14),
            Text(member.name, style: serif(24, c: context.pal.heading)),
            Text(member.titleLine, style: sans(14, c: context.pal.text.withOpacity(.7))),
          ]),
        ),
      );
}
