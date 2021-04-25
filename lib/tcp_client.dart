import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class TCPClient with ChangeNotifier {
  final String serverAddress;
  final int serverPort;
  String receivedData;
  bool _isConnected, _dataReceived, _dataSent;
  Socket _socket;

  TCPClient({
    @required this.serverAddress,
    @required this.serverPort,
  })  : _isConnected = false,
        _dataReceived = false,
        _dataSent = false,
        receivedData = 'empty';

  bool get connectionState => _isConnected;
  bool get dataReceivedState => _dataReceived;
  bool get dataSentState => _dataSent;
  Socket get socket => _socket;

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

  void _changeDataSentState() {
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

  void _getData(var data) {
    receivedData = data;
    notifyListeners();
  }

  void writeToStream(String data) {
    _socket.write('$data');
    if (!dataSentState) {
      _changeDataSentState();
    }
  }

  Future<void> createConnection() async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
      changeConnectionState();
    } catch (e) {
      print('connection has an error and socket is null.');
      print(e);
    }
  }
}
