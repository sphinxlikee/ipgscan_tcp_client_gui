import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/tcp_client.dart';
import 'package:flutter_tcp_client/ipg_ipgscan_api.dart';

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

final streamProvider2 = StreamProvider<Uint8List>(
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
    final sPro = watch(streamProvider2);
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

class ReceivedData extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final receivedData = watch(tcpClientProvider).receivedData;
    return Text('Received data: $receivedData');
  }
}

class ConnectButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;

    return isConnected
        ? FloatingActionButton(
            onPressed: null,
            tooltip: 'Connected',
            child: Icon(Icons.connect_without_contact_outlined),
          )
        : FloatingActionButton(
            onPressed: () async => await context.read(tcpClientProvider).createConnection(),
            tooltip: 'Connect',
            child: Icon(Icons.touch_app_sharp),
          );
  }
}

class ConnectionIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isConnected ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Connection Status '),
      subtitle: isConnected ? Text('Connected') : Text('Disconnected'),
    );
  }
}

class DataSendButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;
    return ElevatedButton(
      onPressed: !isConnected
          ? null
          : () {
              context.read(tcpClientProvider).writeToStream('DateTime: ${DateTime.now()}\r\n');
            },
      child: Text('Send DateTime.now()'),
    );
  }
}

class DataSendIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDataSent = watch(tcpClientProvider).dataSentState;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDataSent ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: isDataSent ? Text('Sent') : Text('Not sent'),
    );
  }
}

class DataReceiveIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDataReceived = watch(tcpClientProvider).dataReceivedState;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDataReceived ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: isDataReceived ? Text('Received') : Text('Not received'),
    );
  }
}
