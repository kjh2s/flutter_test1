import 'package:flutter/material.dart';

//Provider는 ViewModel 개념에 포함되나?
class CountViewModel with ChangeNotifier{
  int _count = 3;
  List<String> _textList = <String>["first", "second", "third", "fourth", "fifth", "sixth", "seventh"];

  int get count{
    return _count;
  }
  set count(int c){
    if(c<=7 && c>=1){
      _count = c;
    }
  }

  get textList{
    return _textList;
  }

  void incrementCount(){
    if(_count<7){
      _count = _count + 1;
      notifyListeners();
    }
  }

  void decrementCount(){
    if(_count>1){
      _count = _count - 1;
      notifyListeners();
    }
  }
}
