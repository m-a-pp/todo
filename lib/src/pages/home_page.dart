import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/main.dart';
import 'package:todo/src/components/todo_list.dart';
import 'package:todo/src/models/todo_model.dart';
import '../components/header.dart';
import '../navigation/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<ToDo> toDoList;

  @override
  Widget build(BuildContext context) {
    ToDoListData();
    ThemeData theme = Theme.of(context);
    toDoList = context.watch<ToDoListData>().getList;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // const CustomHeader(),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: const CustomHeader(),
              ),
            ];
          },
          body: Builder(builder: (context) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    const ToDoList(),
                  ]))
                ],
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ToDo? arguments = ToDo(
            id: toDoList.length,
            text: '',
            importance: Importance.basic,
            done: false,
            created: DateTime.now(),
            updated: null,
          );
          navigator.currentState?.pushNamed(Routes.todo, arguments: arguments);
        },
        child: Theme(
          data: theme.copyWith(
              iconTheme: const IconThemeData(color: Colors.white)),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
