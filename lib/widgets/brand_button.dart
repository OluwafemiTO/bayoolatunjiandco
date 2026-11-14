import 'package:flutter/material.dart';
import '../core/core.dart';

enum BrandButtonStyle { brass, primary, outline }

class BrandButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BrandButtonStyle style;
  final bool compact, loading;
  const BrandButton(this.label,
      {super.key,
      this.onPressed,
      this.style = BrandButtonStyle.brass,
      this.compact = false,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    final pad = EdgeInsets.symmetric(horizontal: 28, vertical: compact ? 14 : 20);
    const shape = RoundedRectangleBorder();
    final child = loading
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
        : Text(label);
    switch (style) {
      case BrandButtonStyle.outline:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54), padding: pad, shape: shape),
          onPressed: onPressed,
          child: child,
        );
      case BrandButtonStyle.primary:
        return FilledButton(
          style: FilledButton.styleFrom(backgroundColor: context.pal.primaryBg, foregroundColor: context.pal.primaryFg, padding: pad, shape: shape),
          onPressed: onPressed,
          child: child,
        );
      case BrandButtonStyle.brass:
        return FilledButton(
          style: FilledButton.styleFrom(backgroundColor: brass, foregroundColor: deep, padding: pad, shape: shape),
          onPressed: onPressed,
          child: child,
        );
    }
  }
}
