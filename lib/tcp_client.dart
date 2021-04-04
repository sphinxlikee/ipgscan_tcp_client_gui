import 'package:flutter/foundation.dart';
import 'dart:io';

class TCPClient {
  final String serverAddress;
  final int serverPort;
  Socket socket;
  bool isConnected, isDone, hasReceivedData, hasSentData;

  TCPClient({
    @required this.serverAddress,
    @required this.serverPort,
  })  : isConnected = false,
        isDone = false,
        hasReceivedData = false,
        hasSentData = false;
}
