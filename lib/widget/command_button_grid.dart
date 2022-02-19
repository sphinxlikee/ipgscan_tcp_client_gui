import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/reusables.dart';
import '../ipg/ipgscan_api.dart';
import '../provider/job_list_provider.dart';
import '../provider/scanner_list_provider.dart';
import '../provider/job_command_providers.dart';

class CommandButtonGrid extends ConsumerWidget {
  const CommandButtonGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJobIndex = ref.watch(selectedJobIndexProvider);
    final jobListWatcher = ref.watch(jobListProvider);
    final selectedScannerIndex = ref.watch(selectedScannerIndexProvider);
    final scannerListWatcher = ref.watch(scannerListProvider);
    final jobStartGuideOption = ref.watch(jobStartGuideOptionProvider);
    final jobStartSavefileOption = ref.watch(jobStartSavefileOptionProvider);
    final jobStartGroupOption = ref.watch(jobStartGroupOptionProvider);
    final beamPositionSet = ref.watch(beamPositionSetProvider);
    final setVariable = ref.watch(setVariableProvider);
    final setVariableValue = ref.watch(setVariableValueProvider);
    final getVariable = ref.watch(getVariableProvider);
    final helpSpecialCommand = ref.watch(helpSpecialCommandProvider);

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
              : '${jobListWatcher.jobList[selectedJobIndex]}$jobStartGuideOption$jobStartSavefileOption$jobStartGroupOption',
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
          commandType: ipgScanCommandList.jobOpenedList,
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
          commandType: ipgScanCommandList.jobExport,
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
          commandType: ipgScanCommandList.connectionGetStatus,
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
          commandType: ipgScanCommandList.scannerParkAt,
          parameter: beamPositionSet,
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
          commandType: ipgScanCommandList.scannerGetStatusList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetConnectionStatus,
          parameter: scannerListWatcher.scannerList.isEmpty
              ? 'not selected'
              : scannerListWatcher.scannerList[selectedScannerIndex],
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGuideOff,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.systemSetVariable,
          parameter: '$setVariable $setVariableValue',
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.systemGetVariable,
          parameter: '$getVariable',
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobGetStatus2,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.jobLastRunSuccessful,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.scannerGetMessageStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.systemGetVersion,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.dwsResetRunningMax,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.dwsGetRunningMax,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.dwsGetInstantValue,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.systemResetAllAlarms,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.laserGetStatusCode,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.laserGetStatusMessage,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.help,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: ipgScanCommandList.helpCommand,
          parameter: helpSpecialCommand,
        ),
      ],
    );
  }
}
