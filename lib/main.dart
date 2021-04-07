import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
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
        onPressed: tcpClient.isConnected
            ? null
            : () async {
                await tcpClient.createConnection(tcpClient);
                setState(() {});
              },
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
                tcpClient.dataSent = true;
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
          color: tcpClient.dataSent ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: tcpClient.dataSent ? Text('Sent') : Text('Not sent'),
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
          color: tcpClient.dataReceived ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: tcpClient.dataReceived ? Text('Received') : Text('Not received'),
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
