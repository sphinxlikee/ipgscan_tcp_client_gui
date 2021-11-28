// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ipg/ipgscan_api.dart';
import '../widget/command_button.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;
    print('connect button: $isConnected');
    return isConnected
        ? const FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.connect_without_contact_outlined),
            tooltip: 'Connected',
          )
        : FloatingActionButton(
            onPressed: () async {
              await ref
                  .read(tcpClientProvider.notifier)
                  .createConnection(context);
            },
            child: const Icon(Icons.touch_app_sharp),
            tooltip: 'Press for connect',
          );
  }
}

class ConnectionCloseButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isClientConnected = ref.watch(tcpClientProvider).isConnected;
    return isClientConnected
        ? ElevatedButton(
            onPressed: () async {
              // await ref.read(tcpClient2Provider.notifier).socket?.close();
              await ref.read(tcpClientProvider.notifier).streamDone();
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
    final isClientConnected = ref.watch(tcpClientProvider).isConnected;
    print('connection indicator-isConnected: $isClientConnected');
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isClientConnected ? Colors.green : Colors.red,
        ),
      ),
      title: const Text('Connection Status '),
      subtitle: isClientConnected
          ? const Text('Connected')
          : const Text('Disconnected'),
    );
  }
}

class DataSendIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

class IPGScanStateDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastCommand = ref.watch(lastCommandProvider);
    return Text(ipgScanCommandMap[lastCommand].toString());
  }
}
