import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/provider/tcp_provider.dart';

String sampleJobList = 'deneme\nfocus_run\npoint_and_shoot_example\n';

class ParseListButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final jobListWatcher = watch(jobListProvider);
    return ElevatedButton(
      onPressed: () => jobListWatcher.jobListParser(jobListWatcher.ipgJobs),
      child: Text('Parse the job list'),
    );
  }
}

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class JobListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final jobListWatcher = watch(jobListProvider);
    final selectedIndex = watch(selectedIndexProvider);

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
          onTap: () => selectedIndex.state = index,
        );
      },
    );
  }
}
