import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/widgets/chat_tile.dart';
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
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Messages'),
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
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to load data"),
            );
          }
          // print(snapshot.data);
          if (snapshot.hasData && snapshot.data != null) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserProfile user = users[index].data();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ChatTile(
                    userProfile: user,
                    onTap: () async {
                      final chatExists = await _databaseService.checkChatExists(
                        _authService.user!.uid,
                        user.uid!,
                      );
                      // print(chatExists);
                      if (!chatExists) {
                        await _databaseService.createNewChat(
                          _authService.user!.uid,
                          user.uid!,
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
