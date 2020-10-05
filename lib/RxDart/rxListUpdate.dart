import 'package:flutter/cupertino.dart';
import 'package:itmo_time/Model/model.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';

class RxListUpdate {
  Map<String, List<Note>> _noteClass;

  Map<String, List<Note>> get noteClass => _noteClass;

  RxListUpdate(this._noteClass){
    this.onListUpdater = BehaviorSubject<Map<String, List<Note>>>.seeded(noteClass);
  }
  BehaviorSubject<Map<String, List<Note>>> onListUpdater;

  Future onListUpdate(Map<String, List<Note>> newList) async {
    _noteClass = model.sortMap(newList);
    onListUpdater.add(_noteClass);
  }
}