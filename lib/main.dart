import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

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
  List _availablePorts = SerialPort.availablePorts;
  SerialPort _serialPort = new SerialPort(SerialPort.availablePorts.first);
  String _connectButtonStr = "Connect";

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
    setState(() {
      if(!_serialPort.isOpen){
        _serialPort.openReadWrite();
      }
      if(_serialPort.isOpen)
        _connectButtonStr = "Connected";
      else
        _connectButtonStr = "Connect";
    });
  }

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
                '$_availablePorts'
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
            Row(
              children: <Widget>[
                Container(
                  color: Colors.green.withOpacity(0.3),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 100,
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.all(5.0),
                ),
                Spacer(),
                Container(
                  color: Colors.green.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 100,
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.all(5.0),
                )
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
        ],
      )
    );
  }
}
