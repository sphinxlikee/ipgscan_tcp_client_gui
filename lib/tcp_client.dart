import 'package:flutter/foundation.dart';
import 'dart:io';

class TCPClient {
  final String hostAddress;
  final int hostPort;
  Socket socket;
  bool isConnected, isDone, hasReceivedData, hasSentData;

  TCPClient({
    @required this.hostAddress,
    @required this.hostPort,
  })  : isConnected = false,
        isDone = false,
        hasReceivedData = false,
        hasSentData = false;
}
