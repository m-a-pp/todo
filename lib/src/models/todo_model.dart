import 'package:flutter/material.dart';
import '../db/database.dart';
enum Importance { basic, low, important }

class ToDo {
  int? id;
  String? text;
  Importance? importance;
  DateTime? deadline;
  bool? done;
  DateTime? created;
  DateTime? updated;

  ToDo(
      {required this.id,
        required this.text,
        required this.importance,
        this.deadline,
        required this.done,
        required this.created,
        required this.updated});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    map['deadline'] = deadline.toString();
    map['importance'] = importanceToString(importance!);
    map['done'] = done! ? 1 : 0;
    map['created'] = created.toString();
    map['updated'] = updated.toString();

    return map;
  }

  ToDo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    text = map['text'];

    deadline = map['deadline'] != 'null' ? DateTime.parse(map['deadline']) : null;
    importance = importanceFromString(map['importance']);
    done = map['done'] == 1 ? true : false;

    created = DateTime.parse(map['created']);

    updated = DateTime.parse(map['updated']);
  }

  Importance importanceFromString(String string) {
    switch (string) {
      case 'basic':
        return Importance.basic;
      case 'low':
        return Importance.low;
      case 'important':
        return Importance.important;
    }
    return Importance.basic;
  }

  String importanceToString(Importance importance) {
    switch (importance) {
      case Importance.basic:
        return 'basic';
      case Importance.low:
        return 'low' ;
      case Importance.important:
        return 'important';
    }
  }
}

class ToDoListData with ChangeNotifier {
  List<ToDo> _toDoList = [];
  late Future<List<ToDo>> _futureToDoList;
  bool _visibility = true;

  List<ToDo> get getList => _toDoList;
  Future<List<ToDo>>? get getFutureList => _futureToDoList;
  bool get getVisibility => _visibility;

  ToDoListData (){
    fetchAndSetToDo();
  }

  Future<void> fetchAndSetToDo()  async{
    _futureToDoList = DBProvider.db.getToDoList();
    _toDoList = await _futureToDoList;
    notifyListeners();
  }


  void changeVisibility() {
    _visibility = !_visibility;
    notifyListeners();
  }

  void addToDo(ToDo newToDo) {
    _toDoList.add(newToDo);
    notifyListeners();
  }

  void deleteToDo(ToDo toDo) {
    _toDoList.remove(toDo);

    notifyListeners();
  }

  void updateToDo(ToDo toDo) {
    _toDoList[_toDoList.indexOf(toDo)] = toDo;

    notifyListeners();
  }

  int doneCounter() {
    int done = 0;
    for (var toDo in _toDoList) {
      if (toDo.done!) done++;
    }
    return done;
  }

  void updateToDoList(List<ToDo> list) {
    _toDoList = list;
    notifyListeners();
  }
}
