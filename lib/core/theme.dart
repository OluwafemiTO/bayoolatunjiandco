import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Fixed brand colours (identical in light and dark mode)
const lagoon = Color(0xFF0E3B3A); // dark green bands: hero, stats, testimonials, banner
const brass = Color(0xFFB08D57); // accent
const deep = Color(0xFF16201F); // footer background, text on brass

/// Colours that change between light and dark mode.
/// Read them with `context.pal.<name>`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color page, alt, surface, text, heading, primaryBg, primaryFg, errorBg, errorFg;
  const AppPalette({
    required this.page,
    required this.alt,
    required this.surface,
    required this.text,
    required this.heading,
    required this.primaryBg,
    required this.primaryFg,
    required this.errorBg,
    required this.errorFg,
  });

  static const light = AppPalette(
    page: Color(0xFFF6F7F5),
    alt: Color(0xFFE3EAE8),
    surface: Colors.white,
    text: Color(0xFF16201F),
    heading: lagoon,
    primaryBg: lagoon,
    primaryFg: Colors.white,
    errorBg: Color(0xFFFBE9E7),
    errorFg: Color(0xFF7A1A14),
  );

  static const dark = AppPalette(
    page: Color(0xFF0C1413),
    alt: Color(0xFF121D1C),
    surface: Color(0xFF1A2B2A),
    text: Color(0xFFE6EDEB),
    heading: Color(0xFFBFDCD6),
    primaryBg: brass,
    primaryFg: deep,
    errorBg: Color(0xFF3A1B18),
    errorFg: Color(0xFFFFB4AB),
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) =>
      other is AppPalette && t >= 0.5 ? other : this;
}

extension PaletteContext on BuildContext {
  AppPalette get pal => Theme.of(this).extension<AppPalette>()!;
}

// Type: Cormorant Garamond for headings, Inter for body.
// With no colour given, text inherits the theme's text colour.
TextStyle serif(double s, {Color? c, FontWeight w = FontWeight.w600}) =>
    GoogleFonts.cormorantGaramond(fontSize: s, color: c, fontWeight: w, height: 1.1);

TextStyle sans(double s, {Color? c, FontWeight w = FontWeight.w400}) =>
    GoogleFonts.inter(fontSize: s, color: c, fontWeight: w, height: 1.65);

ThemeData buildTheme(Brightness b) {
  final p = b == Brightness.dark ? AppPalette.dark : AppPalette.light;
  final base = ThemeData(brightness: b, colorSchemeSeed: lagoon);
  return base.copyWith(
    scaffoldBackgroundColor: p.page,
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    extensions: [p],
  );
}
