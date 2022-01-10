import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/ipg/ipgscan_api.dart';
import '../provider/tcp_provider.dart';
import '../provider/job_list_provider.dart';


// TODO will be update: variables, algorithm, working mechanism etc. 
class ScannersListView extends ConsumerStatefulWidget {
  const ScannersListView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScannersListViewState();
}

class _ScannersListViewState extends ConsumerState<ScannersListView> {
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
                ? const Icon(Icons.lock_outline, color: Colors.orange)
                : const Icon(Icons.lock_open, color: Colors.black),
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
