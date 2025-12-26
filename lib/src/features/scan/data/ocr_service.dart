import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  final _textRecognizer = TextRecognizer();

  Future<RecognizedText> processImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    return await _textRecognizer.processImage(inputImage);
  }

  void dispose() {
    _textRecognizer.close();
  }
}
