import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexiscan/src/features/scan/application/scan_store.dart';
import 'package:lexiscan/src/features/scan/presentation/home/widgets/scan_option_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide LucideIcons;

class ScanHomeView extends StatelessWidget {
  const ScanHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final store = GetIt.I<ScanStore>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Start Scanning', style: theme.textTheme.h4),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ScanOptionCard(
                  icon: LucideIcons.camera,
                  title: 'Camera',
                  description: 'Capture from camera',
                  onTap: () => store.pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ScanOptionCard(
                  icon: LucideIcons.image,
                  title: 'Gallery',
                  description: 'Pick from gallery',
                  onTap: () => store.pickImage(ImageSource.gallery),
                ),
              ),
            ],
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
          _buildRecentScansPlaceholder(context),
        ],
      ),
    );
  }

  Widget _buildRecentScansPlaceholder(BuildContext context) {
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
                child: const Icon(LucideIcons.file_text, color: Colors.grey),
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
              const Icon(LucideIcons.chevron_right, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
