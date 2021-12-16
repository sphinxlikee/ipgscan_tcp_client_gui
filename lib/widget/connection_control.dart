import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';

class IPAddressTextField extends ConsumerStatefulWidget {
  const IPAddressTextField({Key? key}) : super(key: key);

  @override
  ConsumerState<IPAddressTextField> createState() => _IPAddressTextFieldState();
}

class _IPAddressTextFieldState extends ConsumerState<IPAddressTextField> {
  final ipAddressTextController = TextEditingController();
  @override
  void initState() {
    ipAddressTextController.text = ref.read(tcpClientProvider).serverAddress;
    ipAddressTextController.addListener(_setAddressValue);
    super.initState();
  }

  void _setAddressValue() {
    final value = ipAddressTextController.text;
    ref.read(tcpClientProvider).serverAddress = value;
  }

  @override
  void dispose() {
    ipAddressTextController.dispose();
    super.dispose();
  }

  // TODO: IP address check & validation
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

class PortTextField extends ConsumerStatefulWidget {
  const PortTextField({Key? key}) : super(key: key);

  @override
  ConsumerState<PortTextField> createState() => _PortTextFieldState();
}

class _PortTextFieldState extends ConsumerState<PortTextField> {
  TextEditingController portTextController = TextEditingController();
  static const portDefaultValue = 0;
  @override
  void initState() {
    portTextController.text = ref.read(tcpClientProvider).serverPort.toString();
    portTextController.addListener(_setPortValue);
    super.initState();
  }

  void _setPortValue() {
    final value = int.tryParse(portTextController.text) ?? portDefaultValue;
    ref.read(tcpClientProvider).serverPort = value;
  }

  @override
  void dispose() {
    portTextController.dispose();
    super.dispose();
  }

  // TODO: IP port check & validation
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: portTextController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "IPGScan's port",
        ),
      ),
    );
  }
}

class ConnectButton extends ConsumerWidget {
  const ConnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;
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
  const ConnectionCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isClientConnected = ref.watch(tcpClientProvider).isConnected;
    return isClientConnected
        ? ElevatedButton(
            onPressed: () async {
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