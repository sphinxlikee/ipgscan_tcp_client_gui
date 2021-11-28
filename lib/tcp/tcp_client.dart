// ignore_for_file: avoid_print
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TCPClient {
  String serverAddress;
  int serverPort;
  String receivedData;
  bool isConnected, isDataReceived, isDataSent;

  TCPClient(
    this.serverAddress,
    this.serverPort,
    this.receivedData,
    this.isConnected,
    this.isDataReceived,
    this.isDataSent,
  );

  factory TCPClient.initial() {
    return TCPClient(
      '127.0.0.1',
      88,
      '',
      false,
      false,
      false,
    );
  }

  TCPClient copyWith({
    String? serverAddress,
    int? serverPort,
    String? receivedData,
    bool? isConnected,
    bool? isDataReceived,
    bool? isDataSent,
  }) {
    return TCPClient(
      serverAddress ?? this.serverAddress,
      serverPort ?? this.serverPort,
      receivedData ?? this.receivedData,
      isConnected ?? this.isConnected,
      isDataReceived ?? this.isDataReceived,
      isDataSent ?? this.isDataSent,
    );
  }
}

class TCPClientNotifier extends StateNotifier<TCPClient> {
  Socket? socket;
  final TCPClient tcpClient;
  TCPClientNotifier(this.tcpClient) : super(tcpClient);

  void changeConnectionState() {
    if (!state.isConnected) {
      state = state.copyWith(isConnected: true);
    } else {
      state = state.copyWith(isConnected: false);
    }
  }

  void changeDataSentState() => state = state.copyWith(isDataSent: true);

  void changeDataReceivedState(Uint8List data) {
    state = state.copyWith(
      receivedData: String.fromCharCodes(data),
      isDataReceived: true,
    );
    print('received data in function: ${state.receivedData}');
  }

  Future<void> streamDone() async {
    state = state.copyWith(
      isConnected: false,
      receivedData: '',
      isDataReceived: false,
      isDataSent: false,
    );
    await socket?.flush();
    await socket?.close();
  }

  Future<void> writeToServer(String data) async {
    socket?.write(data);
    if (!state.isDataSent) changeDataSentState();
  }

  Future<void> createConnection(BuildContext context) async {
    try {
      socket = await Socket.connect(state.serverAddress, state.serverPort);
      socket?.listen(
        (Uint8List data) {
          changeDataReceivedState(data);
        },
        onDone: () {
          changeConnectionState();
          streamDone();
          print('socket is closed');
        },
      );
      changeConnectionState();
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
