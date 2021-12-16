import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';

// TODO: divide widgets to another files : connection_info to ???

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

class ConnectionIndicator extends ConsumerWidget {
  const ConnectionIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isClientConnected = ref.watch(tcpClientProvider).isConnected;
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
  const DataSendIndicator({Key? key}) : super(key: key);

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
  const DataReceiveIndicator({Key? key}) : super(key: key);

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

class DataLine extends StatelessWidget {
  const DataLine({
    Key? key,
    required this.data,
  }) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(data),
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      margin: const EdgeInsets.only(left: 16.0),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
          border: Border.symmetric(vertical: BorderSide.none)),
    );
  }
}

class DataExchangeScrollView extends ConsumerStatefulWidget {
  const DataExchangeScrollView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DataExchangeScrollViewState();
}

class _DataExchangeScrollViewState
    extends ConsumerState<DataExchangeScrollView> {
  final ScrollController _scrollController = ScrollController();

  void animateScrollbarToBottom(Duration duration) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcpClient = ref.watch(tcpClientProvider);
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => animateScrollbarToBottom(const Duration(milliseconds: 250)),
    );
    return Expanded(
      child: Container(
        margin: EdgeInsets.zero,
        child: Scrollbar(
          controller: _scrollController,
          interactive: true,
          isAlwaysShown: true,
          showTrackOnHover: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
                children: tcpClient.dataReceivedSentList
                    .map((e) => DataLine(data: e))
                    .toList()),
          ),
        ),
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        alignment: Alignment.bottomLeft,
      ),
    );
  }
}
