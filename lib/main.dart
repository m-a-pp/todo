import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/src/app_theme.dart';

import 'src/app_theme.dart';
import 'src/localization.dart';
import 'src/models/todo_model.dart';
import 'src/pages/home_page.dart';
import 'src/pages/todo_page.dart';
import 'src/navigation/routes.dart';

void main() {
  runApp(const ToDoApp());
}

final GlobalKey<NavigatorState> navigator = GlobalKey();

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = false;
    return MaterialApp(
      navigatorKey: navigator,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Localization.supportedLocales,
      theme: AppTheme.theme(isDark),
      initialRoute: Routes.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case (Routes.home):
            return MaterialPageRoute(builder: (context) => const HomePage());
          case (Routes.todo):
            return MaterialPageRoute(builder: (context) => ToDoPage(toDo: settings.arguments as ToDo));
        }
      },
      home: const HomePage(),
    );
  }
}
