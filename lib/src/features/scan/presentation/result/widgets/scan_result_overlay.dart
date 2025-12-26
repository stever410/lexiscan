import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanResultOverlay extends StatefulWidget {
  const ScanResultOverlay({
    super.key,
    required this.imagePath,
    required this.recognizedText,
    required this.selectedBoxes,
    required this.onSelectionChanged,
  });

  final String imagePath;
  final RecognizedText recognizedText;
  final List<Rect> selectedBoxes;
  final ValueChanged<Rect> onSelectionChanged;

  @override
  State<ScanResultOverlay> createState() => _ScanResultOverlayState();
}

class _ScanResultOverlayState extends State<ScanResultOverlay> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ScanResultOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    final data = await File(widget.imagePath).readAsBytes();
    final image = await decodeImageFromList(data);
    setState(() {
      _image = image;
    });
  }

  void _handleTap(TapUpDetails details, BoxConstraints constraints) {
    if (_image == null) return;

    // Calculate scale factor
    final double scaleX = _image!.width / constraints.maxWidth;
    final double scaleY = _image!.height / constraints.maxHeight;

    // Map tap position to image coordinates
    final double x = details.localPosition.dx * scaleX;
    final double y = details.localPosition.dy * scaleY;
    final Offset tapPosition = Offset(x, y);

    // Find tapped element
    // We iterate through blocks -> lines -> elements for finest granularity
    for (final block in widget.recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          if (element.boundingBox.contains(tapPosition)) {
            widget.onSelectionChanged(element.boundingBox);
            return; // Only select one at a time (or toggle one)
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _image!.width / _image!.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapUp: (details) => _handleTap(details, constraints),
            child: CustomPaint(
              painter: TextSelectionPainter(
                image: _image!,
                recognizedText: widget.recognizedText,
                selectedBoxes: widget.selectedBoxes,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),
          );
        },
      ),
    );
  }
}

class TextSelectionPainter extends CustomPainter {
  TextSelectionPainter({
    required this.image,
    required this.recognizedText,
    required this.selectedBoxes,
  });

  final ui.Image image;
  final RecognizedText recognizedText;
  final List<Rect> selectedBoxes;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image scaled to fit the canvas
    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, Paint());

    // Calculate scale factors
    final double scaleX = size.width / image.width;
    final double scaleY = size.height / image.height;

    // Paint configuration for highlights
    final Paint highlightPaint =
        Paint()
          ..color = Colors.yellow.withOpacity(0.4)
          ..style = PaintingStyle.fill;

    final Paint borderPaint =
        Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Draw bounding boxes for all elements (optional: hint to user)
    // for (final block in recognizedText.blocks) {
    //   for (final line in block.lines) {
    //     for (final element in line.elements) {
    //       final rect = element.boundingBox;
    //       final scaledRect = Rect.fromLTRB(
    //         rect.left * scaleX,
    //         rect.top * scaleY,
    //         rect.right * scaleX,
    //         rect.bottom * scaleY,
    //       );
    //       canvas.drawRect(scaledRect, borderPaint);
    //     }
    //   }
    // }

    // Draw selected highlights
    for (final rect in selectedBoxes) {
      final scaledRect = Rect.fromLTRB(
        rect.left * scaleX,
        rect.top * scaleY,
        rect.right * scaleX,
        rect.bottom * scaleY,
      );
      canvas.drawRect(scaledRect, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TextSelectionPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.selectedBoxes != selectedBoxes ||
        oldDelegate.recognizedText != recognizedText;
  }
}
