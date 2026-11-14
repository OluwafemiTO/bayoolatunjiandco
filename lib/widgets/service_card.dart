import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';

class ServiceCard extends StatefulWidget {
  final Service s;
  const ServiceCard(this.s, {super.key});
  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool hover = false, open = false;

  Widget detail(BuildContext context, Service s) => s.blurb != null
      ? body(s.blurb!)
      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final i in s.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(padding: EdgeInsets.only(top: 5), child: Icon(Icons.check, size: 16, color: brass)),
                const SizedBox(width: 8),
                Expanded(child: Text(i, style: sans(15, c: context.pal.text.withOpacity(.85)))),
              ]),
            ),
        ]);

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, hover ? -4 : 0, 0),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: context.pal.surface,
          border: Border.all(color: hover || open ? brass : Colors.transparent, width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(s.icon, size: 32, color: brass),
          const SizedBox(height: 16),
          Text(s.title, style: serif(26, c: context.pal.heading)),
          const SizedBox(height: 10),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topLeft,
            child: open
                ? detail(context, s)
                : Text(s.snippet, maxLines: 2, overflow: TextOverflow.ellipsis, style: sans(15, c: context.pal.text.withOpacity(.8))),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => setState(() => open = !open),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(open ? 'Show less' : 'Learn more', style: sans(14, c: context.pal.heading, w: FontWeight.w600)),
                const SizedBox(width: 6),
                Icon(open ? Icons.expand_less : Icons.arrow_forward, size: 16, color: brass),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
