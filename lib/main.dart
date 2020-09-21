import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'Model/model.dart';

import 'package:hive_flutter/hive_flutter.dart';


void main() async {

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('notes');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Model model = Model();
  @override
  void initState() {
    model.initHive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                color: model.headColor,
                width: double.infinity,
                height: 100.0,
                child: chooseList(context)
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  color: model.bodyColor,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            model.addNote();
          },
          child: Icon(Icons.add),
      ),
      )
    );
  }

  Widget chooseList(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          "Мои дедлайны",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),),
    );
  }
}

