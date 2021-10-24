// ignore_for_file: avoid_print
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class TCPClient with ChangeNotifier {
  final String serverAddress;
  final int serverPort;
  String receivedData;
  bool _isConnected, _isDataReceived, _isDataSent;
  late Socket _socket;

  TCPClient({
    required this.serverAddress,
    required this.serverPort,
  })  : _isConnected = false,
        _isDataReceived = false,
        _isDataSent = false,
        receivedData = ' ';

  bool get isConnected => _isConnected;
  bool get isDataReceived => _isDataReceived;
  bool get isDataSent => _isDataSent;
  Socket get socket => _socket;

  void changeConnectionState() {
    if (!_isConnected) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }

    notifyListeners();
  }

  void changeDataReceivedState(Uint8List data) {
    receivedData = String.fromCharCodes(data);
    print('received data in function: $receivedData');

    if (!_isDataReceived) _isDataReceived = true;
    notifyListeners();
  }

  void _changeDataSentState() {
    _isDataSent = true;
    notifyListeners();
  }

  Future<void> streamDone() async {
    _isDataReceived = false;
    _isDataSent = false;
    receivedData = 'empty';
    await _socket.flush();
    await _socket.close();
    notifyListeners();
  }

  void writeToServer(String data) {
    _socket.write(data);
    if (!isDataSent) {
      _changeDataSentState();
    }
  }

  Future<void> createConnection(BuildContext context) async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
      _socket.listen(
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
