import 'package:flutter/material.dart' hide Colors, Card;
import 'package:lexiscan/src/routing/app_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LexiScanApp extends StatelessWidget {
  const LexiScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      title: 'LexiScan',
      routerConfig: goRouter,
      themeMode: ThemeMode.system,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
      ),
    );
  }
}
