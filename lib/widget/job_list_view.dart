import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ipg/ipgscan_api.dart';
import '../provider/tcp_provider.dart';
import '../provider/job_list_provider.dart';

class JobListView extends ConsumerStatefulWidget {
  const JobListView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JobListViewState();
}

class _JobListViewState extends ConsumerState<JobListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tcpClient = ref.watch(tcpClientProvider);
    final jobListWatcher = ref.watch(jobListProvider);
    final selectedJobIndex = ref.watch(selectedJobIndexProvider);
    final lastCommand = ref.watch(lastCommandProvider);

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        if (lastCommand == ipgScanCommandList.jobList) {
          jobListWatcher.jobListParser(tcpClient.dataReceived);
        }
      },
    );

    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: jobListWatcher.jobList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: index == selectedJobIndex
                ? const Icon(Icons.work, color: Colors.orange)
                : const Icon(Icons.work_outline, color: Colors.black),
            title: index == selectedJobIndex
                ? Text(
                    jobListWatcher.jobList[index],
                    style: const TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  )
                : Text(
                    jobListWatcher.jobList[index],
                    style: const TextStyle(color: Colors.black),
                  ),
            onTap: () =>
                ref.read(selectedJobIndexProvider.notifier).state = index,
          );
        },
      ),
    );
  }
}
