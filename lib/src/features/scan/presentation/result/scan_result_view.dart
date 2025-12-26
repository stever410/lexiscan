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
    // Use the same singleton instance
    final store = GetIt.I<ScanStore>();

    return Observer(
      builder:
          (_) => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (store.imagePath != null && store.recognizedText != null)
                    Container(
                      color: Colors.black,
                      constraints: const BoxConstraints(maxHeight: 500),
                      child: ScanResultOverlay(
                        imagePath: store.imagePath!,
                        recognizedText: store.recognizedText!,
                        selectedBoxes: store.selectedBoxes.toList(),
                        onSelectionChanged: store.toggleSelection,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Helper Banner
                        if (store.selectedBoxes.isEmpty)
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blue.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.info,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Tap on any word in the image to see its definition.',
                                        style:
                                            ShadTheme.of(
                                              context,
                                            ).textTheme.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        // Scan Another Button
                        ShadButton.outline(
                          width: double.infinity,
                          onPressed: () {
                            store.imagePath = null;
                            store.recognizedText = null;
                            store.error = null;
                            store.clearSelection();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.scan_line),
                              SizedBox(width: 8),
                              Text('Scan Another'),
                            ],
                          ),
                        ),
                        // Definitions Section
                        if (store.selectedWords.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Definitions',
                            style: ShadTheme.of(context).textTheme.h4,
                          ),
                          const SizedBox(height: 16),
                          ...store.selectedWords.map(
                            (word) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ShadCard(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      word,
                                      style:
                                          ShadTheme.of(context).textTheme.large,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Definition loading...', // Mock definition for now
                                      style:
                                          ShadTheme.of(context).textTheme.muted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],

                        if (store.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ShadAlert.destructive(
                              icon: const Icon(LucideIcons.circle_alert),
                              title: const Text('Error'),
                              description: Text(store.error!),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
