import 'package:flutter/material.dart';
import 'app_router.dart';
import 'core/core.dart';
import 'data/data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (_, mode, __) => MaterialApp.router(
          title: firmName,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: mode,
          routerConfig: appRouter,
        ),
      );
}
