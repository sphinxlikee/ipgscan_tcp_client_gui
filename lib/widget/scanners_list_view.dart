import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ipg/ipgscan_api.dart';
import '../provider/tcp_provider.dart';
import '../provider/scanner_list_provider.dart';

class ScannerListView extends ConsumerStatefulWidget {
  const ScannerListView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScannerListViewState();
}

class _ScannerListViewState extends ConsumerState<ScannerListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tcpClient = ref.watch(tcpClientProvider);
    final scannerListWatcher = ref.watch(scannerListProvider);
    final selectedScannerIndex = ref.watch(selectedScannerIndexProvider);
    final lastCommand = ref.watch(lastCommandProvider);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (lastCommand == IPGScanCommandList.scannerGetList) {
          scannerListWatcher.scannerListParser(tcpClient.dataReceived);
        }
      },
    );

    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: scannerListWatcher.scannerList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: index == selectedScannerIndex
                ? const Icon(Icons.settings_suggest_outlined,
                    color: Colors.orange)
                : const Icon(Icons.settings_sharp, color: Colors.black),
            title: index == selectedScannerIndex
                ? Text(
                    scannerListWatcher.scannerList[index],
                    style: const TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  )
                : Text(
                    scannerListWatcher.scannerList[index],
                    style: const TextStyle(color: Colors.black),
                  ),
            onTap: () =>
                ref.read(selectedScannerIndexProvider.notifier).state = index,
          );
        },
      ),
    );
  }
}
