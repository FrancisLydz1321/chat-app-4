import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME PAGE'),
        actions: [
          IconButton(
            onPressed: () async {
              bool result =
                  await _authService.logout(); // allow user to log out
              if (result) {
                // if result is true
                _alertService.showToast(
                    text: "Successfully Logged out", icon: Icons.check);
                _navigationService.pushReplacementNamed(
                    "/login"); // once logout button is clicked, return to login page
              }
            },
            color: Colors.red,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Text("hello World"),
          Text("hello World"),
          Text("hello World"),
          Text("hello World"),
        ],
      ),
    );
  }
}
