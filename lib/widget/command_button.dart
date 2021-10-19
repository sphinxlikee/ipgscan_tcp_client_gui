// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';
import '../ipg/ipgscan_api.dart';

class IPGScanJobCommandButton extends ConsumerWidget {
  final String labelName;
  final ipgScanCommandList commandType;
  final String parameter;

  IPGScanJobCommandButton({
    @required this.commandType,
    @required this.parameter,
  }) : labelName =
            commandType != null ? ipgScanCommandMap[commandType] : 'null';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final tcpClient = watch(tcpClientProvider);

    return ElevatedButton(
      onPressed: !tcpClient.isConnected
          ? null
          : () => context
              .read(tcpClientProvider)
              .writeToServer(setCommand(commandType, parameter)),
      child: Text(labelName),
    );
  }
}
