import 'package:flutter/material.dart';

import 'Model/model.dart';



void main() {
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
      title: 'Flutter Demo',

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

