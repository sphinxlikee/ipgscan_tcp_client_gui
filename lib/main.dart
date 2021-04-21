import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/tcp_client.dart';

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

final serverAddressProvider = Provider<String>((ref) => '127.0.0.1');
final serverPortProvider = Provider<int>((ref) => 64123);
final tcpClientProvider = ChangeNotifierProvider<TCPClient>(
  (ref) => TCPClient(
    serverAddress: ref.read(serverAddressProvider),
    serverPort: ref.read(serverPortProvider),
  ),
);

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
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
          DataSendIndicator(),
          DataReceiveIndicator(),
          ConnectionIndicator(),
        ],
      ),
      floatingActionButton: ConnectButton(),
    );
  }
}

class ConnectButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;
    return FloatingActionButton(
      onPressed: isConnected ? null : () async => await context.read(tcpClientProvider).createConnection(),
      tooltip: isConnected ? 'Connected' : 'Connect',
      child: isConnected ? Icon(Icons.connect_without_contact_outlined) : Icon(Icons.touch_app_sharp),
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
              context.read(tcpClientProvider).writeToStream('DateTime: ${DateTime.now()}');
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
