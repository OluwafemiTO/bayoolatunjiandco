import 'package:flutter/material.dart';

/// Equal-width columns: [maxColumns] on desktop, 2 on tablet, 1 on mobile.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int maxColumns;
  final double gap;
  const ResponsiveGrid({super.key, required this.children, this.maxColumns = 3, this.gap = 24});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (c, box) {
        final cols = box.maxWidth >= 900 ? maxColumns : (box.maxWidth >= 560 ? (maxColumns < 2 ? maxColumns : 2) : 1);
        final w = ((box.maxWidth - gap * (cols - 1)) / cols).floorToDouble();
        return Wrap(spacing: gap, runSpacing: gap, children: [
          for (final child in children) SizedBox(width: w, child: child),
        ]);
      });
}
