import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';

class ParseListButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isClientConnected = watch(tcpClientProvider).connectionState;
    final jobListWatcher = watch(jobListProvider);
    final tcpClient = watch(tcpClientProvider);
    return ElevatedButton(
      onPressed: !isClientConnected
          ? null
          : () => jobListWatcher.jobListParser(tcpClient.receivedData),
      child: Text('Parse the job list'),
    );
  }
}

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
