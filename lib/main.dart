import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
//import 'package:libserialport/libserialport.dart';
import 'db_helper.dart';
import 'model_stock.dart';
import 'second_page.dart';
import 'home_page.dart';

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
        //fontFamily: 'Sans-serif'
        fontFamily: 'NanumGothic',
      ),
      home: const MyHomePage(title: 'First Page...'),
      //home: const SecondPage(),
    );
  }
}





