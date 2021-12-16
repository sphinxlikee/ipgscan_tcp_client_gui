import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobList extends ChangeNotifier {
  List<String> jobList = [];

  Future<void> jobListParser(String receivedJobList) async {
    jobList = receivedJobList.split('\n');
    jobList = jobList..removeLast();
    notifyListeners();
  }
}

final jobListProvider = ChangeNotifierProvider<JobList>(
  (ref) => JobList(),
);

final selectedJobIndexProvider = StateProvider<int>((ref) => 0);
