// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tcp/tcp_client.dart';

final serverAddressProvider = StateProvider<String>((ref) => '127.0.0.1');
final serverPortProvider = StateProvider<int>((ref) => 88);

final tcpClientProvider = ChangeNotifierProvider<TCPClient>(
  (ref) => TCPClient(
    serverAddress: ref.read(serverAddressProvider).state,
    serverPort: ref.read(serverPortProvider).state,
  ),
);
