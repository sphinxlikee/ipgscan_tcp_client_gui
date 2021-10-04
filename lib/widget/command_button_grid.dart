import 'package:flutter/material.dart';
import 'package:flutter_tcp_client/ipg/ipgscan_api.dart';
import 'package:flutter_tcp_client/widget/command_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/provider/tcp_provider.dart';

class CommandButtonGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final selectedJobIndex = watch(selectedJobIndexProvider);
    final jobListWatcher = watch(jobListProvider);

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      childAspectRatio: 8.0,
      children: [
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobOpen,
          parameter: jobListWatcher.jobList.length == 0
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex.state],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobStart,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobStop,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobAbort,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobClose,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ConnectionGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.GetEncoding,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerGetStartBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerGetEnableBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerGetPortA,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerLock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerUnlock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerInit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerParkAt,
          parameter: parameterGalvoPositionSet,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerGetWorkspacePosition,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerGetList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.ScannerGetConnectionStatus,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.SystemSetVariable,
          parameter: '$parameterVariableNumber $parameterVariableValue',
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.SystemGetVariable,
          parameter: parameterVariableNumber,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobGetStatus2,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.JobLastRunSuccessful,
          parameter: parameterNone,
        ),
      ],
    );
  }
}
