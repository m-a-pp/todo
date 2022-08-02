import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/src/app_theme.dart';


import 'src/app_theme.dart';
import 'src/localization.dart';
import 'src/pages/home_page.dart';
import 'src/pages/todo_page.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _isDark = false;
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Localization.supportedLocales,
      theme: AppTheme.theme(_isDark),
      home: HomePage(),
      //home: ToDoPage(),
    );
  }
}


