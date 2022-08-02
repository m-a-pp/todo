
import 'package:flutter/material.dart';
import 'package:todo/src/localization.dart';

class ToDoList extends StatefulWidget {
  ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final items = List<String>.generate(5, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Localization.of(context);
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(8),
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
                  itemCount: items.length + 1,
                  itemBuilder: (BuildContext context, int index) {

                    Widget result;
                    if (index == items.length) {
                      result = ListTile(
                        leading: Icon(Icons.check_box_outline_blank, color: theme.cardColor,),
                        title: TextField(

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: localizations.new_task,
                            hintStyle: theme.textTheme.headline2,
                          ),
                        ),
                      );
                    } else {
                      final item = items[index];
                      result = Dismissible(
                        key: Key(item),
                        confirmDismiss: (direction) async {
                          setState(() {
                            if (direction == DismissDirection.startToEnd) {
                            } else {
                              items.removeAt(index);
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
                          leading: Icon(Icons.check_box_outline_blank),
                          title: Text(
                            items[index],
                            style: theme.textTheme.bodyText1,
                          ),
                          trailing: IconButton(
                              onPressed: () {}, icon: Icon(Icons.info_outline)),
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
