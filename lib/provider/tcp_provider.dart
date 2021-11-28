// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tcp/tcp_client.dart';
import '../ipg/ipgscan_api.dart';

final serverAddressProvider = StateProvider<String>((ref) => '127.0.0.1');
final serverPortProvider = StateProvider<int>((ref) => 88);

TCPClient tcpClient = TCPClient.initial();

final tcpClientProvider = StateNotifierProvider<TCPClientNotifier, TCPClient>(
  (ref) {
    tcpClient.serverAddress = ref.read(serverAddressProvider);
    print('tcpClientProvider is here');
    tcpClient.serverPort = ref.read(serverPortProvider);
    return TCPClientNotifier(tcpClient);
  },
);

final lastCommandProvider =
    StateProvider((ref) => ipgScanCommandList.noCommand);
