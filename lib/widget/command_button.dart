// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';
import '../ipg/ipgscan_api.dart';

class IPGScanJobCommandButton extends ConsumerWidget {
  final ipgScanCommandList commandType;
  final String parameter;
  final String? labelName;

  IPGScanJobCommandButton({
    required this.commandType,
    required this.parameter,
  }) : labelName = ipgScanCommandMap[commandType];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;

    return ElevatedButton(
      onPressed: !isConnected
          ? null
          : () {
              ref
                  .read(tcpClientProvider.notifier)
                  .writeToServer(setCommand(commandType, parameter));

              ref.read(lastCommandProvider.notifier).state = commandType;
            },
      child: Text(labelName ?? 'label problem'),
    );
  }
}
