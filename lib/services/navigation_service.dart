import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_pages.dart';
import 'package:flutter/material.dart';

class NavigationService {
  
  // late GlobalKey<NavigatorState> _navigatorKey; //late
  // GlobalKey<NavigatorState>? _navigatorKey; // don't know why late is not initialize go to main()

  // late GlobalKey<NavigatorState> _navigatorKey;
  late GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();


  final Map<String, Widget Function(BuildContext)> _routes = { // root route
    "/login": (context) => LoginPage(),
    "/home": (context) => HomePage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey { // getter
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes { // getter
    return _routes;
  }
  
  NavigatorService() { // constructor
    _navigatorKey = GlobalKey<NavigatorState>();
  }


  void pushNamed(String routename) { // function: 1
    _navigatorKey.currentState?.pushNamed(routename);
  }


  void pushReplacementNamed(String routename) { // function: 2
    _navigatorKey.currentState?.pushReplacementNamed(routename);
  }


  void goBack() { // function: 3 
    _navigatorKey.currentState?.pop();
  }
}