import 'package:flutter/material.dart';
import '../core/core.dart';
import '../models/member.dart';
import 'team_modal.dart';

class TeamMemberCard extends StatelessWidget {
  final Member member;
  const TeamMemberCard(this.member, {super.key});

  Widget get _initials => Text(member.initials, style: serif(64, c: brass, w: FontWeight.w500));

  @override
  Widget build(BuildContext context) {
    final url = member.imageURL?.trim();
    final hasImage = url != null && url.isNotEmpty;

    return Semantics(
      button: true,
      label: 'View profile of ${member.name}',
      child: InkWell(
        onTap: () => showTeamModal(context, member),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 260,
            width: double.infinity,
            color: lagoon,
            alignment: Alignment.center,
            child: hasImage
                ? Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 260,
                    semanticLabel: 'Portrait of ${member.name}',
                    errorBuilder: (_, __, ___) => _initials, // broken link: fall back to initials
                  )
                : _initials,
          ),
          const SizedBox(height: 14),
          Text(member.name, style: serif(24, c: context.pal.heading)),
          Text(member.titleLine, style: sans(14, c: context.pal.text.withOpacity(.7))),
        ]),
      ),
    );
  }
}