import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ScanOptionCard extends StatelessWidget {
  const ScanOptionCard({
    super.key,
    required this.icon,
    this.title = '',
    required this.onTap,
    this.description = '',
    this.width = 180,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ShadCard(
        width: width,
        rowMainAxisAlignment: MainAxisAlignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: ShadTheme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(title, style: ShadTheme.of(context).textTheme.large),
            const SizedBox(height: 4),
            Text(
              description,
              style: ShadTheme.of(
                context,
              ).textTheme.muted.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
