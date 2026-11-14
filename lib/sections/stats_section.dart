import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});
  @override
  Widget build(BuildContext context) => Section(
        bg: lagoon,
        child: Wrap(spacing: 48, runSpacing: 32, alignment: WrapAlignment.spaceBetween, children: [
          for (final s in stats)
            SizedBox(
              width: isMobile(context) ? 140 : 220,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: s.value.toDouble()),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOut,
                  builder: (c, v, _) => Text('${v.round()}${s.suffix}', style: serif(isMobile(context) ? 44 : 60, c: brass, w: FontWeight.w500)),
                ),
                Text(s.label, style: sans(14, c: Colors.white70)),
              ]),
            ),
        ]),
      );
}
