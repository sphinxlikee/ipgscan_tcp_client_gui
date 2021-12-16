import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widget/connection_info.dart';
import 'widget/job_list_view.dart';
import 'widget/command_button_grid.dart';
import 'widget/data_exchange_list_view.dart';
import 'widget/connection_info_indicators.dart';
import 'widget/connection_control.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TCP/IP Client'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const IPAddressTextField(),
                const PortTextField(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ConnectButton(),
                      SizedBox(width: 40),
                      ConnectionCloseButton(),
                    ],
                  ),
                ),
                Container(height: 2, color: Colors.black26),
                const DataSendIndicator(),
                const DataReceiveIndicator(),
                const ConnectionIndicator(),
                Container(height: 2, color: Colors.black26),
                IPGScanStateDisplay(),
                Container(height: 2, color: Colors.black26),
                ReceivedDataDisplay(),
              ],
            ),
          ),
          Container(width: 2, color: Colors.black26),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    child: Text('Control Buttons'),
                  ),
                ),
                Container(height: 2, color: Colors.black26),
                const Expanded(child: CommandButtonGrid()),
              ],
            ),
          ),
          Container(width: 2, color: Colors.black26),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    child: Text('Job list in C:\\IPGP\\IPGScan\\Jobs'),
                  ),
                ),
                const ParseListButton(),
                Container(height: 2, color: Colors.black26),
                const Expanded(child: JobListView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
