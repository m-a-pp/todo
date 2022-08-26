import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/todo_page.dart';

class ToDoRouterDelegate extends RouterDelegate<AppNavigationConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppNavigationConfig> {
  bool _isHomePage;
  int? _id;

  ToDoRouterDelegate(this._isHomePage, this._id);

  bool get isHomePage => _isHomePage;

  bool get isToDoPage => !_isHomePage && _id != null;

  void gotoHome() {
    _isHomePage = true;
    _id = null;
    notifyListeners();
  }

  void gotoToDoPage(int id) {
    _isHomePage = false;
    _id = id;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (isHomePage) const MaterialPage(child: HomePage()),
        if (isToDoPage) MaterialPage(child: ToDoPage(id: _id)),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _id = null;
        _isHomePage = true;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppNavigationConfig configuration) {
    _isHomePage = configuration._isHomePage;
    _id = configuration._id;
    return Future.value();
  }

  @override
  AppNavigationConfig? get currentConfiguration {
    return AppNavigationConfig(_isHomePage, _id);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();
}

class AppNavigationConfig {
  final bool _isHomePage;
  int? _id;

  AppNavigationConfig(this._isHomePage, this._id);

  AppNavigationConfig.home() : _isHomePage = true;

  AppNavigationConfig.toDoPage(int id)
      : _isHomePage = false,
        _id = id;

  bool get isHomePage => _isHomePage;

  bool get isToDoPage => !_isHomePage && _id != null;
}

class ToDoInformationParser
    extends RouteInformationParser<AppNavigationConfig> {
  @override
  Future<AppNavigationConfig> parseRouteInformation(
      RouteInformation routeInformation) {
    if (routeInformation.location == null) {
      return SynchronousFuture(AppNavigationConfig.home());
    }
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) {
      return SynchronousFuture(AppNavigationConfig.home());
    } else {
      SynchronousFuture(
          AppNavigationConfig.toDoPage(int.tryParse(uri.pathSegments[1]) ?? 0));
    }
    return SynchronousFuture(AppNavigationConfig.home());
  }

  @override
  RouteInformation? restoreRouteInformation(AppNavigationConfig configuration) {
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isToDoPage) {
      return RouteInformation(location: '/todo/${configuration._id}');
    }
    return const RouteInformation(location: '/');
  }
}
