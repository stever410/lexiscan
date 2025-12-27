import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide LucideIcons;

class WordDefinitionCard extends StatelessWidget {
  const WordDefinitionCard({super.key, required this.word});

  final String word;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Word Header
          Text(
                word,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  height: 1.1,
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 8),

          // Phonetics and Audio
          Row(
            children: [
              Text(
                '/ˈ${word.toLowerCase()}n/',
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
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
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
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 32),

          // Definitions
          Text(
            'DEFINITIONS',
            style: theme.textTheme.small.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.mutedForeground,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          _buildDefinitionItem(
            context,
            '1',
            'A greeting (salutation) said when meeting someone or acknowledging someone\'s arrival or presence.',
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          _buildDefinitionItem(
            context,
            '2',
            'A call for response if it is not clear if anyone is present or listening, or if a telephone conversation may have been disconnected.',
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

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
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 40),
        ],
      ),
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
