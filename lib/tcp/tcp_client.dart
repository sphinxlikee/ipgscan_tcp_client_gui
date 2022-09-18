import 'dart:typed_data';
import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tcp_client.freezed.dart';

@freezed
class TCPClient with _$TCPClient {
  const TCPClient._();

  factory TCPClient({
    @Default('127.0.0.1') String serverAddress,
    @Default(88) int serverPort,
    @Default('') String dataReceived,
    @Default('') String dataSent,
    @Default(false) bool isConnected,
    @Default(false) bool isDataReceived,
    @Default(false) bool isDataSent,
    DateTime? dataReceivedTimestamp,
    DateTime? dataSentTimestamp,
    @Default(['']) List<String> dataReceivedList,
    @Default(['']) List<String> dataSentList,
    @Default(['']) List<String> dataReceivedSentList,
    StreamSubscription<Uint8List>? tcpSubscription,
  }) = _TCPClient;

}
