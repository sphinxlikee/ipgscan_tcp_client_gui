import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';

class TCPClient with ChangeNotifier {
  final String serverAddress;
  final int serverPort;
  Socket _socket;
  String receivedData;
  bool _isConnected, _dataReceived, _dataSent;

  TCPClient({
    @required this.serverAddress,
    @required this.serverPort,
  })  : _isConnected = false,
        _dataReceived = false,
        _dataSent = false,
        receivedData = 'empty';

  get connectionState => _isConnected;
  get dataReceivedState => _dataReceived;
  get dataSentState => _dataSent;

  void changeConnectionState() {
    if (!_isConnected)
      _isConnected = true;
    else
      _isConnected = false;

    notifyListeners();
  }

  void changeDataReceivedState() {
    _dataReceived = true;
    notifyListeners();
  }

  void changeDataSentState() {
    _dataSent = true;
    notifyListeners();
  }

  void streamDone() async {
    _dataReceived = false;
    _dataSent = false;
    receivedData = 'empty';
    await _socket.flush();
    await _socket.close();
    notifyListeners();
  }

  void writeToStream(String data) {
    _socket.write('$data\r\n');
    if (!dataSentState) {
      changeDataSentState();
    }
  }

  void getData(var data) {
    receivedData = data;
    notifyListeners();
  }

  Future<void> createConnection() async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
      changeConnectionState();
    } catch (e) {
      print('connection has an error and socket is null.');
      print(e);
      return;
    }

    _socket.listen(
      (event) {
        getData(String.fromCharCodes(event));
        print('received: $receivedData');

        if (!_dataReceived) {
          changeDataReceivedState();
        }
      },
    )
      ..onDone(
        () {
          changeConnectionState();
          streamDone();
          print('socket is closed');
        },
      )
      ..onError(
        (error, stackTrace) {
          print('$error');
        },
      );
  }
}
