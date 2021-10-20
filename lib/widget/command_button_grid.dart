// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tcp_client/widget/command_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ipg/ipgscan_api.dart';
import '../provider/job_list_provider.dart';

class CommandButtonGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final selectedJobIndex = watch(selectedJobIndexProvider);
    final jobListWatcher = watch(jobListProvider);

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(8.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      childAspectRatio: 8.0,
      children: [
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobOpen,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex.state],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobStart,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex.state],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobStop,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex.state],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobAbort,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex.state],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobClose,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex.state],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.connectionGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.getEncoding,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetStartBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetEnableBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetPortA,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerLock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerUnlock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerInit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerParkAt,
          parameter: parameterGalvoPositionSet,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetWorkspacePosition,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetConnectionStatus,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.systemSetVariable,
          parameter: '$parameterVariableNumber $parameterVariableValue',
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.systemGetVariable,
          parameter: parameterVariableNumber,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobGetStatus2,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobLastRunSuccessful,
          parameter: parameterNone,
        ),
      ],
    );
  }
}
