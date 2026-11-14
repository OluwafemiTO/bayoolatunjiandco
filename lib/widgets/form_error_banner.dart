import 'package:flutter/material.dart';
import '../core/core.dart';

class FormErrorBanner extends StatelessWidget {
  final String message;
  const FormErrorBanner(this.message, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        color: context.pal.errorBg,
        child: Row(children: [
          Icon(Icons.error_outline, color: context.pal.errorFg),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: sans(14, c: context.pal.errorFg))),
        ]),
      );
}
