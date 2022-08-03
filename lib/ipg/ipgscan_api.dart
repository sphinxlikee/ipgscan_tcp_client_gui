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

enum IPGScanCommandList {
  noCommand(commandLabel: 'Initial connection state', command: ' '),
  jobOpen(commandLabel: 'Job Open', command: 'JobOpen'),
  jobStart(commandLabel: 'Job Start', command: 'JobStart'),
  jobStop(commandLabel: 'Job Stop', command: 'JobStop'),
  jobAbort(commandLabel: 'Job Abort', command: 'JobAbort'),
  jobClose(commandLabel: 'Job Close', command: 'JobClose'),
  jobList(commandLabel: 'Job List', command: 'JobList'),
  jobOpenedList(commandLabel: 'Job Opened List', command: 'JobOpenedList'),
  scannerGetStatus(commandLabel: 'Scanner Get Status', command: 'ScannerGetStatus'),
  jobGetStatus(commandLabel: 'Job Get Status', command: 'JobGetStatus'),
  jobExport(commandLabel: 'Job Export', command: 'JobExport'),
  getEncoding(commandLabel: 'Get Encoding', command: 'GetEncoding'),
  scannerGetStartBit(commandLabel: 'Scanner Get Start Bit', command: 'ScannerGetStartBit'),
  scannerGetEnableBit(commandLabel: 'Scanner Get Enable Bit', command: 'ScannerGetEnableBit'),
  connectionGetStatus(commandLabel: 'Connection Get Status', command: 'ConnectionGetStatus'),
  scannerGetPortA(commandLabel: 'Scanner Get Port A', command: 'ScannerGetPortA'),
  scannerLock(commandLabel: 'Scanner Lock', command: 'ScannerLock'),
  scannerUnlock(commandLabel: 'Scanner Unlock', command: 'ScannerUnlock'),
  scannerInit(commandLabel: 'Scanner Init', command: 'ScannerInit'),
  scannerParkAt(commandLabel: 'Scanner Park At', command: 'ScannerParkAt'),
  scannerGetWorkspacePosition(commandLabel: 'Scanner Get Workspace Position', command: 'ScannerGetWorkspacePosition'),
  scannerGetList(commandLabel: 'Scanner Get List', command: 'ScannerGetList'),
  scannerGetStatusList(commandLabel: 'Scanner Get Status List', command: 'ScannerGetStatusList'),
  scannerGetConnectionStatus(commandLabel: 'Scanner Get Connection Status', command: 'ScannerGetConnectionStatus'),
  scannerGuideOff(commandLabel: 'Scanner Guide Off', command: 'ScannerGuideOff'),
  systemSetVariable(commandLabel: 'System Set Variable', command: 'SystemSetVariable'),
  systemGetVariable(commandLabel: 'System Get Variable', command: 'SystemGetVariable'),
  jobGetStatus2(commandLabel: 'Job Get Status2', command: 'JobGetStatus2'), //currently executing group&object name
  jobLastRunSuccessful(commandLabel: 'Job Last Run Successful', command: 'JobLastRunSuccessful'),
  scannerGetMessageStatus(commandLabel: 'Scanner Get Message Status', command: 'ScannerGetMessageStatus'),
  systemGetVersion(commandLabel: 'System Get Version', command: 'SystemGetVersion'),
  dwsResetRunningMax(commandLabel: 'DWS Reset Running Max', command: 'DWSResetRunningMax'),
  dwsGetRunningMax(commandLabel: 'DWS Get Running Max', command: 'DWSGetRunningMax'),
  dwsGetInstantValue(commandLabel: 'DWS Get Instant Value', command: 'DWSGetInstantValue'),
  systemResetAllAlarms(commandLabel: 'System Reset All Alarms', command: 'SystemResetAllAlarms'),
  laserGetStatusCode(commandLabel: 'Laser Get Status Code', command: 'LaserGetStatusCode'),
  laserGetStatusMessage(commandLabel: 'Laser Get Status Message', command: 'LaserGetStatusMessage'),
  help(commandLabel: 'Commands list', command: 'Help'),
  helpCommand(commandLabel: 'Commands help', command: 'Help');

  const IPGScanCommandList({
    required this.commandLabel,
    required this.command,
  });

  final String commandLabel;
  final String command;

  String get getCommandLabel => commandLabel;
  String get getCommand => command;
}

// parameters
String parameterFileName = 'deneme'; // it will come from ListView - inside of IPGScan Jobs folder
const String parameterNone = '';

String setCommand(IPGScanCommandList command, String parameter) {
  if (command == IPGScanCommandList.jobOpen ||
      command == IPGScanCommandList.jobStart ||
      command == IPGScanCommandList.jobStop ||
      command == IPGScanCommandList.jobAbort ||
      command == IPGScanCommandList.jobClose ||
      command == IPGScanCommandList.scannerLock ||
      command == IPGScanCommandList.scannerUnlock ||
      command == IPGScanCommandList.scannerParkAt ||
      command == IPGScanCommandList.scannerGetConnectionStatus ||
      command == IPGScanCommandList.systemSetVariable ||
      command == IPGScanCommandList.systemGetVariable) {
    return '${command.command} $parameter\r\n';
  } else if (command == IPGScanCommandList.helpCommand) {
    return 'Help ${parameter.replaceAll(' ', '')}\r\n';
  } else if (command == IPGScanCommandList.help) {
    return 'Help\r\n';
  } else {
    return '${command.command}\r\n';
  }
}
