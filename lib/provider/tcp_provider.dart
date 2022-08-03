// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tcp/tcp_client.dart';
import '../ipg/ipgscan_api.dart';

TCPClient tcpClient = TCPClient.initial();

final tcpClientProvider = StateNotifierProvider<TCPClientNotifier, TCPClient>(
  (ref) {
    return TCPClientNotifier(tcpClient);
  },
);

final lastCommandProvider =
    StateProvider<IPGScanCommandList>((ref) => IPGScanCommandList.noCommand);

final tcpClientdataProvider = StateProvider<String>((ref) {
  final data = ref.watch(tcpClientProvider).dataReceived;
  print('data: $data');

  return data;
});
