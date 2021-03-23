import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter-TCP/IP Client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Socket clientSocket;
  String hostAddress = '127.0.0.1';
  int port = 64123;
  bool isConnected = false, isDone = false, hasReceivedData = false, hasSentData = false;

  Future<void> createConnection() async {
    if (!isConnected) {
      await Socket.connect(hostAddress, port).then((value) {
        setState(() {
          isConnected = true;
          isDone = false;
        });
        print('Connected');
        print('address: ${value.address}');
        print('port: ${value.port}');
        print('server address: ${value.remoteAddress}');
        print('server port: ${value.remotePort}');
        clientSocket = value;
      });

      clientSocket.listen(
        (event) {
          var received = String.fromCharCodes(event);
          print(received);

          setState(() {
            hasReceivedData = true;
            isDone = false;
          });
        },
      )..onDone(
          () {
            setState(() {
              isDone = true;
              isConnected = false;
              hasReceivedData = false;
              hasSentData = false;
            });

            print('socket is closed: $isDone');
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: !isConnected
                  ? null
                  : () {
                      clientSocket.write('DateTime: ${DateTime.now()}\r\n');
                      setState(() {
                        hasSentData = true;
                      });
                    },
              child: Text('Send DateTime.now()'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => print('socket is closed: $isDone'),
              child: Text('Check status'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#Has received data '),
                ClipOval(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: hasReceivedData ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#Has sent data '),
                ClipOval(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: hasSentData ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#Connected '),
                ClipOval(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isConnected ? null : createConnection,
        tooltip: isConnected ? 'Connected' : 'Connect',
        child: isConnected ? Icon(Icons.connect_without_contact_outlined) : Icon(Icons.touch_app_sharp),
      ),
    );
  }
}
