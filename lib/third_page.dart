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
  Widget lv = ListView();

  @override
  Widget build(BuildContext context){
    lv = _countList(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Page: MVVM Test"),
      ),
      body: Center(
        child: Row(
          children: [
            SizedBox(width: 100),
            ChangeNotifierProvider(
              create: (context) => _countViewModel,  //여기서 CountViewModel()로 객체 생성하면 위에 필드 정의에서 생성된 객체랑 다른거니까 count 변해도 적용 안되었던 것.
              child: Consumer<CountViewModel>(
                builder: (context, provider, child){
                  return Text(provider.count.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      color: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple][provider.count - 1]
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 100),
            lv,
          ],
        )
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

  Widget _countList(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => _countViewModel,  //여기서 CountViewModel()로 객체 생성하면 위에 필드 정의에서 생성된 객체랑 다른거니까 count 변해도 적용 안되었던 것.
      child: Consumer<CountViewModel>(
        builder: (context, provider, child){
          return ListView.builder(
            itemCount: provider.count,
            itemBuilder: (context, index){
              return Container(
                  height: 30,
                  child: Text(provider.textList[index],
                  style: TextStyle(
                    fontSize: 10 + index * 4,
                    fontWeight: ((){
                      if(index < 4){
                        return FontWeight.normal;
                      }
                      else{
                        return FontWeight.bold;
                      }
                    })(),
                  ))
              );
            },
          );
        },
      ),
    );
  }
}
