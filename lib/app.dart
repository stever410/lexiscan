import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexiscan/src/routing/app_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LexiScanApp extends ConsumerWidget {
  const LexiScanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ShadApp.router(
      title: 'LexiScan',
      routerConfig: router,
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
