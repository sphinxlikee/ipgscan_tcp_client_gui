// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tcp/tcp_client.dart';
import '../ipg/ipgscan_api.dart';

TCPClient tcpClient = TCPClient.initial();

final tcpClientProvider = StateNotifierProvider<TCPClientNotifier, TCPClient>(
  (ref) {
    print('tcpClientProvider is here');
    return TCPClientNotifier(tcpClient);
  },
);

final lastCommandProvider =
    StateProvider((ref) => ipgScanCommandList.noCommand);
