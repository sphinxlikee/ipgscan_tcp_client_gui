// ignore_for_file: use_key_in_widget_constructors
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
        decoration: const InputDecoration(
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
        decoration: const InputDecoration(
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
  Widget build(BuildContext context,  WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;
    return isConnected
        ? const FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.connect_without_contact_outlined),
            tooltip: 'Connected',
          )
        : FloatingActionButton(
            onPressed: () async {
              await ref.read(tcpClientProvider).createConnection(context);
            },
            child: const Icon(Icons.touch_app_sharp),
            tooltip: 'Press for connect',
          );
  }
}

class ConnectionCloseButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;
    return isConnected
        ? ElevatedButton(
            onPressed: () async {
              await ref.read(tcpClientProvider).socket.close();
            },
            child: const Text('Press for disconnect'),
          )
        : const ElevatedButton(
            onPressed: null,
            child: Text('Waiting for connection'),
          );
  }
}

class ConnectionIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isConnected ? Colors.green : Colors.red,
        ),
      ),
      title: const Text('Connection Status '),
      subtitle:
          isConnected ? const Text('Connected') : const Text('Disconnected'),
    );
  }
}

class DataSendIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    final isDataSent = ref.watch(tcpClientProvider).isDataSent;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDataSent ? Colors.green : Colors.red,
        ),
      ),
      title: const Text('Data'),
      subtitle: isDataSent ? const Text('Sent') : const Text('Not sent'),
    );
  }
}

class DataReceiveIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDataReceived = ref.watch(tcpClientProvider).isDataReceived;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDataReceived ? Colors.green : Colors.red,
        ),
      ),
      title: const Text('Data'),
      subtitle:
          isDataReceived ? const Text('Received') : const Text('Not received'),
    );
  }
}

class ReceivedDataDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receivedData = ref.watch(tcpClientProvider).receivedData;

    return Text(receivedData);
  }
}
