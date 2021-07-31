import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/tcp_client.dart';
import 'package:flutter_tcp_client/ipg_ipgscan_api.dart';
import 'package:flutter_tcp_client/widget/connection_info.dart';
import 'package:flutter_tcp_client/widget/job_list_view.dart';

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
      home: MyHomePage(title: 'IPGScan Remote API - TCP/IP Client'),
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

class ReceivedData extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final socketProvider = watch(socketListenProvider);
    socketProvider.whenData(
      (value) =>
          watch(receivedDataProvider).state = String.fromCharCodes(value),
    );
    final receivedData = watch(receivedDataProvider).state;

    return receivedData == null
        ? Text('not connected')
        : Text('Received data: $receivedData');
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
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: [
                IPAddressTextField(),
                PortTextField(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ConnectButton(),
                ),
                Container(
                  height: 2,
                  color: Colors.black26,
                ),
                DataSendIndicator(),
                DataReceiveIndicator(),
                ConnectionIndicator(),
                ParseList(),
              ],
            ),
          ),
          Container(
            width: 2,
            color: Colors.black26,
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 20,
                    child: Text('State: ??----??'),
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.black26,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 20,
                    child: Text('Control Buttons'),
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.black26,
                ),
                Expanded(child: ControlButtonGrid()),
              ],
            ),
          ),
          Container(
            width: 2,
            color: Colors.black26,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 20,
                    child: Text('Job list in C:\\IPGP\\IPGScan\\Jobs'),
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.black26,
                ),
                Expanded(child: JobListView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ControlButtonGrid extends StatefulWidget {
  @override
  _ControlButtonGridState createState() => _ControlButtonGridState();
}

class _ControlButtonGridState extends State<ControlButtonGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      childAspectRatio: 8.0,
      children: [
        IPGScanJobCommandButton(
          commandType: commandEnums.JobOpen,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobStart,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobStop,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobAbort,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobClose,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ConnectionGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.GetEncoding,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetStartBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetEnableBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetPortA,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerLock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerUnlock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerInit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerParkAt,
          parameter: parameterGalvoPositionSet,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetWorkspacePosition,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetConnectionStatus,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.SystemSetVariable,
          parameter: '$parameterVariableNumber $parameterVariableValue',
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.SystemGetVariable,
          parameter: parameterVariableNumber,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobGetStatus2,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobLastRunSuccessful,
          parameter: parameterNone,
        ),
      ],
    );
  }
}

class IPGScanJobCommandButton extends ConsumerWidget {
  final String labelName;
  final commandEnums commandType;
  final String parameter;

  IPGScanJobCommandButton({
    @required this.commandType,
    @required this.parameter,
  }) : labelName = commandType != null ? commandList[commandType] : 'null';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;
    return ElevatedButton(
      onPressed: !isConnected
          ? null
          : () => context
              .read(tcpClientProvider)
              .writeToStream(setCommand(commandType, parameter)),
      child: Text('$labelName'),
    );
  }
}
