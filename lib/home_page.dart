import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'second_page.dart';
import 'third_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> _portsList = SerialPort.availablePorts;
  SerialPort _serialPort = new SerialPort(SerialPort.availablePorts[0]);   //가능 포트가 없으면? null이 아니고 빈 List 반환됨.
  String _connectButtonStr = "Connect";
  String _disconnectButtonStr = "Disconnect";
  List<Uint8List> receivedData = [];
  String sendStr = "";
  String receivedStr = "";


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if(_counter>0)
        _counter--;
    });
  }

  void _serialConnect(){
    if(!_serialPort.isOpen){
      if(Platform.isWindows){
        _serialPort = new SerialPort(_portsList[0]);
      }
      else if(Platform.isLinux){
        String port_name = "";
        for(String str in _portsList){
          if(str.contains("USB")){
            port_name = str;
            break;
          }
        }
        _serialPort = new SerialPort(port_name);
      }
      _serialPort.openReadWrite();
      setState(() {
        _connectButtonStr = "Connected";
        _disconnectButtonStr = "Disconnect";
      });
      List<int> int_list_send = "l,,;".codeUnits;
      _serialPort.write(Uint8List.fromList(int_list_send));
      //_serialPort.write("l,,;");

      setState(() {
        sendStr = "l,,;";
      });

      receivedData.add(_serialPort.read(200,timeout: 3000));
      setState(() {
        //receivedStr = receivedData[receivedData.length-1].toString();
        receivedStr = new String.fromCharCodes(receivedData[receivedData.length-1]);
      });
    }
  }

  void _serialDisconnect(){
    if(_serialPort.isOpen){
      _serialPort.close();
      setState(() {
        _disconnectButtonStr = "Disconnected";
        _connectButtonStr = "Connect";
        sendStr = "";
        receivedStr = "";
      });
    }
  }

  /*Future<void> readSerialFuture() async{
    if(_serialPort != null){
      SerialPortReader reader = SerialPortReader(_serialPort);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          leading: Icon(Icons.account_balance),
        ),
        body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '텍스트 한글 테스트:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                      'aaa'
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 200,
                    height: 100,
                    child: Text(
                        '$_portsList'
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightGreenAccent,
                          width: 10,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.purple, Colors.white],
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.grey,
                              spreadRadius: 4.0,
                              blurRadius: 5.0,
                              blurStyle: BlurStyle.normal),
                        ]
                    ),
                  ),
                  OutlinedButton(onPressed: _serialConnect,
                      child: Text('$_connectButtonStr')),
                  OutlinedButton(onPressed: _serialDisconnect,
                      child: Text('$_disconnectButtonStr')),
                  Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green.withOpacity(0.3),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 500,
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          child: Text(
                              '$sendStr'
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        color: Colors.green.withOpacity(0.7),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 500,
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                              '$receivedStr'
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
        ),
        floatingActionButton: Row(
          children: [
            SizedBox(width: 30),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            SizedBox(width: 50),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Icon(Icons.arrow_forward),
            ),
            SizedBox(width: 30),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ThirdPage()),
                );
              },
              child: Text("Third"),
            ),
          ],
        )
    );
  }
}