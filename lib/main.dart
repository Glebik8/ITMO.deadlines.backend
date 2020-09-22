import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itmo_time/RxDart/rxListUpdate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  RxListUpdate listUpdate = RxListUpdate(map);

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
                  StreamBuilder<Map<String, List<Note>>>(
                      stream: listUpdate.onListUpdater,
                      builder: (buildContext, snapshot) {
                        Map<String, List<Note>> list = snapshot.data;
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
            ..time = "23 09 2020";

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
  List<Widget> bodyList(BuildContext context, Map<String, List<Note>> list){
    if (list == null || list.length == 0) {
      return <Widget>[
        Container(
          child: Text("CLEAR"),
        )
      ];
    } else {
      List<Widget> lister = [];
      List<String> keys = list.keys.toList();

      for (int i = 0; i < list.length; i++) {
        lister.add(blockItems(context, keys[i], list[keys[i]]));
      }
      return lister;
    }
  }

  Widget blockItems(BuildContext context, String data, List<Note> list) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data,
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Column(
            children: convertListToWidgets(context, list),
          )
        ],
      ),
    );
  }

  List<Widget> convertListToWidgets(BuildContext context, List<Note> list) {
    List<Widget> lister = [];
    for (int i = 0; i < list.length; i++)
      lister.add(listItem(context, list[i]));
    return lister;
  }

  Widget listItem(BuildContext context, Note note) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 20),
        child: Container(
          decoration: BoxDecoration(
              color: model.cardColor,
              border: Border.all(
                color: model.cardStroke,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 5),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      note.name,
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    )),
                SizedBox(
                  height: 4,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      note.description,
                      style: TextStyle(fontSize: 20, color: model.cardText),
                    )),
              ],
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.white,
          icon: Icons.more_horiz,
          onTap: () => {},
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.white,
          icon: Icons.delete,
          onTap: () => {},
        ),
      ],
    );
  }
}

