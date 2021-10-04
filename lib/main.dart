import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/widget/connection_info.dart';
import 'package:flutter_tcp_client/widget/job_list_view.dart';
import 'package:flutter_tcp_client/widget/command_button_grid.dart';

import 'provider/tcp_provider.dart';

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
                Expanded(child: CommandButtonGrid()),
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
                ParseListButton(),
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
