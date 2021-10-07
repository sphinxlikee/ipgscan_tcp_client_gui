import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class TCPClient with ChangeNotifier {
  final String serverAddress;
  final int serverPort;
  String receivedData;
  bool _isClientConnected, _isDataReceived, _isDataSent;
  Socket _socket;

  TCPClient({
    @required this.serverAddress,
    @required this.serverPort,
  })  : _isClientConnected = false,
        _isDataReceived = false,
        _isDataSent = false,
        receivedData = ' ';

  bool get connectionState => _isClientConnected;
  bool get dataReceivedState => _isDataReceived;
  bool get dataSentState => _isDataSent;
  Socket get socket => _socket;

  void changeConnectionState() {
    if (!_isClientConnected)
      _isClientConnected = true;
    else
      _isClientConnected = false;

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

  void writeToStream(String data) {
    _socket.write('$data');
    if (!dataSentState) {
      _changeDataSentState();
    }
  }

  Future<void> createConnection(BuildContext context) async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
      changeConnectionState();
    } catch (error, stack) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Connection Warning'),
          content: Text(stack.toString()),
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
