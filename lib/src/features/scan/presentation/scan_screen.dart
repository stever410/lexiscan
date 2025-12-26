import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lexiscan/src/features/scan/application/scan_store.dart';
import 'package:lexiscan/src/features/scan/presentation/home/scan_home_view.dart';
import 'package:lexiscan/src/features/scan/presentation/result/scan_result_view.dart';

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
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.imagePath != null) {
            return const ScanResultView();
          }

          return const ScanHomeView();
        },
      ),
    );
  }
}
