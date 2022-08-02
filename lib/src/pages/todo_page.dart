import 'package:flutter/material.dart';
import '../localization.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  String? dropdownValue;
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations localizations = Localization.of(context);
    dropdownValue = localizations.no_priority;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: theme.textTheme.headline1!.color,
          ),
          onPressed: () {},
        ),
        backgroundColor: theme.primaryColor,
        actions: [
          TextButton(onPressed: () {}, child: Text(localizations.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //ListView(
                //shrinkWrap: true,
                //children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Flexible(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: localizations.what_todo,
                              hintStyle: theme.textTheme.headline2,
                              border: InputBorder.none,
                            ),
                          ),
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
                        Container(
                          width: 150,
                          child: DropdownButtonFormField(
                            hint: Text(localizations.no_priority),
                            //value: dropdownValue,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            iconSize: 0.0,
                            //style: theme.textTheme.headline2,
                            items: [
                              localizations.no_priority,
                              localizations.high_priority,
                              localizations.low_priority
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: theme.textTheme.bodyText1,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              dropdownValue = newValue;
                              setState(() {
                                dropdownValue;
                              });
                            },
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      localizations.finish_up_to,
                      style: theme.textTheme.bodyText1,
                    ),
                    subtitle: const Text('sdfdsf'),
                    trailing: Switch(
                      value: switchValue,
                      onChanged: (value) {
                        setState(() {
                          switchValue = !switchValue;
                        });
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: TextButton(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            localizations.delete,
                            style: theme.textTheme.headline2,
                          )),
                      onPressed: () {},
                    ),
                    leading: Icon(
                      Icons.delete,
                      color: theme.textTheme.headline2?.color,
                    ),
                  )
                //],
              //),
            ]),
      ),
    );
  }
}
