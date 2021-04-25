import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/main.dart';

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
