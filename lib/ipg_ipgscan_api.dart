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
class IPGScanRemoteAPI {
  final String commandInit;
  final String parameters;
  final String returns;
  final String error;

  String fullCommand;

  IPGScanRemoteAPI({
    this.commandInit,
    this.parameters,
    this.returns,
    this.error,
  }) : fullCommand = '$commandInit $parameters\r\n';
}

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
var jobOpen = IPGScanRemoteAPI(
  commandInit: 'JobOpen',
  parameters: fileName, // it will get filename from jobs folder(ex: choose the job from list view widget )
  returns: '$fileName opened',
  error: 'Error: $fileName not found',
);

enum IPGScanRemoteAPICommands {
  JobOpen,
  JobStart,
  JobStop,
  JobAbort,
  JobClose,
  JobList,
  ConnectionGetStatus,
  ScannerGetStatus,
  JobGetStatus,
  GetEncoding,
  ScannerGetStartBit,
  ScannerGetEnableBit,
  ScannerGetPortA,
  ScannerLock,
  ScannerUnlock,
  ScannerInit,
  ScannerParkAt,
  ScannerGetWorkspacePosition,
  ScannerGetList,
  ScannerGetConnectionStatus,
  SystemSetVariable,
  JobGetStatus2,
  JobLastRunSuccessful,
  Help, // list of commands
  HelpCommands, //command help
}

// parameters
/// it will come from ListView - inside of IPGScan Jobs folder
String fileName;

/// none parameter
String none = '';
String scannerName;
String galvoPositionSet; // ScannerParkAt 5 5 5
String variableNumber; // SystemSetVariable 1 IPG //// SystemGetVariable 1
String command;
