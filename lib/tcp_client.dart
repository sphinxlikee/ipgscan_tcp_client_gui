import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer' as developer;

class TCPClient with ChangeNotifier {
  final String serverAddress;
  final int serverPort;
  Socket _socket;
  bool _isConnected, _dataReceived, _dataSent;

  TCPClient({
    @required this.serverAddress,
    @required this.serverPort,
  })  : _isConnected = false,
        _dataReceived = false,
        _dataSent = false;

  get connectionState => _isConnected;
  get dataReceivedState => _dataReceived;
  get dataSentState => _dataSent;
  get clientSocket => _socket;

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

  Future<void> createConnection() async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
      changeConnectionState();
      developer.log(
        'connected to ${_socket.address}:${_socket.port} from ${_socket.remoteAddress}:${_socket.remotePort}.',
      );
    } catch (e) {
      print('connection has an error and socket is null.');
      print(e);
      return;
    }

    _socket.listen(
      (event) {
        var received = String.fromCharCodes(event);
        developer.log('received: $received');

        if (!_dataReceived) {
          changeDataReceivedState();
        }
      },
    )
      ..onDone(
        () {
          changeConnectionState();
          streamDone();
          developer.log('socket is closed');
        },
      )
      ..onError(
        (error, stackTrace) {
          print('$error');
        },
      );
  }
}
