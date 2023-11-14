import 'package:flutter/material.dart';


class CountViewModel with ChangeNotifier{
  int _count = 3;
  List<String> _textList = <String>["first", "second", "third", "fourth", "fifth"];

  int get count{
    return _count;
  }
  set count(int c){
    if(c<=5 && c>=1){
      _count = c;
    }
  }

  get textList{
    return _textList;
  }

  void incrementCount(){
    if(_count<5){
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
