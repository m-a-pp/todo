import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo/src/db/database.dart';
import '../localization.dart';
import '../models/todo_model.dart';
import '../navigation/app_navigation.dart';

class ToDoPage extends StatefulWidget {
  final int? id;

  const ToDoPage({Key? key, this.id}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  String? dropdownValue;
  bool switchValue = false;
  DateTime date = DateTime.now();
  bool newToDo = true;
  String newTask = '';
  late ToDo toDoCopy;
  bool built = false;
  final TextEditingController _textController = TextEditingController();

  void removeToDo(ToDo toDo) {
    context.read<ToDoListData>().removeToDo(toDo);
    context.read<ToDoRouterDelegate>().gotoHome();
  }

  void updateToDo(ToDo toDo) {
    context.read<ToDoListData>().updateToDo(toDo);
    context.read<ToDoRouterDelegate>().gotoHome();
  }

  @override
  Widget build(BuildContext context) {
    int? id = widget.id;
    ToDo? toDo = context.read<ToDoListData>().findToDo(id!);
    toDo = argumentsCheck(toDo);
    built = true;
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
            if (newToDo) {
              removeToDo(toDo!);
            } else {
              toDo!.text = toDoCopy.text;
              toDo.deadline = toDoCopy.deadline;
              toDo.importance = toDoCopy.importance;
              updateToDo(toDo);
            }
          },
        ),
        backgroundColor: theme.primaryColor,
        actions: [
          TextButton(
              onPressed: () {
                toDo!.updated = DateTime.now();
                updateToDo(toDo);
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
                        removeToDo(toDo!);
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
                        removeToDo(toDo!);
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
    if (!built) {
      toDoCopy = ToDo(
        id: toDo!.id,
        text: toDo.text,
        importance: toDo.importance,
        done: toDo.done,
        created: toDo.created,
        updated: toDo.updated,
        deadline: toDo.deadline,
      );
    }

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
