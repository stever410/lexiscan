import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lexiscan/src/features/scan/scan.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide LucideIcons;

class ScanResultView extends StatelessWidget {
  const ScanResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final store = GetIt.I<ScanStore>();

    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder:
              (_) => Column(
                children: [
                  // Custom Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        ShadButton.ghost(
                          child: const Icon(LucideIcons.chevron_left),
                          onPressed: () {
                            store.imagePath = null;
                            store.recognizedText = null;
                            store.error = null;
                            store.clearSelection();
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'Scan Results',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ShadButton.ghost(
                          child: const Icon(LucideIcons.search),
                          onPressed: () {}, // Search within text
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Overlay Section
                          if (store.imagePath != null &&
                              store.recognizedText != null)
                            Container(
                              color: Colors.black,
                              constraints: const BoxConstraints(maxHeight: 400),
                              child: ScanResultOverlay(
                                imagePath: store.imagePath!,
                                recognizedText: store.recognizedText!,
                                selectedBoxes: store.selectedBoxes.toList(),
                                onSelectionChanged: store.toggleSelection,
                              ),
                            ),

                          // Content Section
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Helper Text if nothing selected
                                if (store.selectedBoxes.isEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          LucideIcons.mouse_pointer_click,
                                          color: theme.colorScheme.primary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Tap on any word in the image above to see its definition.',
                                            style: theme.textTheme.muted
                                                .copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Selected Words / Definitions
                                if (store.selectedWords.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  ...store.selectedWords.map(
                                    (word) =>
                                        _buildWordDefinition(context, word),
                                  ),
                                ],

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildWordDefinition(BuildContext context, String word) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Word Header
        Text(
          word,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif', // Fallback to serif for dictionary look
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),

        // Phonetics and Audio
        Row(
          children: [
            Text(
              '/ˈ${word.toLowerCase()}n/', // Mock phonetic
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              LucideIcons.volume_2,
              size: 20,
              color: theme.colorScheme.mutedForeground,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Parts of Speech Tabs
        Row(
          children: [
            _buildTag(context, 'interjection', true),
            const SizedBox(width: 8),
            _buildTag(context, 'noun', false),
            const SizedBox(width: 8),
            _buildTag(context, 'verb', false),
          ],
        ),
        const SizedBox(height: 32),

        // Definitions
        Text(
          'DEFINITIONS',
          style: theme.textTheme.small.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 16),
        _buildDefinitionItem(
          context,
          '1',
          'A greeting (salutation) said when meeting someone or acknowledging someone\'s arrival or presence.',
        ),
        const SizedBox(height: 16),
        _buildDefinitionItem(
          context,
          '2',
          'A call for response if it is not clear if anyone is present or listening, or if a telephone conversation may have been disconnected.',
        ),

        const SizedBox(height: 32),

        // Synonyms & Antonyms
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SYNONYMS',
                    style: theme.textTheme.small.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'greeting',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'salutation',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ANTONYMS',
                    style: theme.textTheme.small.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'goodbye',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'farewell',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String text, bool isSelected) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        border: Border.all(
          color:
              isSelected ? theme.colorScheme.primary : theme.colorScheme.border,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color:
              isSelected
                  ? theme.colorScheme.primaryForeground
                  : theme.colorScheme.foreground,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDefinitionItem(
    BuildContext context,
    String number,
    String text,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$number. ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
      ],
    );
  }
}
