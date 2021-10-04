import 'package:flutter/material.dart';
import 'package:flutter_tcp_client/ipg/ipg_ipgscan_api.dart';
import 'package:flutter_tcp_client/widget/job_command_button.dart';

class ControlButtonGrid extends StatefulWidget {
  @override
  _ControlButtonGridState createState() => _ControlButtonGridState();
}

class _ControlButtonGridState extends State<ControlButtonGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      childAspectRatio: 8.0,
      children: [
        IPGScanJobCommandButton(
          commandType: commandEnums.JobOpen,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobStart,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobStop,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobAbort,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobClose,
          parameter: parameterFileName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ConnectionGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobGetStatus,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.GetEncoding,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetStartBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetEnableBit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetPortA,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerLock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerUnlock,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerInit,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerParkAt,
          parameter: parameterGalvoPositionSet,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetWorkspacePosition,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetList,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.ScannerGetConnectionStatus,
          parameter: parameterScannerName,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.SystemSetVariable,
          parameter: '$parameterVariableNumber $parameterVariableValue',
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.SystemGetVariable,
          parameter: parameterVariableNumber,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobGetStatus2,
          parameter: parameterNone,
        ),
        IPGScanJobCommandButton(
          commandType: commandEnums.JobLastRunSuccessful,
          parameter: parameterNone,
        ),
      ],
    );
  }
}
