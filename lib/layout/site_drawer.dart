import 'package:flutter/material.dart';
import '../core/core.dart';

class SiteDrawer extends StatelessWidget {
  final List<String> items;
  final void Function(String) onNav;
  const SiteDrawer({super.key, required this.items, required this.onNav});

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: context.pal.page,
        child: ListView(padding: const EdgeInsets.only(top: 48), children: [
          for (final i in items)
            ListTile(
              title: Text(i, style: serif(24, c: context.pal.heading)),
              onTap: () {
                Navigator.of(context).pop();
                onNav(i);
              },
            ),
        ]),
      );
}
