import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/provider/tcp_provider.dart';
import 'package:intl/intl.dart';

class TCPClient {
  String serverAddress;
  int serverPort;
  String dataReceived, dataSent;
  bool isConnected, isDataReceived, isDataSent;
  DateTime dataReceivedTimestamp, dataSentTimestamp;
  List<String> dataReceivedList, dataSentList;
  List<String> dataReceivedSentList;
  StreamSubscription<Uint8List>? tcpSubscription;

  TCPClient(
    this.serverAddress,
    this.serverPort,
    this.isConnected,
    this.dataReceived,
    this.dataReceivedList,
    this.isDataReceived,
    this.dataReceivedTimestamp,
    this.dataSent,
    this.dataSentList,
    this.isDataSent,
    this.dataSentTimestamp,
    this.dataReceivedSentList,
  );

  factory TCPClient.initial() {
    return TCPClient(
      '127.0.0.1',
      88,
      false,
      StringBuffer().toString(),
      [StringBuffer().toString()],
      false,
      DateTime.now(),
      StringBuffer().toString(),
      [StringBuffer().toString()],
      false,
      DateTime.now(),
      [StringBuffer().toString()],
    );
  }

  TCPClient copyWith({
    String? serverAddress,
    int? serverPort,
    bool? isConnected,
    String? dataReceived,
    List<String>? dataReceivedList,
    bool? isDataReceived,
    DateTime? dataReceivedTimestamp,
    String? dataSent,
    List<String>? dataSentList,
    bool? isDataSent,
    DateTime? dataSentTimestamp,
  }) {
    return TCPClient(
      serverAddress ?? this.serverAddress,
      serverPort ?? this.serverPort,
      isConnected ?? this.isConnected,
      dataReceived ?? this.dataReceived,
      dataReceivedList ?? this.dataReceivedList,
      isDataReceived ?? this.isDataReceived,
      dataReceivedTimestamp ?? this.dataReceivedTimestamp,
      dataSent ?? this.dataSent,
      dataSentList ?? this.dataSentList,
      isDataSent ?? this.isDataSent,
      dataSentTimestamp ?? this.dataSentTimestamp,
      dataReceivedSentList,
    );
  }
}

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
    final _dateformat = DateFormat.Hms();
    socket?.write(data);
    state = state.copyWith(
      dataSent: data.substring(0, data.length - 1), // to remove line feed
      dataSentTimestamp: DateTime.now(),
    );
    state.dataSentList
        .add('#sent: ${_dateformat.format(DateTime.now())} ${state.dataSent}');

    state.dataReceivedSentList.add(state.dataSentList.last);

    if (!state.isDataSent) {
      state = state.copyWith(isDataSent: true);
    }
  }

  Future<void> listenServer() async {
    tcpClient.tcpSubscription = socket?.listen((event) {});

    tcpClient.tcpSubscription?.onData(
      (Uint8List data) async {
        final _dateformat = DateFormat.Hms();
        state = state.copyWith(
          dataReceivedTimestamp: DateTime.now(),
          dataReceived: String.fromCharCodes(data),
          isDataReceived: true,
        );
        print(state.dataReceived);
        String.fromCharCodes(data).split('\n').toList().forEach(
          (element) {
            if (element.isNotEmpty) {
              state.dataReceivedList.add(
                '#received: ${_dateformat.format(state.dataReceivedTimestamp)} $element',
              );
              state.dataReceivedSentList.add(state.dataReceivedList.last);
            }
          },
        );
      },
    );

    tcpClient.tcpSubscription?.onDone(
      () {
        changeConnectionState();
        streamDone();
      },
    );

    changeConnectionState();
  }

  Future<void> createConnection(BuildContext context) async {
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
