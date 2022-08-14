import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/main.dart';
import 'package:todo/src/db/database.dart';
import '../localization.dart';
import '../models/todo_model.dart';
import '../navigation/routes.dart';

class ToDoPage extends StatefulWidget {
  final ToDo? toDo;

  const ToDoPage({Key? key, this.toDo}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  String? dropdownValue;
  bool switchValue = false;
  DateTime date = DateTime.now();
  bool newToDo = true;
  String newTask = '';
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToDo? toDo = widget.toDo;
    toDo = argumentsCheck(toDo!);
    ThemeData theme = Theme.of(context);
    AppLocalizations localizations = Localization.of(context);
    dropdownValue = toDo.importance == Importance.basic
        ? localizations.basic
        : toDo.importance == Importance.important
        ? localizations.important
        : localizations.low;
    DateFormat dateFormat = DateFormat.yMMMMd(localizations.localeName);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: theme.textTheme.headline1!.color,
          ),
          onPressed: () {
            navigator.currentState!.pop();
          },
        ),
        backgroundColor: theme.primaryColor,
        actions: [
          TextButton(
              onPressed: () {
                toDo!.updated = DateTime.now();
                if (newToDo) {
                  context.read<ToDoListData>().addToDo(toDo);
                  DBProvider.db.insertToDo(toDo);
                } else {
                  context.read<ToDoListData>().updateToDo(toDo);
                  DBProvider.db.updateToDo(toDo);
                }
                navigator.currentState!.pop();
              },
              child: Text(localizations.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: localizations.what_todo,
                        hintStyle: theme.textTheme.headline2,
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        newTask = value;
                        toDo!.text = value;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.importance,
                      style: theme.textTheme.bodyText1,
                    ),
                    SizedBox(
                      width: 150,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        iconSize: 0.0,
                        items: [
                          localizations.basic,
                          localizations.important,
                          localizations.low
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              '${value == localizations.important ? '!!' : ''}$value',
                              style: value == localizations.important
                                  ? theme.textTheme.bodyText1!
                                  .copyWith(color: Colors.red)
                                  : theme.textTheme.bodyText1,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          dropdownValue = newValue;
                          if (dropdownValue == localizations.basic) {
                            toDo!.importance = Importance.basic;
                          } else if (dropdownValue == localizations.important) {
                            toDo!.importance = Importance.important;
                          } else {
                            toDo!.importance = Importance.low;
                          }
                          setState(() {
                            dropdownValue;
                          });
                        },
                        value: dropdownValue,
                      ),
                    ),
                    Divider(
                      color: theme.dividerColor,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  localizations.finish_up_to,
                  style: theme.textTheme.bodyText1,
                ),
                subtitle: !switchValue
                    ? null
                    : TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dateFormat.format(date),
                    ),
                  ),
                  onPressed: () async {
                    if (switchValue == true) {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (newDate != null) {
                        setState(() {
                          date = newDate;
                        });
                        toDo!.deadline = date;
                      }
                    }
                  },
                ),
                trailing: Switch(
                  activeColor: theme.secondaryHeaderColor,
                  value: switchValue,
                  onChanged: (value) async {
                    setState(() {
                      if (toDo!.deadline == null) {
                        toDo.deadline = date;
                      } else {
                        toDo.deadline = null;
                      }
                      switchValue = !switchValue;
                    });
                  },
                ),
              ),
              Divider(
                color: theme.dividerColor,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: newToDo
                          ? theme.textTheme.headline2?.color
                          : theme.textTheme.bodyText2?.color,
                    ),
                    onPressed: () {
                      if (!newToDo) {
                        context.read<ToDoListData>().deleteToDo(toDo!);
                        DBProvider.db.deleteToDo(toDo.id);
                        navigator.currentState!.pop();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          localizations.delete,
                          style: newToDo
                              ? theme.textTheme.headline2
                              : theme.textTheme.bodyText2,
                        )),
                    onPressed: () {
                      if (!newToDo) {
                        context.read<ToDoListData>().deleteToDo(toDo!);
                        DBProvider.db.deleteToDo(toDo.id);
                        navigator.currentState!.pop();
                      }
                    },
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  ToDo argumentsCheck(ToDo? toDo) {
    if (toDo!.updated != null) {
      newToDo = false;
    }
    if (toDo.deadline != null) {
      switchValue = true;
      date = toDo.deadline ?? date;
    }

    _textController.text = toDo.text!;

    return toDo;
  }
}
