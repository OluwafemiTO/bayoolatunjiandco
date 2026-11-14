import 'package:flutter/material.dart';
import '../core/core.dart';
import '../models/member.dart';

void showTeamModal(BuildContext context, Member m) => showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: context.pal.page,
        shape: const RoundedRectangleBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(tooltip: 'Close', icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ),
              Text(m.name, style: serif(36, c: context.pal.heading)),
              const SizedBox(height: 4),
              Text(m.titleLine, style: sans(15, c: brass, w: FontWeight.w600)),
              const SizedBox(height: 20),
              body(m.bio),
              if (m.admissions.isNotEmpty) _list(context, 'Bar admissions', m.admissions),
              if (m.highlights.isNotEmpty) _list(context, 'Professional highlights', m.highlights),
            ]),
          ),
        ),
      ),
    );

Widget _list(BuildContext context, String title, List<String> items) => Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: serif(24, c: context.pal.heading)),
        const SizedBox(height: 6),
        for (final i in items) body('• $i'),
      ]),
    );
