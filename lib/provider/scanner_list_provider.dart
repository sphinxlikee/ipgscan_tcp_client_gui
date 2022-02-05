import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScannerList extends ChangeNotifier {
  List<String> scannerList = [];

  Future<void> scannerListParser(String receivedScannerList) async {
    scannerList = receivedScannerList.split('\n');
    scannerList = scannerList..removeLast();
    notifyListeners();
  }
}

final scannerListProvider = ChangeNotifierProvider<ScannerList>(
  (ref) => ScannerList(),
);
final selectedScannerIndexProvider = StateProvider<int>((ref) => 0);
