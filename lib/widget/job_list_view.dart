import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/provider/tcp_provider.dart';


class JobListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final jobListWatcher = watch(jobListProvider);
    final selectedJobIndex = watch(selectedJobIndexProvider);

    return ListView.builder(
      itemCount: jobListWatcher.jobList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: index == selectedJobIndex.state
              ? Icon(Icons.work, color: Colors.orange)
              : Icon(Icons.work_outline, color: Colors.black),
          title: index == selectedJobIndex.state
              ? Text(jobListWatcher.jobList[index],
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold))
              : Text(jobListWatcher.jobList[index],
                  style: TextStyle(color: Colors.black)),
          onTap: () => selectedJobIndex.state = index,
        );
      },
    );
  }
}
