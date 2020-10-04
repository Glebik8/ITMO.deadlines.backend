

import 'package:flutter/cupertino.dart';
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

  runApp(MyAppMain());
}

// этот доп класс нужен, чтобы MediaQ работал и можно было чекнуть размер клавы
class MyAppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

double heightKeyBoard = 0;
class _MyAppState extends State<MyApp> {

  Model model = Model();
  RxListUpdate listUpdate = RxListUpdate(map);

  @override
  void initState() {
    model.deleteAllNotes();
    model.getNotes(listUpdate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).viewInsets.bottom;
    print(size);
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'lib/assets/back.png'),
                    fit: BoxFit.cover,
                  ),
                ),

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

          Note deadLine = Note()
            ..name = "Матан дз"
            ..description = "Номера 20-30"
            ..time = "23 09 2020";



          model.addNote(deadLine, listUpdate);
        },
        child: Icon(Icons.add),
      ),
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
        Center(
          child: Container(
            child: Text("CLEAR"),
          ),
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
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data,
                  style: TextStyle(fontSize: 20, color: model.timeTextColor, fontFamily: 'TTDemi'),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      height: 2,
                      color: model.cardText,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "еще два дня",
                    style: TextStyle(fontSize: 18, color: model.cardText, fontFamily: 'TTDemi'),
                  ),
                ),
              ),
            ],
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
  Widget setContainterByHeight(BuildContext context){

    return Positioned(
      bottom:  heightKeyBoard,
      child: Container(

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
              borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      style: TextStyle(fontSize: 24, color: model.cardTextHead, fontFamily: 'TTDemi'),
                    )),
                SizedBox(
                  height: 1,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      note.description,
                      style: TextStyle(fontSize: 20, color: model.cardText, fontFamily: 'TTDemi'),
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

