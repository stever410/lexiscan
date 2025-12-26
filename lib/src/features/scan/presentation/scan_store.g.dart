// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScanStore on _ScanStore, Store {
  late final _$imagePathAtom =
      Atom(name: '_ScanStore.imagePath', context: context);

  @override
  String? get imagePath {
    _$imagePathAtom.reportRead();
    return super.imagePath;
  }

  @override
  set imagePath(String? value) {
    _$imagePathAtom.reportWrite(value, super.imagePath, () {
      super.imagePath = value;
    });
  }

  late final _$recognizedTextAtom =
      Atom(name: '_ScanStore.recognizedText', context: context);

  @override
  RecognizedText? get recognizedText {
    _$recognizedTextAtom.reportRead();
    return super.recognizedText;
  }

  @override
  set recognizedText(RecognizedText? value) {
    _$recognizedTextAtom.reportWrite(value, super.recognizedText, () {
      super.recognizedText = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ScanStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorAtom = Atom(name: '_ScanStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$pickImageAsyncAction =
      AsyncAction('_ScanStore.pickImage', context: context);

  @override
  Future<void> pickImage(ImageSource source) {
    return _$pickImageAsyncAction.run(() => super.pickImage(source));
  }

  late final _$_processImageAsyncAction =
      AsyncAction('_ScanStore._processImage', context: context);

  @override
  Future<void> _processImage(String path) {
    return _$_processImageAsyncAction.run(() => super._processImage(path));
  }

  @override
  String toString() {
    return '''
imagePath: ${imagePath},
recognizedText: ${recognizedText},
isLoading: ${isLoading},
error: ${error}
    ''';
  }
}
