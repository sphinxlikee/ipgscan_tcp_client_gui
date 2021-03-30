import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/tcp_client.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
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
  TCPClient tcpClient = TCPClient(hostAddress: '127.0.0.1', hostPort: 64123);

  @override
  void dispose() async {
    super.dispose();
    await tcpClient.socket.flush();
    await tcpClient.socket.close();
  }

  Future<void> createConnection() async {
    if (!tcpClient.isConnected) {
      await Socket.connect(tcpClient.hostAddress, tcpClient.hostPort).then((value) {
        tcpClient.socket = value;
        setState(() {
          tcpClient.isConnected = true;
          tcpClient.isDone = false;
        });
        print(
          'Connected to ${tcpClient.socket.address}:${tcpClient.socket.port} from ${tcpClient.socket.remoteAddress}:${tcpClient.socket.remotePort}.',
        );
      });

      tcpClient.socket.listen(
        (event) {
          var received = String.fromCharCodes(event);
          print(received);

          if (!tcpClient.hasReceivedData) {
            setState(() {
              tcpClient.hasReceivedData = true;
              tcpClient.isDone = false;
            });
          }
        },
      )..onDone(
          () {
            setState(() {
              tcpClient.isDone = true;
              tcpClient.isConnected = false;
              tcpClient.hasReceivedData = false;
              tcpClient.hasSentData = false;
            });
            print('socket is closed: ${tcpClient.isDone}');
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
              onPressed: !tcpClient.isConnected
                  ? null
                  : () {
                      tcpClient.socket.write('DateTime: ${DateTime.now()}\r\n');
                      setState(() {
                        tcpClient.hasSentData = true;
                      });
                    },
              child: Text('Send DateTime.now()'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => print('socket is closed: ${tcpClient.isDone}'),
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
                    color: tcpClient.hasReceivedData ? Colors.green : Colors.red,
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
                    color: tcpClient.hasSentData ? Colors.green : Colors.red,
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
                    color: tcpClient.isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: tcpClient.isConnected ? null : createConnection,
        tooltip: tcpClient.isConnected ? 'Connected' : 'Connect',
        child: tcpClient.isConnected ? Icon(Icons.connect_without_contact_outlined) : Icon(Icons.touch_app_sharp),
      ),
    );
  }
}
