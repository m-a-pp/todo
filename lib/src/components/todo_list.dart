import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/localization.dart';

import '../../main.dart';
import '../db/database.dart';
import '../models/todo_model.dart';
import '../navigation/routes.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            child: FutureBuilder(
              future: context.watch<ToDoListData>().getFutureList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const CustomList();
                } else {
                  return CircularProgressIndicator();
                  //return const CustomList();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomList extends StatefulWidget {
  const CustomList({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  late List<ToDo> toDoList;
  late AppLocalizations localizations;
  late ThemeData theme;
  late DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    localizations = Localization.of(context);
    theme = Theme.of(context);
    dateFormat = DateFormat.yMMMMd(localizations.localeName);
    toDoList = context.watch<ToDoListData>().getList;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: toDoList.length + 1,
      itemBuilder: (BuildContext context, int index) {
        Widget result;
        if (index == toDoList.length) {
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
                  id: toDoList.length,
                  text: value,
                  done: false,
                  created: DateTime.now(),
                  updated: DateTime.now(),
                  importance: Importance.basic,
                );
                context.read<ToDoListData>().addToDo(newToDo);
                DBProvider.db.insertToDo(newToDo);
              },
            ),
          );
        } else {
          final item = toDoList[index];
          //items[index];
          result = Dismissible(
              key: Key(item.id.toString()),
              confirmDismiss: (direction) async {
                setState(() {
                  if (direction == DismissDirection.startToEnd) {
                    toDoList[index].done = true;
                    context.read<ToDoListData>().updateToDo(toDoList[index]);
                    DBProvider.db.updateToDo(toDoList[index]);
                  } else {
                    context.read<ToDoListData>().deleteToDo(item);
                    DBProvider.db.deleteToDo((item.id));
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
                        color: theme.hoverColor,
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
                        color: theme.hoverColor,
                      ),
                    ],
                  ),
                ),
              ),
              child: Visibility(
                visible:
                context.watch<ToDoListData>().getVisibility || !item.done!,
                child: ListTile(
                  leading: item.done!
                      ? Icon(
                    Icons.check_box,
                    color: theme.indicatorColor,
                  )
                      : item.importance == Importance.important
                      ? Icon(
                    Icons.check_box_outline_blank,
                    color: theme.hintColor,
                  )
                      : Icon(
                    Icons.check_box_outline_blank,
                    color: theme.hintColor,
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (item.done == true || item.importance == Importance.basic)
                          ? const Text('')
                          : item.importance == Importance.important
                          ? ImageIcon(
                        const AssetImage('assets/important.png'),
                        color: theme.textTheme.bodyText2!.color,
                      )
                          : ImageIcon(const AssetImage('assets/low.png'),
                          color: theme.textTheme.headline2!.color),
                      Text(item.text!,
                          style: item.done!
                              ? theme.textTheme.headline4
                              : theme.textTheme.bodyText1,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  subtitle: item.deadline != null
                      ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      dateFormat.format(item.deadline ?? DateTime.now()),
                    ),
                  )
                      : null,
                  trailing: IconButton(
                    onPressed: () {
                      final arguments = item;
                      navigator.currentState
                          ?.pushNamed(Routes.todo, arguments: arguments);
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: theme.hintColor,
                    ),
                  ),
                ),
              ));
        }
        return result;
      },
    );
  }
}
