import 'dart:ui';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexiscan/src/features/scan/data/image_service.dart';
import 'package:lexiscan/src/features/scan/data/ocr_service.dart';
import 'package:mobx/mobx.dart';

part 'scan_store.g.dart';

class ScanStore = ScanStoreBase with _$ScanStore;

abstract class ScanStoreBase with Store {
  ScanStoreBase({OCRService? ocrService, ImageService? imageService})
    : _ocrService = ocrService ?? GetIt.I<OCRService>(),
      _imageService = imageService ?? GetIt.I<ImageService>();
  final OCRService _ocrService;
  final ImageService _imageService;

  @observable
  String? imagePath;

  @observable
  RecognizedText? recognizedText;

  @observable
  ObservableList<Rect> selectedBoxes = ObservableList<Rect>();

  @observable
  bool isLoading = false;

  @observable
  ObservableList<String> recentSearches = ObservableList<String>();

  @observable
  String? error;

  @computed
  List<String> get selectedWords {
    if (recognizedText == null) {
      return [];
    }

    // Map selectedBoxes to words to preserve selection order
    return selectedBoxes
        .map((box) {
          for (final block in recognizedText!.blocks) {
            for (final line in block.lines) {
              for (final element in line.elements) {
                if (element.boundingBox == box) {
                  return element.text.toLowerCase();
                }
              }
            }
          }
          return '';
        })
        .where((text) => text.isNotEmpty)
        .toList();
  }

  @action
  Future<void> pickImage(ImageSource source) async {
    try {
      isLoading = true;
      error = null;
      selectedBoxes.clear();
      final String? path = await _imageService.pickImage(source);
      if (path != null) {
        imagePath = path;
        await _processImage(path);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _processImage(String path) async {
    try {
      recognizedText = await _ocrService.processImage(path);
    } catch (e) {
      error = 'OCR Failed: ${e.toString()}';
    }
  }

  @action
  void toggleSelection(Rect box) {
    if (selectedBoxes.contains(box)) {
      selectedBoxes.remove(box);
    } else {
      selectedBoxes.add(box);
    }
  }

  @action
  void clearSelection() {
    selectedBoxes.clear();
  }

  @action
  void addRecentSearch(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    }
  }

  @action
  void removeRecentSearch(String query) {
    recentSearches.remove(query);
  }

  @action
  void clearRecentSearches() {
    recentSearches.clear();
  }

  void dispose() {
    _ocrService.dispose();
  }
}
