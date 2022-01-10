import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/widget/scanners_list_view.dart';
import 'widget/job_list_view.dart';
import 'widget/command_button_grid.dart';
import 'widget/data_exchange_list_view.dart';
import 'widget/connection_info_indicators.dart';
import 'widget/connection_control.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'widget/reusables.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

  doWhenWindowReady(() {
    const initialSize = Size(1080, 768);
    appWindow.minSize = const Size(100, 70);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
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
          headline1: TextStyle(fontSize: 18.0),
          headline2: TextStyle(fontSize: 12.0),
          headline3: TextStyle(fontSize: 12.0),
          headline4: TextStyle(fontSize: 12.0),
          headline5: TextStyle(fontSize: 12.0),
          headline6: TextStyle(fontSize: 18.0),
          subtitle1: TextStyle(fontSize: 11.0),
          subtitle2: TextStyle(fontSize: 10.0),
          bodyText1: TextStyle(fontSize: 6.0),
          bodyText2: TextStyle(fontSize: 11.0),
          button: TextStyle(fontSize: 11.0),
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
                        const InfoLabel(text: 'Computer name:'),
                        const InfoLabel(text: 'IPGScan status:'),
                        const InfoLabel(text: 'Connected scanner:'),
                        const InfoLabel(text: 'Encoding:'),
                        const InfoLabel(text: 'Start bit:'),
                        const InfoLabel(text: 'Enable bit:'),
                        const InfoLabel(text: 'Port A:'),
                        const GalvoPosition(
                          enableState: true,
                        ),
                        const GalvoPosition(
                          enableState: false,
                        ),
                        const InfoLabel(text: 'Scanner connection status:'),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            InfoLabel(text: 'Set variable '),
                            VariableList(),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            InfoLabel(text: 'Get variable '),
                            VariableList(),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 2, color: Colors.black26),
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                TitleWidget(text: 'Command Buttons'),
                Expanded(child: CommandButtonGrid()),
              ],
            ),
          ),
          Container(width: 2, color: Colors.black26),
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                TitleWidget(text: 'Job list in C:\\IPGP\\IPGScan\\Jobs'),
                Expanded(child: JobListView()),
                TitleWidget(text: 'Scanner list'),
                Expanded(child: ScannersListView()),
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
