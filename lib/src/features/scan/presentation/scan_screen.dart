import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexiscan/src/features/scan/presentation/scan_store.dart';
import 'package:lexiscan/src/features/scan/presentation/widgets/scan_option_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ScanStore _store = GetIt.I<ScanStore>();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (_) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.imagePath != null) {
            return _buildResultView();
          }

          return _buildHomeView();
        },
      ),
    );
  }

  Widget _buildHomeView() {
    final theme = ShadTheme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start Scanning', style: theme.textTheme.h4),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ScanOptionCard(
                  icon: LucideIcons.image,
                  title: 'Gallery',
                  description: 'Pick from gallery',
                  onTap: () => _store.pickImage(ImageSource.gallery),
                ),
                const SizedBox(width: 16),
                ScanOptionCard(
                  icon: LucideIcons.camera,
                  title: 'Camera',
                  description: 'Capture from camera',
                  onTap: () => _store.pickImage(ImageSource.camera),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Scans', style: theme.textTheme.h4),
              ShadButton.ghost(
                size: ShadButtonSize.sm,
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.history, size: 16),
                    SizedBox(width: 8),
                    Text('View All'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecentScansPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildRecentScansPlaceholder() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ShadCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.fileText, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan #${3 - index}',
                    style: ShadTheme.of(context).textTheme.large,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '2023-10-${20 + index}',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                ],
              ),
              const Spacer(),
              const Icon(LucideIcons.chevronRight, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_store.imagePath != null)
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.black,
              child: Image.file(File(_store.imagePath!), fit: BoxFit.contain),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_store.recognizedText != null) ...[
                  Text(
                    'Recognized Text',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 16),
                  ShadCard(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _store.recognizedText!,
                      style: ShadTheme.of(context).textTheme.p,
                    ),
                  ),
                ],
                if (_store.error != null)
                  ShadAlert.destructive(
                    icon: const Icon(LucideIcons.circleAlert),
                    title: const Text('Error'),
                    description: Text(_store.error!),
                  ),
                const SizedBox(height: 24),
                ShadButton.outline(
                  width: double.infinity,
                  onPressed: () {
                    _store.imagePath = null;
                    _store.recognizedText = null;
                    _store.error = null;
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.scanLine),
                      SizedBox(width: 8),
                      Text('Scan Another'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
