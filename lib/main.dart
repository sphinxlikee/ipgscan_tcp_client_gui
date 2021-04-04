import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tcp_client/tcp_client.dart';
import 'dart:developer' as developer;

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

String serverAddress = '127.0.0.1';
int serverPort = 64123;
TCPClient tcpClient = TCPClient(serverAddress: serverAddress, serverPort: serverPort);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> createConnection() async {
    if (!tcpClient.isConnected) {
      await Socket.connect(tcpClient.serverAddress, tcpClient.serverPort).then((value) {
        tcpClient.socket = value;
        setState(() {
          tcpClient.isConnected = true;
          tcpClient.isDone = false;
        });
        developer.log(
          'connected to ${tcpClient.socket.address}:${tcpClient.socket.port} from ${tcpClient.socket.remoteAddress}:${tcpClient.socket.remotePort}.',
        );
      });

      tcpClient.socket.listen(
        (event) {
          var received = String.fromCharCodes(event);
          developer.log('received: $received');

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
            developer.log('socket is closed: ${tcpClient.isDone}');
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TCPDataSendButton(),
          SizedBox(height: 10),
          TCPDataSendIndicator(),
          TCPDataReceiveIndicator(),
          TCPConnectionIndicator(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: tcpClient.isConnected ? null : createConnection,
        tooltip: tcpClient.isConnected ? 'Connected' : 'Connect',
        child: tcpClient.isConnected ? Icon(Icons.connect_without_contact_outlined) : Icon(Icons.touch_app_sharp),
      ),
    );
  }
}

class TCPDataSendButton extends StatefulWidget {
  @override
  _TCPDataSendButtonState createState() => _TCPDataSendButtonState();
}

class _TCPDataSendButtonState extends State<TCPDataSendButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !tcpClient.isConnected
          ? null
          : () {
              tcpClient.socket.write('DateTime: ${DateTime.now()}\r\n');
              setState(() {
                tcpClient.hasSentData = true;
              });
            },
      child: Text('Send DateTime.now()'),
    );
  }
}

class TCPDataSendIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tcpClient.hasSentData ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: tcpClient.hasSentData ? Text('Sent') : Text('Not sent'),
    );
  }
}

class TCPDataReceiveIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tcpClient.hasReceivedData ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: tcpClient.hasReceivedData ? Text('Received') : Text('Not received'),
    );
  }
}

class TCPConnectionIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tcpClient.isConnected ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Connection Status '),
      subtitle: tcpClient.isConnected ? Text('Connected') : Text('Disconnected'),
    );
  }
}
