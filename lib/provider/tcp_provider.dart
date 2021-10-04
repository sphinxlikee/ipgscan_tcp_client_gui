import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:flutter_tcp_client/tcp/tcp_client.dart';

final serverAddressProvider = StateProvider<String>((ref) => '127.0.0.1');
final serverPortProvider = StateProvider<int>((ref) => 88);

final tcpClientProvider = ChangeNotifierProvider<TCPClient>(
  (ref) => TCPClient(
    serverAddress: ref.read(serverAddressProvider).state,
    serverPort: ref.read(serverPortProvider).state,
  ),
);

final streamProvider = StreamProvider.autoDispose<Uint8List>(
  (ref) => ref.watch(tcpClientProvider).socket,
);

final socketListenProvider = StreamProvider.autoDispose<Uint8List>(
  (ref) {
    final client = ref.watch(tcpClientProvider);

    client.socket
      ..listen(
        (event) {
          ref.watch(receivedDataProvider).state = String.fromCharCodes(event);
          //print(String.fromCharCodes(event));
          if (!client.dataReceivedState) {
            client.changeDataReceivedState();
          }
        },
      ).onDone(
        () {
          client
            ..changeConnectionState()
            ..streamDone();
          print('socket is closed');
        },
      );

    return client.socket;
  },
);

class JobListNotifier extends ChangeNotifier {
  String ipgJobs = '';
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

final receivedDataProvider = StateProvider<String>((ref) => '');

class ReceivedData extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final socketProvider = watch(socketListenProvider);
    final receivedData = watch(receivedDataProvider).state;
    final jobListWatcher = watch(jobListProvider);

    socketProvider.whenData(
      (value) {
        context.read(receivedDataProvider).state = String.fromCharCodes(value);
        print(receivedData);
        jobListWatcher.ipgJobs = receivedData;
      },
    );

    /// son kaldigim yer;
    /// ipgscan'den gelen job list'i
    /// ekranda gösteremiyorum

    return receivedData == null
        ? Text('not connected')
        : Text('Received data: --');
  }
}
