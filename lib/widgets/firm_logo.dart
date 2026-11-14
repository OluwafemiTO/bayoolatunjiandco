import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';

class FirmLogo extends StatelessWidget {
  final bool light;
  final double nameSize;
  final VoidCallback? onTap;
  const FirmLogo({super.key, this.light = false, this.nameSize = 24, this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(firmName, style: serif(nameSize, c: light ? Colors.white : context.pal.heading, w: FontWeight.w700)),
          Text(firmSubtitle, style: sans(11, c: light ? Colors.white70 : context.pal.text.withOpacity(.65))),
        ]),
      );
}
