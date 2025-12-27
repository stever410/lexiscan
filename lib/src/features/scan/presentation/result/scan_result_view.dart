import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lexiscan/src/features/scan/scan.dart';
import 'package:mobx/mobx.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide LucideIcons;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ScanResultView extends StatefulWidget {
  const ScanResultView({super.key});

  @override
  State<ScanResultView> createState() => _ScanResultViewState();
}

class _ScanResultViewState extends State<ScanResultView>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  late final AnimationController _animationController;
  Animation<Matrix4>? _zoomAnimation;
  ReactionDisposer? _autoScrollReaction;

  int _currentPage = 0;
  bool _showZoomHint = true;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      if (_zoomAnimation != null) {
        _transformationController.value = _zoomAnimation!.value;
      }
    });

    // Setup auto-scroll reaction
    final store = GetIt.I<ScanStore>();
    _autoScrollReaction = reaction((_) => store.selectedWords.length, (length) {
      if (length > 1) {
        // Small delay to ensure Carousel is ready
        Future.delayed(const Duration(milliseconds: 100), () {
          _carouselController.animateToPage(
            length - 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _autoScrollReaction?.call();
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final currentMatrix = _transformationController.value;
    final targetMatrix = Matrix4.identity();

    if (currentMatrix != Matrix4.identity()) {
      // Zoom out to identity
      _zoomAnimation = Matrix4Tween(
        begin: currentMatrix,
        end: targetMatrix,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
    } else {
      // Zoom in to 3x
      final position = _doubleTapDetails?.localPosition;
      // Default to center if no position available
      final x = -position!.dx * 2;
      final y = -position.dy * 2;

      targetMatrix
        ..translateByVector3(Vector3(x, y, 0))
        ..scaleByVector3(Vector3(3.0, 3.0, 1.0));

      _zoomAnimation = Matrix4Tween(
        begin: currentMatrix,
        end: targetMatrix,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
    }

    _animationController.forward(from: 0);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final store = GetIt.I<ScanStore>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Overlay Section
                  Observer(
                    builder: (_) {
                      if (store.imagePath != null &&
                          store.recognizedText != null) {
                        return Expanded(
                          flex: 4,
                          child: Container(
                            color: Colors.black,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onDoubleTapDown: _handleDoubleTapDown,
                                  onDoubleTap: _handleDoubleTap,
                                  child: InteractiveViewer(
                                    transformationController:
                                        _transformationController,
                                    minScale: 1.0,
                                    maxScale: 4.0,
                                    onInteractionStart: (_) {
                                      if (_showZoomHint) {
                                        setState(() {
                                          _showZoomHint = false;
                                        });
                                      }
                                    },
                                    child: Center(
                                      child: ScanResultOverlay(
                                        imagePath: store.imagePath!,
                                        recognizedText: store.recognizedText!,
                                        selectedBoxes:
                                            store.selectedBoxes.toList(),
                                        onSelectionChanged:
                                            store.toggleSelection,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_showZoomHint)
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Container(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                LucideIcons.zoom_in,
                                                color: Colors.white,
                                                size: 48,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Pinch to Zoom',
                                                style: theme.textTheme.small
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Content Section
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Helper Text if nothing selected
                          Observer(
                            builder: (_) {
                              if (store.selectedBoxes.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
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
                                          style: theme.textTheme.muted.copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          // Selected Words Paging
                          Observer(
                            builder: (_) {
                              if (store.selectedWords.isNotEmpty) {
                                return Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CarouselSlider.builder(
                                          carouselController:
                                              _carouselController,
                                          itemCount: store.selectedWords.length,
                                          itemBuilder: (
                                            context,
                                            index,
                                            realIndex,
                                          ) {
                                            return WordDefinitionCard(
                                              word: store.selectedWords[index],
                                            );
                                          },
                                          options: CarouselOptions(
                                            enableInfiniteScroll: true,
                                            viewportFraction: 1.0,
                                            height: double.infinity,
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _currentPage = index;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Page Indicator
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          store.selectedWords.length,
                                          (index) => GestureDetector(
                                            onTap: () {
                                              _carouselController.animateToPage(
                                                index,
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                              );
                                            },
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    _currentPage == index
                                                        ? theme
                                                            .colorScheme
                                                            .primary
                                                        : theme
                                                            .colorScheme
                                                            .muted,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
