import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test1/ViewModel/count_viewmodel.dart';
import 'package:provider/provider.dart';

/*
class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Page: Provider, Undo/Redo Test"),
      ),
      body: Center(
        child: Text("...")
      ),
    );
  }
}*/

class ThirdPage extends StatelessWidget{
  ThirdPage({super.key});
  CountViewModel _countViewModel = CountViewModel();
  ListView lv = ListView();

  @override
  Widget build(BuildContext context){
    lv = _countList(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Page: Provider, Undo/Redo Test"),
      ),
      body: Center(
        child: Row(
          children: [
            ChangeNotifierProvider(
              create: (context) => CountViewModel(),
              child: lv,
            ),
            Text((_countViewModel.count).toString()),
          ],
        )
          //child: Text("...")
        //child: _countList(context),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(width:30),
          FloatingActionButton(
          onPressed: _countViewModel.incrementCount,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _countViewModel.decrementCount,
            tooltip: 'Dncrement',
            child: const Icon(Icons.remove),
          ),
        ],
      )
    );
  }

  ListView _countList(BuildContext context){
    return ListView.builder(
      itemCount: _countViewModel.count,
      itemBuilder: (context, index){
        return Container(
          height: 20,
          child: Text(_countViewModel.textList[index]),
        );
      },
    );
  }
}
