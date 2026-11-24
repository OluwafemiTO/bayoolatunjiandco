import 'package:flutter/material.dart';
import '../core/core.dart';
import '../services/api_client.dart';

/// A message fit to show a person, whatever went wrong.
String errorMessage(Object e) => e is ApiException ? e.fullMessage : 'Something went wrong. Please try again.';

void showToast(BuildContext context, String text, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? const Color(0xFF7A1A14) : deep,
      content: Text(text, style: const TextStyle(color: Colors.white)),
    ));
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: const RoundedRectangleBorder(),
      title: Text(title, style: serif(26, c: ctx.pal.heading)),
      content: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: Text(message)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB3261E), shape: const RoundedRectangleBorder()),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Scrolling page body: padded, top-aligned, no wider than 1000px.
class AdminScroll extends StatelessWidget {
  final Widget child;
  const AdminScroll({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(isMobile(context) ? 16 : 32),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1000), child: child),
        ),
      );
}

class AdminPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  const AdminPageHeader({super.key, required this.title, this.subtitle, this.actions = const []});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: serif(isMobile(context) ? 34 : 44, c: context.pal.heading)),
              if (subtitle != null) Text(subtitle!, style: sans(14, c: context.pal.text.withOpacity(.7))),
            ]),
          ),
          const SizedBox(width: 12),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ]),
      );
}

/// Bordered box used for list rows and form blocks.
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const AdminCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: context.pal.surface,
          border: Border.all(color: context.pal.text.withOpacity(.12)),
        ),
        child: child,
      );
}

/// Small coloured label, e.g. "Published" or "Draft".
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip(this.label, {super.key, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        color: color.withOpacity(.16),
        child: Text(label, style: sans(12, c: color, w: FontWeight.w600).copyWith(height: 1.5)),
      );
}

/// Secondary button: outlined and square, readable in light and dark mode.
class AdminOutlined extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const AdminOutlined(this.label, {super.key, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: context.pal.heading,
      side: BorderSide(color: context.pal.heading.withOpacity(.4)),
      shape: const RoundedRectangleBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
    return icon == null
        ? OutlinedButton(style: style, onPressed: onPressed, child: Text(label))
        : OutlinedButton.icon(style: style, onPressed: onPressed, icon: Icon(icon, size: 18), label: Text(label));
  }
}

/// A small label above a selectable value, used in detail panels.
class LabelledValue extends StatelessWidget {
  final String label, value;
  const LabelledValue(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(),
              style: sans(11, c: brass, w: FontWeight.w600).copyWith(letterSpacing: 1.1, height: 1.4)),
          SelectableText(value, style: sans(15, c: context.pal.text)),
        ]),
      );
}

/// Shown briefly while the app checks whether you are still signed in.
class AdminSplash extends StatelessWidget {
  const AdminSplash({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}