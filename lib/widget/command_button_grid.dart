import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/reusables.dart';
import '../ipg/ipgscan_api.dart';
import '../provider/job_list_provider.dart';
import '../provider/scanner_list_provider.dart';

class CommandButtonGrid extends ConsumerWidget {
  const CommandButtonGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJobIndex = ref.watch(selectedJobIndexProvider);
    final jobListWatcher = ref.watch(jobListProvider);
    final selectedScannerIndex = ref.watch(selectedScannerIndexProvider);
    final scannerListWatcher = ref.watch(scannerListProvider);

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      childAspectRatio: 4.0,
      children: [
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobOpen,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobStart,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobStop,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobAbort,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobClose,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
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
          parameter: scannerListWatcher.scannerList.isEmpty
              ? 'not selected'
              : scannerListWatcher.scannerList[selectedScannerIndex],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerUnlock,
          parameter: scannerListWatcher.scannerList.isEmpty
              ? 'not selected'
              : scannerListWatcher.scannerList[selectedScannerIndex],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerInit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          /// update parameter
          /// parameter: galvo position to set to
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
          /// update parameter
          /// parameter: scanner name
          commandType: ipgScanCommandList.scannerGetConnectionStatus,
          parameter: scannerListWatcher.scannerList.isEmpty
              ? 'not selected'
              : scannerListWatcher.scannerList[selectedScannerIndex],
        ),
        IPGScanJobCommandButton(
          /// update parameter
          /// parameter: check it
          commandType: ipgScanCommandList.systemSetVariable,
          parameter: '$parameterVariableNumber $parameterVariableValue',
        ),
        IPGScanJobCommandButton(
          /// update parameter
          /// parameter: check it
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
