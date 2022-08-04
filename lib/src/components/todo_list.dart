import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/src/localization.dart';

import '../../main.dart';
import '../models/todo_model.dart';
import '../navigation/routes.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  //final items = List<String>.generate(15, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Localization.of(context);
    ThemeData theme = Theme.of(context);
    DateFormat dateFormat = DateFormat.yMMMMd(localizations.localeName);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Flexible(
            child: Card(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: toDoLength() + 1,
                  //items.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    Widget result;
                    if (index == toDoLength()) {
                      result = ListTile(
                        leading: Icon(
                          Icons.check_box_outline_blank,
                          color: theme.cardColor,
                        ),
                        title: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: localizations.new_task,
                            hintStyle: theme.textTheme.headline2,
                          ),
                          onSubmitted: (value) {
                            ToDo newToDo = ToDo(
                              id: toDoLength().toString(),
                              text: value,
                              done: false,
                              created: DateTime.now(),
                              updated: DateTime.now(),
                              importance: Importance.basic,
                            );
                            addToDo(newToDo);
                            setState(() {
                              ToDoList;
                            });
                          },
                        ),
                      );
                    } else {
                      final item = toDoI(index);
                      //items[index];
                      result = Dismissible(
                        key: Key(item.id),
                        confirmDismiss: (direction) async {
                          setState(() {
                            if (direction == DismissDirection.startToEnd) {
                              setState(() {
                                toDoList[index].done = true;
                              });
                            } else {
                              deleteToDo(toDoI(index));
                            }
                          });
                        },
                        background: Container(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: theme.cardColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: theme.cardColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.check_box_outline_blank),
                          title: Text(item.text,
                                  style: item.done ? theme.textTheme.headline4 :theme.textTheme.bodyText1,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis),
                          subtitle: item.deadline != null
                              ? Padding(

                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                    dateFormat
                                        .format(item.deadline ?? DateTime.now()),
                                  ),
                              )
                              : null,
                          trailing: IconButton(
                              onPressed: () {
                                final arguments = item.id;
                                navigator.currentState?.pushReplacementNamed(
                                    Routes.todo,
                                    arguments: arguments);
                              },
                              icon: const Icon(Icons.info_outline)),
                        ),
                      );
                    }
                    return result;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
