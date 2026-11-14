import 'package:flutter/material.dart';

/// Current theme mode. Starts with the device setting; the toggle overrides it.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
