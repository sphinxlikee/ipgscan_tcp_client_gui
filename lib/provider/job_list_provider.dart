// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobListNotifier extends ChangeNotifier {
  List<String> jobList = [];

  void jobListParser(String jobListFromIPGScan) {
    jobList = jobListFromIPGScan.split('\n');
    jobList.removeLast();
    print(jobList);
    notifyListeners();
  }
}

final selectedJobIndexProvider = StateProvider<int>((ref) => 0);

final jobListProvider = ChangeNotifierProvider<JobListNotifier>(
  (ref) {
    return JobListNotifier();
  },
);
