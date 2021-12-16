import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';

class DataSentIndicator extends ConsumerWidget {
  const DataSentIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDataSent = ref.watch(tcpClientProvider).isDataSent;
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDataSent ? Colors.green : Colors.red,
            ),
          ),
          Text(isDataSent ? 'Data sent' : 'No data sent'),
        ],
      ),
    );
  }
}

class DataReceivedIndicator extends ConsumerWidget {
  const DataReceivedIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDataReceived = ref.watch(tcpClientProvider).isDataReceived;
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDataReceived ? Colors.green : Colors.red,
            ),
          ),
          Text(isDataReceived ? 'Data received' : 'No data received'),
        ],
      ),
    );
  }
}

class ConnectionIndicator extends ConsumerWidget {
  const ConnectionIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? Colors.green : Colors.red,
            ),
          ),
          Text(isConnected ? 'Connection ready' : 'No connection'),
        ],
      ),
    );
  }
}
