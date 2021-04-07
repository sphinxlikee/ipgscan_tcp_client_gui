import 'dart:math';

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:developer' as developer;

class TCPClient {
  final String serverAddress;
  final int serverPort;
  Socket socket;
  bool isConnected, isDone, dataReceived, dataSent;

  TCPClient({
    @required this.serverAddress,
    @required this.serverPort,
  })  : isConnected = false,
        isDone = false,
        dataReceived = false,
        dataSent = false;

  Future<void> createConnection(TCPClient tc) async {
    await Socket.connect(tc.serverAddress, tc.serverPort).catchError(
      (e) {
        print('connection has an error and socket is null.');
        print(e);
      },
    ).then(
      (socket) {
        tc.socket = socket;
        tc.isDone = false;
        tc.isConnected = true;
        developer.log(
          'connected to ${tc.socket.address}:${tc.socket.port} from ${tc.socket.remoteAddress}:${tc.socket.remotePort}.',
        );

        // use onData method in the code where you need.
        tc.socket.listen(
          (event) {
            var received = String.fromCharCodes(event);
            developer.log('received: $received');

            if (!tc.dataReceived) {
              tc.dataReceived = true;
              tc.isDone = false;
            }
          },
        )..onDone(
            () {
              tc.isDone = true;
              tc.isConnected = false;
              tc.dataReceived = false;
              tc.dataSent = false;
              developer.log('socket is closed');
            },
          );
      },
    );
  }
}
