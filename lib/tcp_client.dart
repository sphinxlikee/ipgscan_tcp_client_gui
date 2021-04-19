import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void writeToStream(TCPClient tcpClient, String data) {
    tcpClient.clientSocket.write('$data\r\n');
    if (!tcpClient.dataSentState) {
      tcpClient.changeDataSentState();
    }
  }

  Future<void> createConnection(TCPClient tcpc) async {
    try {
      tcpc._socket = await Socket.connect(tcpc.serverAddress, tcpc.serverPort);
      tcpc.changeConnectionState();
      developer.log(
        'connected to ${tcpc._socket.address}:${tcpc._socket.port} from ${tcpc._socket.remoteAddress}:${tcpc._socket.remotePort}.',
      );
    } catch (e) {
      print('connection has an error and socket is null.');
      print(e);
      return;
    }

    tcpc.clientSocket.listen(
      (event) {
        var received = String.fromCharCodes(event);
        developer.log('received: $received');

        if (!tcpc._dataReceived) {
          tcpc.changeDataReceivedState();
        }
      },
    )
      ..onDone(
        () {
          tcpc.changeConnectionState();
          tcpc.streamDone();
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

final firebaseAuthProvider = StreamProvider.autoDispose<Socket>((ref) {});
