import 'package:flutter/material.dart';
import '../S.dart';

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
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: theme.primaryColor,
                  pinned: true,

                  expandedHeight: 125.0,
                  forceElevated: innerBoxIsScrolled,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Text(S.of(context).done),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).my_tasks,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Theme(
                              data: theme,
                              child: const Icon(Icons.visibility),
                            )),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Flexible(
                    child: Card(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 55,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Item ${index + 1}'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
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
