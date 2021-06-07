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

class ReceivedData extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final socketProvider = watch(socketListenProvider);
    socketProvider.whenData(
      (value) => watch(receivedDataProvider).state = String.fromCharCodes(value),
    );
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
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
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
                SizedBox(height: 10),
                IPGScanJobCommandButton(
                  commandType: commandEnums.JobOpen,
                  parameter: fileName,
                ),
                IPGScanJobCommandButton(
                  commandType: commandEnums.JobClose,
                  parameter: fileName,
                ),
                SizedBox(height: 10),
                ReceivedData(),
              ],
            ),
          ),
          Container(
            width: 2,
            color: Colors.black26,
          ),
          Expanded(
            child: JobListView(),
          ),
        ],
      ),
    );
  }
}

class JobListView extends StatefulWidget {
  @override
  _JobListViewState createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  var jobList = List<String>.generate(
    100,
    (index) => 'Job $index',
  );

  var _selectedIndex = 0;
  var _selectedColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: index == _selectedIndex
              ? Icon(
                  Icons.work,
                  color: index == _selectedIndex ? _selectedColor : Colors.transparent,
                )
              : Icon(Icons.work_outline),
          title: Text(
            jobList[index],
            style: TextStyle(
              color: index == _selectedIndex ? _selectedColor : Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedIndex = index;
              _selectedColor = Colors.orange.shade600;
            });
            print('selected index: $_selectedIndex / selected job: ${jobList[index]}');
          },
        );
      },
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
  }) : labelName = commandList[commandType];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;
    return ElevatedButton(
      onPressed: !isConnected
          ? null
          : () => context.read(tcpClientProvider).writeToStream(
                setCommand(commandType, parameter),
              ),
      child: Text('$labelName'),
    );
  }
}
