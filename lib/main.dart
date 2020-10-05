

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itmo_time/RxDart/rxListUpdate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Model/model.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

Model model = Model();

void main() async {

  await Hive.initFlutter();

  Hive.registerAdapter<Note>(NoteAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox<int>('key');
  model.initGlobalKey();

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

  PanelController _pc = new PanelController();
  var controllerSearch = TextEditingController();
  var nameOfWorkSpace = "";
  DateTime time = DateTime.now();
  void updateSearch(){
    nameOfWorkSpace = controllerSearch.text;
  }

  Model model = Model();
  RxListUpdate listUpdate = RxListUpdate(map);

  @override
  void initState() {
    controllerSearch.addListener(updateSearch);

    model.deleteAllNotes();
    model.getNotes(listUpdate);
    print(model.getTimeMinus("10 10 2020"));

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
            SlidingUpPanel(
              controller: _pc,
              minHeight: 0,
              color: model.cardColor,
              maxHeight: 300,
              panel: Column(
                children: [
                  Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Что нужно сделать?",
                      style: TextStyle(color: model.slideColorText, fontSize: 20, fontFamily: 'TTDemi'),
                      ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: model.textFieldBack,
                        border: Border.all(color: model.textFieldStroke)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          showCursor: true,
                          controller: controllerSearch,
                          style: TextStyle(color:  Colors.white, fontFamily: 'RobotoMedium'),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Доделать матан",
                              hintStyle: TextStyle(color: model.cardText, fontFamily: 'RobotoMedium')
                          ),
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blueGrey)
                            ),
                            onPressed: (){
                              time = DateTime.now();

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                              child: Text(
                                "Сегодня",
                                style: TextStyle(color: model.slideColorText, fontSize: 20, fontFamily: 'TTDemi'),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blueGrey)
                            ),
                            onPressed: (){

                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),

                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: const Color(0xFF242732),
                                      accentColor: const Color(0xFF242732),
                                      colorScheme: ColorScheme.light(primary: const Color(0xFF242732)),
                                      buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary
                                      ),
                                      backgroundColor: Colors.deepPurpleAccent
                                    ),
                                    child: child,
                                  );
                                },
                              ).then((value) =>
                                  {
                                    time = value,
                                    print(value)
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                              child: Text(
                                "Другое",
                                style: TextStyle(color: model.slideColorText, fontSize: 20, fontFamily: 'TTDemi'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        child: RaisedButton(
                          onPressed: () {
                            if (nameOfWorkSpace.isNotEmpty)
                              {
                                Note deadLine = Note()
                                  ..name = nameOfWorkSpace
                                  ..description = "Какое-то описание"
                                  ..time = time.day.toString() + " " +  time.month.toString() + " " +  time.year.toString();

                                model.addNote(deadLine, listUpdate);
                              }


                          },
                          color: model.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            height: 50,
                            width: 100,
                            child: Center(
                              child: Text("Enter", style: TextStyle(
                                  color: model.cardTextHead,
                                  fontSize: 20,
                                  fontFamily: 'TTDemi'
                              ),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: model.actionButton,
        onPressed: (){

          Note deadLine = Note()
            ..name = "Матан дз"
            ..description = "Номера 20-30"
            ..time = time.day.toString() + " " +  time.month.toString() + " " +  time.year.toString();

          _pc.open();
          //model.addNote(deadLine, listUpdate);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // тут будеьшм делать выбор чужого списка или своего
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
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            child: Center(
              child: Text(
                "Пусто, добавтье дедлайн :3",
                style: TextStyle(
                    fontSize: 18,
                    color: model.cardText,
                    fontFamily: 'TTMed'),
              ),
            ),
          ),
        ),
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
                  data.split(' ')[0],
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
                    model.getTimeMinus(data),
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
                      style: TextStyle(fontSize: 20, color: model.cardText, fontFamily: 'TTMed'),
                    )),
              ],
            ),
          ),
        ),
      ),

      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: model.bodyColor,
          icon: Icons.delete,
          onTap: () => {
                model.deleteAtNote(note, listUpdate)
          },
        ),
      ],
    );
  }
  Widget cont(){
    return Container(
      decoration: BoxDecoration(
          color: model.cardColor,
          border: Border.all(
            color: model.cardStroke,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}

