

import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itmo_time/RxDart/rxListUpdate.dart';

List<Note> mainList = [];

class Model{

  Color headColor = Color(0xFF8D93AB);
  Color bodyColor = Color(0xFFFFFFFF);


  void addNote(Note note, RxListUpdate rxListUpdate) async {

    var box =  await Hive.openBox<Note>('notes');
    box.add(note);
    mainList.add(note);

    rxListUpdate.onListUpdate(mainList);
  }
  void getNotes(RxListUpdate rxListUpdate) async {
    var box =  await Hive.openBox<Note>('notes');

    for (int i = 0; i < box.values.length; i++){
      Note note = box.getAt(i);
      mainList.add(note);
    }
    // обновить основной список - потом сделаем RxDart, но щас пока что callback
    rxListUpdate.onListUpdate(mainList);
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
  void printS(){ print(name);}
  Note(); //day month year
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
      ..time = fields[2] as String;
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
      ..write(obj.time);

  }
}