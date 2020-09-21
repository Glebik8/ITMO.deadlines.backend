import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itmo_time/RxDart/rxListUpdate.dart';

import 'Model/model.dart';

import 'package:hive_flutter/hive_flutter.dart';


void main() async {

  await Hive.initFlutter();

  Hive.registerAdapter<Note>(NoteAdapter());
  await Hive.openBox<Note>('notes');

  runApp(MyApp());
}



class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Model model = Model();
  RxListUpdate listUpdate = RxListUpdate(mainList);

  @override
  void initState() {
    model.getNotes(listUpdate);
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
                  child:
                  StreamBuilder<List<Note>>(
                      stream: listUpdate.onListUpdater,
                      builder: (buildContext, snapshot) {

                        if (snapshot.hasError){
                          //
                        }

                        if (!snapshot.hasData){
                          //
                        }

                        List<Note> list = snapshot.data;
                        return ListView(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          children: bodyList(context, list),
                        );
                      })

                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            // реализовать вызов футера
            Note deadLine = Note()
            ..name = "Матан дз"
            ..description = "Номера 20-30"
            ..time = "22 09 2020";

            model.addNote(deadLine, listUpdate);
          },
          child: Icon(Icons.add),
      ),
      )
    );
  }
  // тут будем делать выбор чужого списка или своего
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
  List<Widget> bodyList(BuildContext context, List<Note> list){
      if (list == null || list.length == 0){
        return <Widget>[Container(child: Text("CLEAR"),)];
      }
      else
        print(list.length);
        List<Widget> lister = [];
        for (int i = 0; i < list.length; i++){
          lister.add( Container(
            height: 50,
            color: Colors.lime,
            child: Text(list[i].name, style: TextStyle(fontSize: 20, color: Colors.black),),
          ));
        }
        return lister;
  }

  void callbackUpdate(){
    setState(() {});
  }
}

