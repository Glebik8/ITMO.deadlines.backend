

import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itmo_time/RxDart/rxListUpdate.dart';
import 'package:intl/intl.dart';
import 'dart:math';


List<List<Note>> mainList = [];
Map<String, List<Note>> map = Map();

class Model{

  Color headColor = Color(0xFF8D93AB);
  Color bodyColor = Color(0xFF242732);
  Color cardStroke = Color(0xFF373B4D);
  Color cardColor = Color(0xFF2F3341);
  Color cardText = Color(0xFF525663);
  Color cardTextHead = Color(0xFFDBE6FF);
  Color timeTextColor = Color(0xFFDBE6FF);
  Color slideColorText = Color(0xFF969EB3);
  Color textFieldBack = Color(0xFF242732);
  Color textFieldStroke = Color(0xFF444D61);
  Color buttonColor = Color(0xFF376D8C);
  Color actionButton = Color(0xFF1A2139);
  Color slideActions = Color(0xFF323542);


  int globalKey = 0;

  void initGlobalKey() async{
    var box =  await Hive.openBox<int>('key');
    box.put('key', globalKey);
  }

  void incrementGlobalKey() async{
    var box =  await Hive.openBox<int>('key');
    box.put('key', ++globalKey);
  }

  //14:00
  void addNote(Note note, RxListUpdate rxListUpdate) async {
    var box =  await Hive.openBox<Note>('notes');
    note.key = globalKey;
    box.put(globalKey, note);
    incrementGlobalKey();
    
    if (map.containsKey(note.time))
      map[note.time].add(note);
    else
      map[note.time] = [note];

    rxListUpdate.onListUpdate(map);
  }

  void getNotes(RxListUpdate rxListUpdate) async {
    var box =  await Hive.openBox<Note>('notes');

    for (int i = 0; i < box.values.length; i++){
      Note note = box.getAt(i);

      if (map.containsKey(note.time))
        map[note.time].add(note);
      else
        map[note.time] = [note];

    }

    rxListUpdate.onListUpdate(map);
  }

  void deleteAllNotes() async{
    var box =  await Hive.openBox<Note>('notes');
    box.clear();
  }

  void deleteAtNote(Note note, RxListUpdate rxListUpdate) async{
    var box =  await Hive.openBox<Note>('notes');
    box.delete(note.key);
    map[note.time].remove(note);
    if (map[note.time].length == 0)
      map.remove(note.time);

    rxListUpdate.onListUpdate(map);
  }

  String getTimeMinus(String date){

      var arr = date.split(' ');
      DateTime now = DateTime.now();
      DateTime cardTime = DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
      var diffDt = now.difference(cardTime);

      if (diffDt.inDays == 0){
        if ( diffDt.inHours >= 0)
          return "Сегодня";
        else return "Завтра";
      }
      else if( diffDt.inDays < 0){
        return "Еще " + (-diffDt.inDays).toString() + " " + getCorrectNameDay(-diffDt.inDays);
      }
      else
        if ( (cardTime.day < now.day && cardTime.month <= now.month) || (cardTime.month < now.month))
          return "Прошло";
        return "Еще " + diffDt.inDays.toString() + " " + getCorrectNameDay(diffDt.inDays);

  }

  String getCorrectNameDay(int day){
    day %= 100;
    if ( day >= 5 && day <= 20)
      return "дней";
    else if ( day % 10 == 1)
      return "день";
    else if ( day % 10 >= 2 && day % 10 <= 4)
      return "дня";
    else if ( day % 10 >= 5 && day % 10 <= 9)
      return "дней";
    else
      return "";

  }
  int daysFromDate(String date){
    var arr = date.split(' ');
    return int.parse(arr[0]) + 36 * int.parse(arr[1]) + 3600 * int.parse(arr[2]);
  }

  Map<String, List<Note>> sortMap(Map<String, List<Note>> map){
    var sortedKeys = map.keys.toList()..sort();

    // Comparator

    Map<String, List<Note>> newMap = {};

    for (var i = sortedKeys.length - 1; i >= 0; i--)
      newMap[sortedKeys[i]] = map[sortedKeys[i]];

    return newMap;
  }
}



@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  String time;
  @HiveField(3)
  int key;

  Note();
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note()
      ..name = fields[0] as String
      ..description = fields[1] as String
      ..time = fields[2] as String
      ..key = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.key);

  }
}