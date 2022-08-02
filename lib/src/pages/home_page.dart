import 'package:flutter/material.dart';
import 'package:todo/src/components/todo_list.dart';
import '../localization.dart';
import '../components/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CustomHeader(),
              ];
            },
            body: ToDoList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Theme(
          data: theme.copyWith(
              iconTheme: const IconThemeData(color: Colors.white)),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
