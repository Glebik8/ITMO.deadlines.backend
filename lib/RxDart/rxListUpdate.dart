import 'package:flutter/cupertino.dart';
import 'package:itmo_time/Model/model.dart';
import 'package:rxdart/rxdart.dart';

class RxListUpdate {
  List<Widget> _noteClass;

  List<Widget> get noteClass => _noteClass;

  RxListUpdate(this._noteClass){
    this.onListUpdater = BehaviorSubject<List<Widget>>.seeded(noteClass);
  }
  BehaviorSubject<List<Widget>> onListUpdater;

  Future onListUpdate(List<Widget> newList) async {
    _noteClass = newList;
    onListUpdater.add(_noteClass);
  }
}