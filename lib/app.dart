import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lexiscan/src/routing/app_router.dart';
import 'package:lexiscan/src/shared/theme/theme_store.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LexiScanApp extends StatelessWidget {
  const LexiScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeStore = GetIt.I<ThemeStore>();

    return Observer(
      builder:
          (_) => ShadApp.router(
            title: 'LexiScan',
            routerConfig: goRouter,
            themeMode: themeStore.themeMode,
            theme: ShadThemeData(
              brightness: Brightness.light,
              colorScheme: const ShadZincColorScheme.light(),
            ),
            darkTheme: ShadThemeData(
              brightness: Brightness.dark,
              colorScheme: const ShadZincColorScheme.dark(
                background: Color(0xFF191919), // Dark Grey
              ),
            ),
          ),
    );
  }
}
