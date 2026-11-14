import 'package:flutter/material.dart';
import 'responsive.dart';
import 'theme.dart';

/// Full-width coloured band with centred, max-width content.
class Section extends StatelessWidget {
  final Color bg;
  final Widget child;
  const Section({super.key, required this.bg, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: bg,
        padding: EdgeInsets.symmetric(vertical: isMobile(context) ? 56 : 96, horizontal: 24),
        child: Center(
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1100), child: child),
        ),
      );
}

/// Two columns on desktop, stacked on mobile.
Widget split(BuildContext c, Widget a, Widget b, {int fa = 1, int fb = 2}) => isMobile(c)
    ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [a, const SizedBox(height: 28), b])
    : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: fa, child: a),
        const SizedBox(width: 56),
        Expanded(flex: fb, child: b),
      ]);

Widget heading(BuildContext c, String t, {Color? color}) =>
    Text(t, style: serif(isMobile(c) ? 36 : 48, c: color ?? c.pal.heading));

Widget body(String t, {Color? color}) =>
    Builder(builder: (c) => Text(t, style: sans(16, c: (color ?? c.pal.text).withOpacity(.85))));
