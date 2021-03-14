import 'dart:io';
import 'dart:typed_data';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  var hostAddress = '127.0.0.1';
  var port = 64123;
  bool isConnected = false;
  bool isDone = false;
  bool hasData = false;
  var clientSocketStreamSub;

  void newPrint(var error) {
    print('cem error: $error');
  }

  createConnection() async {
    if (!isConnected) {
      await Socket.connect(hostAddress, port).then((value) {
        setState(() {
          isConnected = true;
        });
        print('Connected');
        clientSocket = value;
        isDone = false;
      });

      clientSocket.listen((event) {
        var received = String.fromCharCodes(event);
        print(received);

        setState(() {
          hasData = true;
          isDone = false;
        });
      })
        ..onDone(() {
          print('socket is done: $isDone');
          setState(() {
            isDone = true;
            isConnected = false;
            hasData = false;
          });
        });
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
              onPressed: !isConnected ? null : () => clientSocket.writeln('DateTime: ${DateTime.now()}'),
              child: Text('Send DateTime.now()'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => print('socket is done: $isDone'),
              child: Text('Check status'),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#Socket has data '),
                ClipOval(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: hasData ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
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
        // onPressed: isConnected ? null : createConnection,
        onPressed: createConnection,
        tooltip: isConnected ? 'Connected' : 'Connect',
        child: isConnected ? Icon(Icons.connect_without_contact_outlined) : Icon(Icons.touch_app_sharp),
      ),
    );
  }
}
