import 'package:flutter/material.dart';

import 'package:flutter_tcp_client/ipg/ipgscan_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/provider/tcp_provider.dart';

class IPGScanJobCommandButton extends ConsumerWidget {
  final String labelName;
  final ipgScanCommandList commandType;
  final String parameter;

  IPGScanJobCommandButton({
    @required this.commandType,
    @required this.parameter,
  }) : labelName = commandType != null ? ipgScanCommandMap[commandType] : 'null';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isConnected = watch(tcpClientProvider).connectionState;
    return ElevatedButton(
      onPressed: !isConnected
          ? null
          : () {
              context
                  .read(tcpClientProvider)
                  .writeToStream(setCommand(commandType, parameter));
            },
      child: Text('$labelName'),
    );
  }
}
