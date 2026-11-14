import 'package:flutter/material.dart';
import '../core/core.dart';

InputDecoration inputDecoration(BuildContext context, String label) => InputDecoration(
      labelText: label,
      filled: true,
      fillColor: context.pal.surface,
      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: context.pal.heading, width: 2),
      ),
    );
