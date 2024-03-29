import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ipg/ipgscan_api.dart';
import 'widget/scanners_list_view.dart';
import 'widget/job_list_view.dart';
import 'widget/command_button_grid.dart';
import 'widget/data_exchange_list_view.dart';
import 'widget/connection_info_indicators.dart';
import 'widget/connection_control.dart';
import 'widget/reusables.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.orange,
        fontFamily: 'Verdana',
        scrollbarTheme: const ScrollbarThemeData(
          // it is neccessary to use for automatic scrolling to bottom
          mainAxisMargin: 0.0,
          crossAxisMargin: 0.0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 18.0),
          displayMedium: TextStyle(fontSize: 12.0),
          displaySmall: TextStyle(fontSize: 12.0),
          headlineMedium: TextStyle(fontSize: 12.0),
          headlineSmall: TextStyle(fontSize: 12.0),
          titleLarge: TextStyle(fontSize: 18.0),
          titleMedium: TextStyle(fontSize: 11.0),
          titleSmall: TextStyle(fontSize: 10.0),
          bodyLarge: TextStyle(fontSize: 6.0),
          bodyMedium: TextStyle(fontSize: 11.0),
          labelLarge: TextStyle(fontSize: 11.0),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const TitleWidget(text: 'Connection Control'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        IPAddressTextField(),
                        PortTextField(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        DataSentIndicator(),
                        DataReceivedIndicator(),
                        ConnectionIndicator(),
                      ],
                    ),
                  ],
                ),
                const ConnectButton(),
                const TitleWidget(text: 'General Info & Set'),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        InfoLabel('Computer name', IPGScanCommandList.connectionGetStatus),
                        InfoLabel('Connected scanner', IPGScanCommandList.scannerGetStatus),
                        InfoLabel('IPGScan status', IPGScanCommandList.jobGetStatus),
                        InfoLabel('Encoding', IPGScanCommandList.getEncoding),
                        InfoLabel('Start bit', IPGScanCommandList.scannerGetStartBit),
                        InfoLabel('Enable bit', IPGScanCommandList.scannerGetEnableBit),
                        InfoLabel('Port A', IPGScanCommandList.scannerGetPortA),
                        InfoLabel('Scanner connection status', IPGScanCommandList.scannerGetConnectionStatus),
                        InfoLabel('Last job status', IPGScanCommandList.jobLastRunSuccessful),
                        const BeamPositionSet(),
                        const BeamPositionGet(),
                        const SetVariableWidget(),
                        const GetVariableWidget(),
                        Row(
                          children: [
                            InfoLabel('Job Start -guide', IPGScanCommandList.jobStart),
                            const JobStartGuideCheckBox(),
                          ],
                        ),
                        Row(
                          children: [
                            InfoLabel('Job Start -savefile', IPGScanCommandList.jobStart),
                            const JobStartSavefileCheckBox(),
                          ],
                        ),
                        Row(
                          children: [
                            InfoLabel('Job Start -groupName', IPGScanCommandList.jobStart),
                            const JobStartGroupName(),
                          ],
                        ),
                        const CommandListWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(color: Colors.black38, thickness: 1, width: 4),
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                TitleWidget(text: 'Command Buttons'),
                Expanded(child: CommandButtonGrid()),
              ],
            ),
          ),
          const VerticalDivider(color: Colors.black38, thickness: 1, width: 4),
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                TitleWidget(text: 'Job list in C:\\IPGP\\IPGScan\\Jobs'),
                Expanded(child: JobListView()),
                TitleWidget(text: 'Scanner list'),
                Expanded(child: ScannerListView()),
                TitleWidget(text: 'Data communication'),
                DataExchangeScrollView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
