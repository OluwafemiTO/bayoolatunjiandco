import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../widgets/firm_logo.dart';

class Footer extends StatelessWidget {
  final List<String> links;
  final void Function(String) onNav;
  const Footer({super.key, required this.links, required this.onNav});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: deep,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const FirmLogo(light: true, nameSize: 26),
              const SizedBox(height: 8),
              Text(firmSlogan, style: serif(20, c: brass, w: FontWeight.w500)),
              const SizedBox(height: 28),
              Wrap(spacing: 8, children: [
                for (final l in links)
                  TextButton(onPressed: () => onNav(l), child: Text(l, style: sans(14, c: Colors.white))),
              ]),
              const Divider(color: Colors.white24, height: 40),
              Text(disclaimer, style: sans(12, c: Colors.white60)),
              const SizedBox(height: 12),
              Text('© 2026 $firmName All rights reserved.   $developerCredit', style: sans(12, c: Colors.white60)),
            ]),
          ),
        ),
      );
}
