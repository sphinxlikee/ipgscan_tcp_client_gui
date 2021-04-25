import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/tcp_client.dart';
import 'package:flutter_tcp_client/ipg_ipgscan_api.dart';
import 'package:flutter_tcp_client/widget/connection_info.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter-TCP/IP Client'),
    );
  }
}

final serverAddressProvider = StateProvider<String>((ref) => '127.0.0.1');
final serverPortProvider = StateProvider<int>((ref) => 64123);
final tcpClientProvider = ChangeNotifierProvider<TCPClient>(
  (ref) => TCPClient(
    serverAddress: ref.read(serverAddressProvider).state,
    serverPort: ref.read(serverPortProvider).state,
  ),
);

final streamProvider = StreamProvider.autoDispose<Uint8List>(
  (ref) => ref.watch(tcpClientProvider).socket,
);

final receivedDataProvider = StateProvider((ref) => 'empty');

final socketListenProvider = StreamProvider<Uint8List>(
  (ref) {
    final client = ref.watch(tcpClientProvider);

    client.socket
      ..listen(
        (event) {
          print(String.fromCharCodes(event));
          ref.watch(receivedDataProvider).state = String.fromCharCodes(event);
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

class ReceivedDataWithProvider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final sPro = watch(socketListenProvider);
    sPro.whenData((value) => watch(receivedDataProvider).state = String.fromCharCodes(value));
    final receivedData = watch(receivedDataProvider).state;

    return receivedData == null ? Text('not connected') : Text('Received data: $receivedData');
  }
}

class MyHomePage extends ConsumerWidget {
  final String title;
  MyHomePage({this.title});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DataSendButton(),
          SizedBox(height: 10),
          IPGScanJobCommandButton(commandType: commandEnums.JobOpen),
          SizedBox(height: 10),
          ReceivedDataWithProvider(),
          SizedBox(height: 20),
          DataSendIndicator(),
          DataReceiveIndicator(),
          ConnectionIndicator(),
        ],
      ),
      floatingActionButton: ConnectButton(),
    );
  }
}

class IPGScanJobCommandButton extends ConsumerWidget {
  final String labelName;
  final commandEnums commandType;

  IPGScanJobCommandButton({@required this.commandType}) : labelName = commandList[commandType];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;
    final fullCommand = jobList.fullCommand;
    return ElevatedButton(
      onPressed: !isConnected ? null : () => context.read(tcpClientProvider).writeToStream('$fullCommand'),
      child: Text('$labelName: ${jobOpen.parameters}'),
    );
  }
}
