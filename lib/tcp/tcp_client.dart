import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class TCPClient with ChangeNotifier {
  final String serverAddress;
  final int serverPort;
  String receivedData;
  bool _isConnected, _isDataReceived, _isDataSent;
  Socket _socket;

  TCPClient({
    this.serverAddress,
    this.serverPort,
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

  void changeDataReceivedState() {
    _isDataReceived = true;
    notifyListeners();
  }

  void _changeDataSentState() {
    _isDataSent = true;
    notifyListeners();
  }

  void streamDone() async {
    _isDataReceived = false;
    _isDataSent = false;
    receivedData = 'empty';
    await _socket.flush();
    await _socket.close();
    notifyListeners();
  }

    if (!isDataSent) {
      _changeDataSentState();
    }
  }

  void listenSocket(TCPClient tcpClient) {
    tcpClient.socket
      ..listen(
        (event) {
          tcpClient.receivedData = String.fromCharCodes(event);
          if (!tcpClient.dataReceivedState) {
            tcpClient.changeDataReceivedState();
          }
        },
      ).onDone(
        () {
          tcpClient
            ..changeConnectionState()
            ..streamDone();
          print('socket is closed');
        },
      );
  }

  Future<void> createConnection(BuildContext context) async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
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
      );
    }
  }
}
