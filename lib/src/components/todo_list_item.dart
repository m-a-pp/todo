import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/localization.dart';

import '../models/todo_model.dart';
import '../navigation/app_navigation.dart';

class ToDoListItem extends StatefulWidget {
  final int index;
  final ToDo toDoListItem;
  final Animation<double> animation;
  final GlobalKey<AnimatedListState> listAnimationKey;

  const ToDoListItem(
      {required this.index,
      required this.animation,
      required this.toDoListItem,
      required this.listAnimationKey,
      Key? key})
      : super(key: key);

  @override
  State<ToDoListItem> createState() => _ToDoListItemState();
}

class _ToDoListItemState extends State<ToDoListItem> {
  late int index;
  late Animation<double> animation;
  late AppLocalizations localizations;
  late ThemeData theme;
  late DateFormat dateFormat;
  late List<ToDo> toDoList;
  late ToDo toDo;
  late GlobalKey<AnimatedListState> listAnimationKey;

  void updateToDo(ToDo toDo) {
    toDo.done = true;
    context.read<ToDoListData>().updateToDo(toDo);
  }

  void removeToDo(int index) {
    listAnimationKey.currentState!.removeItem(
      index,
      (context, animation) => ToDoListItem(
        index: index,
        animation: animation,
        toDoListItem: toDo,
        listAnimationKey: listAnimationKey,
      ),
    );
    context.read<ToDoListData>().removeToDo(toDo);
  }

  @override
  Widget build(BuildContext context) {
    toDo = widget.toDoListItem;
    index = widget.index;
    animation = widget.animation;
    listAnimationKey = widget.listAnimationKey;

    localizations = Localization.of(context);
    theme = Theme.of(context);
    dateFormat = DateFormat.yMMMMd(localizations.localeName);
    toDoList = context.watch<ToDoListData>().getList;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-2, 0),
        end: Offset.zero,
      ).animate(animation),
      child: Dismissible(
          key: Key(toDo.id.toString()),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              updateToDo(toDo);
            } else {
              removeToDo(index);
            }
            return null;
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
            visible: context.watch<ToDoListData>().getVisibility || !toDo.done!,
            child: ListTile(
              leading: toDo.done!
                  ? Icon(
                      Icons.check_box,
                      color: theme.indicatorColor,
                    )
                  : toDo.importance == Importance.important
                      ? Icon(
                          Icons.check_box_outline_blank,
                          color: theme.hintColor,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: theme.hintColor,
                        ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (toDo.done == true || toDo.importance == Importance.basic)
                      ? const Text('')
                      : toDo.importance == Importance.important
                          ? ImageIcon(
                              const AssetImage('assets/important.png'),
                              color: theme.textTheme.bodyText2!.color,
                            )
                          : ImageIcon(const AssetImage('assets/low.png'),
                              color: theme.textTheme.headline2!.color),
                  Expanded(
                    child: Text(toDo.text!,
                        style: toDo.done!
                            ? theme.textTheme.headline4
                            : theme.textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              subtitle: toDo.deadline != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        dateFormat.format(toDo.deadline ?? DateTime.now()),
                      ),
                    )
                  : null,
              trailing: IconButton(
                onPressed: () {
                  int? id = toDo.id;
                  context.read<ToDoRouterDelegate>().gotoToDoPage(id!);
                },
                icon: Icon(
                  Icons.info_outline,
                  color: theme.hintColor,
                ),
              ),
            ),
          )),
    );
  }
}

class InputFieldListItem extends StatefulWidget {
  final GlobalKey<AnimatedListState> listAnimationKey;

  const InputFieldListItem({required this.listAnimationKey, Key? key})
      : super(key: key);

  @override
  State<InputFieldListItem> createState() => _InputFieldListItemState();
}

class _InputFieldListItemState extends State<InputFieldListItem> {
  late AppLocalizations localizations;
  late ThemeData theme;
  late DateFormat dateFormat;
  late List<ToDo> toDoList;
  late GlobalKey<AnimatedListState> listAnimationKey;

  @override
  Widget build(BuildContext context) {
    listAnimationKey = widget.listAnimationKey;
    localizations = Localization.of(context);
    theme = Theme.of(context);
    dateFormat = DateFormat.yMMMMd(localizations.localeName);
    toDoList = context.watch<ToDoListData>().getList;

    return ListTile(
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
          insertToDo(value);
        },

      ),
    );
  }

  void insertToDo(String value) {
    ToDo newToDo = ToDo(
      id: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      text: value,
      done: false,
      created: DateTime.now(),
      updated: DateTime.now(),
      importance: Importance.basic,
    );
    listAnimationKey.currentState!.insertItem(toDoList.length);
    context.read<ToDoListData>().insertToDo(newToDo);
  }
}
