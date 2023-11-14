import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
//import 'package:libserialport/libserialport.dart';
import 'db_helper.dart';
import 'model_stock.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  String _str_dblist = "";
  DBHelper _dbHelper = DBHelper();
  final _tickerTextCtrl = TextEditingController();
  final _priceTextCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dbHelper = DBHelper();
  }

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

  void _InsertDB_custom() async{
    Stock st1 = Stock('AAPL', 180);
    Stock st2 = Stock('MSFT', 330);
    Stock st3 = Stock('V', 240);

    await _dbHelper.insertStock(st1);
    await _dbHelper.insertStock(st2);
    await _dbHelper.insertStock(st3);
  }

  void _InsertDB() async{
    Stock st1 = Stock(_tickerTextCtrl.text, double.parse(_priceTextCtrl.text));

    await _dbHelper.insertStock(st1);
    showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        content: Text("insert: " + st1.ticker),
      );
    });
  }

  void _DeleteDB() async{
    String str_pk = _tickerTextCtrl.text;

    int deleted_cnt = await _dbHelper.deleteStock(str_pk);

    if(deleted_cnt != 0){
      showDialog(context: context, builder: (BuildContext ctx){
        return AlertDialog(
          content: Text("deleted: " + str_pk),
        );
      });
    }
  }

  void _DeleteTable() async{
    int deleted_cnt = await _dbHelper.deleteTableStock();

    if(deleted_cnt != 0){
      showDialog(context: context, builder: (BuildContext ctx){
        return AlertDialog(
          content: Text("Deleted Table"),
        );
      });
    }
  }

  void _ReadDB() async{
    Stock st1 = await _dbHelper.readStock(_tickerTextCtrl.text);
    String str_dblist = "ticker  |   price  \n";
    str_dblist += st1.ticker;
    str_dblist += "  | ";
    str_dblist += st1.price.toString();
    str_dblist += "\n";
    setState(() {
      _str_dblist = str_dblist;
    });
  }

  void _UpdateDB() async{
    Stock src = await _dbHelper.readStock(_tickerTextCtrl.text);
    Stock dst = Stock(_tickerTextCtrl.text, double.parse(_priceTextCtrl.text));
    _dbHelper.updateStock(src, dst);

    showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        content: Text("update: " + dst.ticker),
      );
    });

    String str_dblist = "ticker  |   price  \n";
    str_dblist += dst.ticker;
    str_dblist += "  | ";
    str_dblist += dst.price.toString();
    str_dblist += "\n";
    setState(() {
      _str_dblist = str_dblist;
    });
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("PK(ticker):  "),
                        TextField(
                          controller: _tickerTextCtrl,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("price:  "),
                        TextField(
                          controller: _priceTextCtrl,
                        ),
                      ],
                    )
                  ],
                )
            ),
            Column(
              children: [
                OutlinedButton(onPressed: _ReadAllDB, child: Text("read all db")),
                OutlinedButton(onPressed: _ClearText, child: Text("clear text")),
                OutlinedButton(onPressed: _InsertDB_custom, child: Text("Insert DB custom")),
                OutlinedButton(onPressed: _ReadDB, child: Text("read 'ticker' item")),
                OutlinedButton(onPressed: _InsertDB, child: Text("create item")),
                OutlinedButton(onPressed: _UpdateDB, child: Text("update item")),
                OutlinedButton(onPressed: _DeleteDB, child: Text("delete item")),
                OutlinedButton(onPressed: _DeleteTable, child: Text("delete table")),
              ],
            ),
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