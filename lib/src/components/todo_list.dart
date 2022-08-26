import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/components/todo_list_item.dart';

import '../models/todo_model.dart';

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
                  return const CircularProgressIndicator();
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
  final GlobalKey<AnimatedListState> listAnimationKey =
      GlobalKey<AnimatedListState>();
  late List<ToDo> toDoList;

  @override
  Widget build(BuildContext context) {
    toDoList = context.watch<ToDoListData>().getList;
    return AnimatedList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      initialItemCount: toDoList.length + 1,
      key: listAnimationKey,
      itemBuilder: (BuildContext context, int index, animation) {
        Widget result;
        if (index == toDoList.length) {
          result = InputFieldListItem(
            listAnimationKey: listAnimationKey,
          );
        } else {
          result = ToDoListItem(
            index: index,
            toDoListItem: toDoList[index],
            animation: animation,
            listAnimationKey: listAnimationKey,
          );
        }
        return result;
      },
    );
  }
}
