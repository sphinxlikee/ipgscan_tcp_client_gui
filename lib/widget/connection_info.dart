import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';

final ipAddressTextController = TextEditingController()..text = '127.0.0.1';
final portTextController = TextEditingController()..text = '88';

class IPAddressTextField extends StatelessWidget {
  void dispose() {
    ipAddressTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: ipAddressTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "IPGScan's IP address",
        ),
      ),
    );
  }
}

class PortTextField extends StatelessWidget {
  void dispose() {
    portTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: portTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "IPGScan's port",
        ),
        onChanged: (String val) {
          portTextController.value = TextEditingValue(text: val);
        },
      ),
    );
  }
}

class ConnectButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final tcpClient = watch(tcpClientProvider);
    return tcpClient.connectionState
        ? FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.connect_without_contact_outlined),
            tooltip: 'Connected',
          )
        : FloatingActionButton(
            onPressed: () async {
              await tcpClient.createConnection(context);
              tcpClient.listenSocket(tcpClient);
            },
            child: Icon(Icons.touch_app_sharp),
            tooltip: 'Press for connect',
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

class ReceivedDataDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final tcpClient = watch(tcpClientProvider);

    /// son kaldigim yer;
    /// ipgscan'den gelen job list'i
    /// ekranda gösteremiyorum

    return tcpClient.receivedData == null
        ? Text('not connected')
        : Text('Received data:\n ${tcpClient.receivedData}');
  }
}
