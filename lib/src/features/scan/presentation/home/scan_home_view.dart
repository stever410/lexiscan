import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexiscan/src/features/scan/scan.dart';
import 'package:lexiscan/src/shared/theme/theme_store.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide LucideIcons;

class ScanHomeView extends StatelessWidget {
  const ScanHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final store = GetIt.I<ScanStore>();
    final themeStore = GetIt.I<ThemeStore>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lexiscan', style: theme.textTheme.h3),
                  Row(
                    children: [
                      Observer(
                        builder:
                            (_) => GestureDetector(
                              onTap: themeStore.toggleTheme,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return RotationTransition(
                                    turns: animation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Icon(
                                  themeStore.isDarkMode
                                      ? LucideIcons.moon
                                      : LucideIcons.sun,
                                  key: ValueKey(themeStore.isDarkMode),
                                  size: 24,
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(width: 16),
                      const ShadAvatar(
                        'https://avatars.githubusercontent.com/u/124599?v=4',
                        size: Size(32, 32),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              ShadInput(
                placeholder: const Text('Enter a word...'),
                leading: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(LucideIcons.search, size: 16),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    // Implement voice search logic if needed
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(LucideIcons.mic, size: 16),
                  ),
                ),
                onSubmitted: store.addRecentSearch,
              ),

              const SizedBox(height: 32),

              // Word of the Day Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryForeground
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Word of the Day',
                            style: TextStyle(
                              color: theme.colorScheme.primaryForeground,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          LucideIcons.sparkles,
                          color: theme.colorScheme.primaryForeground,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Serendipity',
                      style: TextStyle(
                        color: theme.colorScheme.primaryForeground,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: theme.colorScheme.primaryForeground,
                          fontSize: 16,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                '"The discovery of penicillin was a happy accident, a moment of pure ',
                          ),
                          TextSpan(
                            text: 'serendipity',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  theme.colorScheme.primaryForeground,
                            ),
                          ),
                          const TextSpan(text: '."'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Recent Searches
              const SizedBox(height: 16),
              Observer(
                builder: (_) {
                  if (store.recentSearches.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Searches', style: theme.textTheme.muted),
                          ShadButton.ghost(
                            size: ShadButtonSize.sm,
                            onPressed: store.clearRecentSearches,
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            store.recentSearches.map((query) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle tap (e.g., fill search or navigate)
                                },
                                child: Chip(
                                  label: Text(query),
                                  deleteIcon: const Icon(
                                    LucideIcons.x,
                                    size: 14,
                                  ),
                                  onDeleted:
                                      () => store.removeRecentSearch(query),
                                  backgroundColor: theme.colorScheme.secondary,
                                  labelStyle: TextStyle(
                                    color: theme.colorScheme.foreground,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),
              // Scan Options
              Text('Start Scanning', style: theme.textTheme.h4),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ShadButton.outline(
                      onPressed: () => store.pickImage(ImageSource.camera),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.camera, size: 16),
                          SizedBox(width: 8),
                          Text('Camera'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ShadButton.outline(
                      onPressed: () => store.pickImage(ImageSource.gallery),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.image, size: 16),
                          SizedBox(width: 8),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
