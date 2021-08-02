import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String sampleJobList = 'deneme\nfocus_run\npoint_and_shoot_example\n';

class JobListNotifier extends ChangeNotifier {
  List<String> jobList = [];

  void jobListParser(String jobListFromIPGScan) {
    jobList = jobListFromIPGScan.split("\n");
    jobList.removeLast();
    notifyListeners();
  }
}

final jobListProvider = ChangeNotifierProvider<JobListNotifier>(
  (ref) {
    return JobListNotifier();
  },
);

class ParseListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          context.read(jobListProvider).jobListParser(sampleJobList),
      child: Text('Parse the job list'),
    );
  }
}

final selectedIndexStateProvider = StateProvider<int>((ref) => 0);

class JobListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final jobListWatcher = watch(jobListProvider);
    final selectedIndex = watch(selectedIndexStateProvider);

    return ListView.builder(
      itemCount: jobListWatcher.jobList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: index == selectedIndex.state
              ? Icon(Icons.work, color: Colors.orange)
              : Icon(Icons.work_outline, color: Colors.black),
          title: index == selectedIndex.state
              ? Text(jobListWatcher.jobList[index],
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold))
              : Text(jobListWatcher.jobList[index],
                  style: TextStyle(color: Colors.black)),
          onTap: () {
            selectedIndex.state = index;
          },
        );
      },
    );
  }
}