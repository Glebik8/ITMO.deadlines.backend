import 'package:flutter/cupertino.dart';
import 'package:itmo_time/Model/model.dart';
import 'package:rxdart/rxdart.dart';

class RxListUpdate {
  List<Note> _noteClass;

  List<Note> get noteClass => _noteClass;

  RxListUpdate(this._noteClass){
    this.onListUpdater = BehaviorSubject<List<Note>>.seeded(noteClass);
  }
  BehaviorSubject<List<Note>> onListUpdater;

  Future onListUpdate(List<Note> newList) async {
    _noteClass = newList;
    onListUpdater.add(_noteClass);
  }
}