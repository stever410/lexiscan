import 'package:go_router/go_router.dart';
import 'package:lexiscan/src/features/scan/presentation/scan_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ScanScreen(),
    ),
  ],
);
