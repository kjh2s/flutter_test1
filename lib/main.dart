import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
//import 'package:libserialport/libserialport.dart';
import 'db_helper.dart';
import 'model_stock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'title',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '타이틀 한글 테스트 상태 전달...'),
    );
  }
}

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
          )
        ],
      )
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  String _str_dblist = "";
  DBHelper _dbHelper = DBHelper();

  void _ReadAllDB() async{

    List<Stock> stock_list = await _dbHelper.all_stocks();


    String str_dblist = "ticker  |   price  \n";
    for(Stock stck in stock_list){
      str_dblist += stck.ticker;
      str_dblist += "  | ";
      str_dblist += stck.price.toString();
      str_dblist += "\n";
    }
    setState(() {
      _str_dblist = str_dblist;
    });
  }

  void _ClearText(){
    setState(() {
      _str_dblist = "clear";
    });
  }

  void _InsertDB() async{
    Stock st1 = Stock('AAPL', 180);
    Stock st2 = Stock('MSFT', 330);
    Stock st3 = Stock('V', 240);

    await DBHelper().insertStock(st1);
    await DBHelper().insertStock(st2);
    await DBHelper().insertStock(st3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Page"),
        ),
      body: Center(
        child: Row(
          children: [
            Container(
              color: Colors.blue.withOpacity(0.3),
              width: MediaQuery.of(context).size.width * 0.4,
              height: 500,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: Text(
                    'CRUD'
                ),
              ),
            ),
            Spacer(),
            OutlinedButton(onPressed: _ReadAllDB, child: Text("read all db")),
            OutlinedButton(onPressed: _ClearText, child: Text("clear text")),
            OutlinedButton(onPressed: _InsertDB, child: Text("Insert DB")),
            Container(
              color: Colors.green.withOpacity(0.3),
              width: MediaQuery.of(context).size.width * 0.4,
              height: 500,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: Text('$_str_dblist')
              ),
            ),
          ],
        ),
      ),
    );
  }
}