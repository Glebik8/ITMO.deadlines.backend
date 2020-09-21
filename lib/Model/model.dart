

import 'dart:io';
import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Model{

  Color headColor = Color(0xFF8D93AB);
  Color bodyColor = Color(0xFFFFFFFF);

  void initHive() async {

   //var path = Directory.current.path;


    var box =  await Hive.openBox('settings');
    box.put('name', 'David');
    var name = box.get('name');
    print('Name: $name');
  }

  void addNote() async {

    var box =  await Hive.openBox('notes');
    box.put('name', 'David');

  }
}

@HiveType(typeId: 0)
class DeadLine {

  @HiveField(0)
  String name;

  @HiveField(1)
  String description;
}