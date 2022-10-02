import 'tcp_client.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class TCPClientNotifier extends StateNotifier<TCPClient> {
  Socket? socket;
  final TCPClient tcpClient;
  TCPClientNotifier(this.tcpClient) : super(tcpClient);

  Future<void> changeConnectionState() async {
    if (!state.isConnected) {
      state = state.copyWith(isConnected: true);
    } else {
      state = state.copyWith(isConnected: false);
    }
  }

  Future<void> streamDone() async {
    state = state.copyWith(
      isConnected: false,
      dataReceived: '',
      isDataReceived: false,
      isDataSent: false,
    );
    await socket?.flush();
    await socket?.close();
  }

  Future<void> writeToServer(String data) async {
    final dateformat = DateFormat.Hms();
    socket?.write(data);

    // add the data to "dataSent"
    state = state.copyWith(
      dataSent: data.substring(0, data.length - 1), // to remove line feed
      dataSentTimestamp: DateTime.now(),
    );

    // create a copy of "dataSentList"
    // add a current sent item to the copy list
    // update "dataSentList"
    var sentListCopy = [...state.dataSentList];
    sentListCopy.add('#sent: ${dateformat.format(state.dataSentTimestamp as DateTime)} ${state.dataSent}');
    state = state.copyWith(dataSentList: sentListCopy);

    // create a copy of "dataReceivedSentList"
    // add a current last sent item to the copy list
    // update "dataReceivedSentList"
    var receivedSentListCopy = [...state.dataReceivedSentList];
    receivedSentListCopy.add(state.dataSentList.last);
    state = state.copyWith(dataReceivedSentList: receivedSentListCopy);

    if (!state.isDataSent) {
      state = state.copyWith(isDataSent: true);
    }
  }

  Future<void> listenServer() async {
    var tcpSubs = socket?.listen((event) {})
      ?..onData(
        (Uint8List data) async {
          final dateformat = DateFormat.Hms();
          state = state.copyWith(
            dataReceivedTimestamp: DateTime.now(),
            dataReceived: String.fromCharCodes(data),
            isDataReceived: true,
          );
          String.fromCharCodes(data).split('\n').toList().forEach(
            (element) {
              if (element.isNotEmpty) {
                // create a copy of "dataReceivedList"
                // add a current received item to the copy list
                // update "dataReceivedList"
                var receivedListCopy = [...state.dataReceivedList];
                receivedListCopy.add('#received: ${dateformat.format(state.dataReceivedTimestamp as DateTime)} $element');
                state = state.copyWith(dataReceivedList: receivedListCopy);

                // create a copy of "dataReceivedSentList"
                // add a current last received item to the copy list
                // update "dataReceivedSentList"
                var receivedSentListCopy = [...state.dataReceivedSentList];
                receivedSentListCopy.add(state.dataReceivedList.last);
                state = state.copyWith(dataReceivedSentList: receivedSentListCopy);
              }
            },
          );
        },
      )
      ..onDone(
        () {
          changeConnectionState();
          streamDone();
        },
      );

    state = state.copyWith(tcpSubscription: tcpSubs);
    changeConnectionState();
  }

  Future<void> createConnection(BuildContext context) async {
    // try connect to the IPGScan
    // if it is not possible create an alert dialog
    try {
      socket = await Socket.connect(state.serverAddress, state.serverPort);
      await listenServer();
    } catch (error) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Connection Warning'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }
}
