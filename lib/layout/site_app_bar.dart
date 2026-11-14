import 'package:flutter/material.dart';
import '../core/core.dart';
import '../widgets/brand_button.dart';
import '../widgets/firm_logo.dart';
import '../widgets/theme_toggle.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> items;
  final void Function(String) onNav;
  const SiteAppBar({super.key, required this.items, required this.onNav});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    return AppBar(
      toolbarHeight: 76,
      backgroundColor: context.pal.page,
      surfaceTintColor: context.pal.page,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 24,
      title: FirmLogo(nameSize: m ? 20 : 24, onTap: () => onNav('Home')),
      actions: m
          ? [
              const ThemeToggle(),
              Builder(
                builder: (c) => IconButton(
                  tooltip: 'Open menu',
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(c).openEndDrawer(),
                ),
              ),
            ]
          : [
              for (final i in items.skip(1))
                TextButton(onPressed: () => onNav(i), child: Text(i, style: sans(14, c: context.pal.text, w: FontWeight.w500))),
              const ThemeToggle(),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: BrandButton('Book a Consultation',
                    style: BrandButtonStyle.primary, compact: true, onPressed: () => onNav('Contact Us')),
              ),
            ],
    );
  }
}
