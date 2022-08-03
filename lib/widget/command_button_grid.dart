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
          labelName: IPGScanCommandList.jobOpen.commandLabel,
          commandType: IPGScanCommandList.jobOpen,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobStart.commandLabel,
          commandType: IPGScanCommandList.jobStart,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : '${jobListWatcher.jobList[selectedJobIndex]}$jobStartGuideOption$jobStartSavefileOption$jobStartGroupOption',
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobStop.commandLabel,
          commandType: IPGScanCommandList.jobStop,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobAbort.commandLabel,
          commandType: IPGScanCommandList.jobAbort,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobClose.commandLabel,
          commandType: IPGScanCommandList.jobClose,
          parameter: jobListWatcher.jobList.isEmpty
              ? 'not selected'
              : jobListWatcher.jobList[selectedJobIndex],
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobList.commandLabel,
          commandType: IPGScanCommandList.jobList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobOpenedList.commandLabel,
          commandType: IPGScanCommandList.jobOpenedList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetStatus.commandLabel,
          commandType: IPGScanCommandList.scannerGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobGetStatus.commandLabel,
          commandType: IPGScanCommandList.jobGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobExport.commandLabel,
          commandType: IPGScanCommandList.jobExport,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.getEncoding.commandLabel,
          commandType: IPGScanCommandList.getEncoding,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetStartBit.commandLabel,
          commandType: IPGScanCommandList.scannerGetStartBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetEnableBit.commandLabel,
          commandType: IPGScanCommandList.scannerGetEnableBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.connectionGetStatus.commandLabel,
          commandType: IPGScanCommandList.connectionGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetPortA.commandLabel,
          commandType: IPGScanCommandList.scannerGetPortA,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerLock.commandLabel,
          commandType: IPGScanCommandList.scannerLock,
          parameter: scannerListWatcher.scannerList.isEmpty
              ? 'not selected'
              : scannerListWatcher.scannerList[selectedScannerIndex],
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerUnlock.commandLabel,
          commandType: IPGScanCommandList.scannerUnlock,
          parameter: scannerListWatcher.scannerList.isEmpty
              ? 'not selected'
              : scannerListWatcher.scannerList[selectedScannerIndex],
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerInit.commandLabel,
          commandType: IPGScanCommandList.scannerInit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerParkAt.commandLabel,
          commandType: IPGScanCommandList.scannerParkAt,
          parameter: beamPositionSet,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetWorkspacePosition.commandLabel,
          commandType: IPGScanCommandList.scannerGetWorkspacePosition,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetList.commandLabel,
          commandType: IPGScanCommandList.scannerGetList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetStatusList.commandLabel,
          commandType: IPGScanCommandList.scannerGetStatusList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetConnectionStatus.commandLabel,
          commandType: IPGScanCommandList.scannerGetConnectionStatus,
          parameter: scannerListWatcher.scannerList.isEmpty
              ? 'not selected'
              : scannerListWatcher.scannerList[selectedScannerIndex],
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGuideOff.commandLabel,
          commandType: IPGScanCommandList.scannerGuideOff,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.systemSetVariable.commandLabel,
          commandType: IPGScanCommandList.systemSetVariable,
          parameter: '$setVariable $setVariableValue',
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.systemGetVariable.commandLabel,
          commandType: IPGScanCommandList.systemGetVariable,
          parameter: '$getVariable',
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobGetStatus2.commandLabel,
          commandType: IPGScanCommandList.jobGetStatus2,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.jobLastRunSuccessful.commandLabel,
          commandType: IPGScanCommandList.jobLastRunSuccessful,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.scannerGetMessageStatus.commandLabel,
          commandType: IPGScanCommandList.scannerGetMessageStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.systemGetVersion.commandLabel,
          commandType: IPGScanCommandList.systemGetVersion,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.dwsResetRunningMax.commandLabel,
          commandType: IPGScanCommandList.dwsResetRunningMax,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.dwsGetRunningMax.commandLabel,
          commandType: IPGScanCommandList.dwsGetRunningMax,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.dwsGetInstantValue.commandLabel,
          commandType: IPGScanCommandList.dwsGetInstantValue,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.systemResetAllAlarms.commandLabel,
          commandType: IPGScanCommandList.systemResetAllAlarms,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.laserGetStatusCode.commandLabel,
          commandType: IPGScanCommandList.laserGetStatusCode,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.laserGetStatusMessage.commandLabel,
          commandType: IPGScanCommandList.laserGetStatusMessage,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.help.commandLabel,
          commandType: IPGScanCommandList.help,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          labelName: IPGScanCommandList.helpCommand.commandLabel,
          commandType: IPGScanCommandList.helpCommand,
          parameter: helpSpecialCommand,
        ),
      ],
    );
  }
}
