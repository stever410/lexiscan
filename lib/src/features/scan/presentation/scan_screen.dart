import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexiscan/src/features/scan/presentation/scan_store.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // Grab the store from GetIt.
  // Since we registered it as a Factory, this creates a fresh instance.
  final ScanStore _store = GetIt.I<ScanStore>();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LexiScan')),
      body: Observer(
        builder: (_) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.imagePath != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.file(File(_store.imagePath!)),
                  const SizedBox(height: 16),
                  if (_store.recognizedText != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_store.recognizedText!.text),
                    ),
                  if (_store.error != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _store.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ShadButton.outline(
                    child: const Text('Scan Another'),
                    onPressed: () {
                      _store.imagePath = null;
                      _store.recognizedText = null;
                      _store.error = null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadButton(
                  child: const Text('Scan Camera'),
                  onPressed: () => _store.pickImage(ImageSource.camera),
                ),
                const SizedBox(height: 16),
                ShadButton.outline(
                  child: const Text('Pick from Gallery'),
                  onPressed: () => _store.pickImage(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
