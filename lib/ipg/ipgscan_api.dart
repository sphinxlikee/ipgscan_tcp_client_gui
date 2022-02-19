/// IPG Photonics Corporation
///
/// IPGScan TCP/IP API Commands
///
/// This section describes the TCP/IP API commands for controlling IPGScan externally.
/// The commands are ASCII based strings that are sent through a TCP/IP connection to IPGScan,
/// so the software can respond accordingly.
///
/// All commands should be followed by a carriage return (ASCII #13) and a line feed (ASCII #10).
/// ```dart
/// Example: JobOpen MyJob<CR><LF>
/// ```
/// Prior to sending any commands a connection between the computer running IPGScan and the device
/// trying to control it, must exist. In this case, IPGScan will behave as a Server while the external
/// device will be the Client requesting a connection to IPGScan.
///
/// To define the IP Address and Port Number in which the IPGScan server engine will be listening to incoming
/// connections follow the steps below:
///
/// 1. Open IPGScan
/// 2. Click on View -> Options
/// 3. On the tree to the left, click on Settings
/// 4. Scroll down to TCP/IP
/// 5. Select the Encoding type for the ASCII characters
/// 6. Select the IP Address (if more than one interface is installed in the computer) and Command Port number
/// for the Server engine.
/// 7. Restart IPGScan
///
///
/// ```dart
/// ## NOTE ##
/// ```
/// When a job is run using TCP commands, a message will appear in IPGScan showing remote session in progress:
///
/// ```dart
/// 'Remote Session In Progress'
///        STOP
/// 'Jobs in Session'
/// ```
///

/// `[IPGScanRemoteAPI]`'s `[JobOpen]` command
///
/// ```dart
/// Parameters: '$fileName'
/// Example: 'JobOpen MyJob\r\n', // MyJob is fileName
/// Description: 'Opens a job file in the IPGScan Jobs folder. Filename should not have the "wjb" extension.',
/// Troubleshooting: 'Job does not exist or cannot be opened. Check that spelling and case is correct. Weird symbols in job names may also cause this error.',
/// Error: 'Error: $fileName not found',
/// ```
///

List<String> errorList = [
  'Error: $parameterFileName not found', // JobOpen
  'Error: ScanController not connected', // JobStart
  'Error: Weld in progress', // JobStart
  'Error: $parameterFileName not opened', // JobStart
  'Error: No running Job found', // JobStart/Abort
  'Error: $parameterFileName not closed', // JobClose
  'Error: IPGScan directory not found', // JobList
  'Error: No TCP Connection', // ConnectionGetStatus
  ' ', // ScannerGetStatus - It should has one space in the string
  'Error: ScanController not connected', // ScannerGetEnableBit
  'Error: Not Connected', // ScannerGetStatus
];

enum ipgScanCommandList {
  noCommand,
  jobOpen,
  jobStart,
  jobStop,
  jobAbort,
  jobClose,
  jobList,
  jobOpenedList,
  scannerGetStatus,
  jobGetStatus,
  jobExport,
  getEncoding,
  scannerGetStartBit,
  scannerGetEnableBit,
  connectionGetStatus,
  scannerGetPortA,
  scannerLock,
  scannerUnlock,
  scannerInit,
  scannerParkAt,
  scannerGetWorkspacePosition,
  scannerGetList,
  scannerGetStatusList,
  scannerGetConnectionStatus,
  scannerGuideOff,
  systemSetVariable,
  systemGetVariable,
  jobGetStatus2,
  jobLastRunSuccessful,
  scannerGetMessageStatus,
  systemGetVersion,
  dwsResetRunningMax,
  dwsGetRunningMax,
  dwsGetInstantValue,
  systemResetAllAlarms,
  laserGetStatusCode,
  laserGetStatusMessage,
  help,
  helpCommand,
}

