// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widget/connection_info.dart';
import 'widget/job_list_view.dart';
import 'widget/command_button_grid.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
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

class MyHomePage extends ConsumerWidget {
  final String title;
  const MyHomePage({this.title});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
                Container(
                  height: 2,
                  color: Colors.black26,
                ),
                ReceivedDataDisplay(),
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
                Container(
                  height: 2,
                  color: Colors.black26,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
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
