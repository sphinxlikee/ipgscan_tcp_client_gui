// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';
import '../provider/job_list_provider.dart';

class ParseListButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isClientConnected = ref.watch(tcpClientProvider).isConnected;
    final jobListWatcher = ref.watch(jobListProvider);
    final tcpClient = ref.watch(tcpClientProvider);
    return ElevatedButton(
      onPressed: !isClientConnected
          ? null
          : () => jobListWatcher.jobListParser(tcpClient.receivedData),
      child: const Text('Parse the job list'),
    );
  }
}

class JobListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobListWatcher = ref.watch(jobListProvider);
    int selectedJobIndex = ref.watch(selectedJobIndexProvider);

    return ListView.builder(
      itemCount: jobListWatcher.jobList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: index == selectedJobIndex
              ? const Icon(Icons.work, color: Colors.orange)
              : const Icon(Icons.work_outline, color: Colors.black),
          title: index == selectedJobIndex
              ? Text(jobListWatcher.jobList[index],
                  style: const TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold))
              : Text(jobListWatcher.jobList[index],
                  style: const TextStyle(color: Colors.black)),
          onTap: () => selectedJobIndex = index,
        );
      },
    );
  }
}