const Map<ipgScanCommandList, String> ipgScanCommandMap = {
  ipgScanCommandList.noCommand: 'Initial connection state',
  ipgScanCommandList.jobOpen: 'Job Open',
  ipgScanCommandList.jobStart: 'Job Start',
  ipgScanCommandList.jobStop: 'Job Stop',
  ipgScanCommandList.jobAbort: 'Job Abort',
  ipgScanCommandList.jobClose: 'Job Close',
  ipgScanCommandList.jobList: 'Job List',
  ipgScanCommandList.jobOpenedList: 'Job Opened List',
  ipgScanCommandList.scannerGetStatus: 'Scanner Get Status',
  ipgScanCommandList.jobGetStatus: 'Job Get Status',
  ipgScanCommandList.jobExport: 'Job Export',
  ipgScanCommandList.getEncoding: 'Get Encoding',
  ipgScanCommandList.scannerGetStartBit: 'Scanner Get Start Bit',
  ipgScanCommandList.scannerGetEnableBit: 'Scanner Get Enable Bit',
  ipgScanCommandList.connectionGetStatus: 'Connection Get Status',
  ipgScanCommandList.scannerGetPortA: 'Scanner Get Port A',
  ipgScanCommandList.scannerLock: 'Scanner Lock',
  ipgScanCommandList.scannerUnlock: 'Scanner Unlock',
  ipgScanCommandList.scannerInit: 'Scanner Init',
  ipgScanCommandList.scannerParkAt: 'Scanner Park At',
  ipgScanCommandList.scannerGetWorkspacePosition:
      'Scanner Get Workspace Position',
  ipgScanCommandList.scannerGetList: 'Scanner Get List',
  ipgScanCommandList.scannerGetStatusList: 'Scanner Get Status List',
  ipgScanCommandList.scannerGetConnectionStatus:
      'Scanner Get Connection Status',
  ipgScanCommandList.scannerGuideOff: 'Scanner Guide Off',
  ipgScanCommandList.systemSetVariable: 'System Set Variable',
  ipgScanCommandList.systemGetVariable: 'System Get Variable',
  ipgScanCommandList.jobGetStatus2:
      'Job Get Status2', //currently executing group&object name
  ipgScanCommandList.jobLastRunSuccessful: 'Job Last Run Successful',
  ipgScanCommandList.scannerGetMessageStatus: 'Scanner Get Message Status',
  ipgScanCommandList.systemGetVersion: 'System Get Version',
  ipgScanCommandList.dwsResetRunningMax: 'DWS Reset Running Max',
  ipgScanCommandList.dwsGetRunningMax: 'DWS Get Running Max',
  ipgScanCommandList.dwsGetInstantValue: 'DWS Get Instant Value',
  ipgScanCommandList.systemResetAllAlarms: 'System Reset All Alarms',
  ipgScanCommandList.laserGetStatusCode: 'Laser Get Status Code',
  ipgScanCommandList.laserGetStatusMessage: 'Laser Get Status Message',
  ipgScanCommandList.help: 'Commands list',
  ipgScanCommandList.helpCommand: 'Command help',
};

// parameters
String parameterFileName =
    'deneme'; // it will come from ListView - inside of IPGScan Jobs folder
String parameterNone = '';

String setCommand(ipgScanCommandList command, String parameter) {
  if (command == ipgScanCommandList.jobOpen ||
      command == ipgScanCommandList.jobStart ||
      command == ipgScanCommandList.jobStop ||
      command == ipgScanCommandList.jobAbort ||
      command == ipgScanCommandList.jobClose ||
      command == ipgScanCommandList.scannerLock ||
      command == ipgScanCommandList.scannerUnlock ||
      command == ipgScanCommandList.scannerParkAt ||
      command == ipgScanCommandList.scannerGetConnectionStatus ||
      command == ipgScanCommandList.systemSetVariable ||
      command == ipgScanCommandList.systemGetVariable) {
    return '${ipgScanCommandMap[command]?.replaceAll(' ', '')} $parameter\r\n';
  } else if (command == ipgScanCommandList.helpCommand) {
    return 'Help ${parameter.replaceAll(' ', '')}\r\n';
  } else {
    return '${ipgScanCommandMap[command]?.replaceAll(' ', '')}\r\n';
  }
}
