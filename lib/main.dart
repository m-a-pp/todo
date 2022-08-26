import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/app_theme.dart';
import 'package:todo/src/navigation/app_navigation.dart';

import 'src/models/todo_model.dart';
import 'src/app_theme.dart';
import 'src/localization.dart';

void main() {
  runApp(const ToDoApp());
}

final GlobalKey<NavigatorState> navigator = GlobalKey();

class ToDoApp extends StatefulWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ToDoListData>(
            create: (BuildContext context) => ToDoListData(),
          ),
          ChangeNotifierProvider<ToDoRouterDelegate>(
            create: (BuildContext context) => ToDoRouterDelegate(true, null),
          ),
        ],
        child: Builder(
          builder: (context) {
            return Consumer<ToDoRouterDelegate>(
                builder: (context, routerDelegate, _) {
              return MaterialApp.router(
                routeInformationParser: ToDoInformationParser(),
                routerDelegate: routerDelegate,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: Localization.supportedLocales,
                themeMode: ThemeMode.system,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
              );
            });
          },
        ));
  }
}
