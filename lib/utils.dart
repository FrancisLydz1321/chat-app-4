import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';



Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// registering services


Future<void> registerServices() async { // register services to firebase
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>( // type: AuthService
    AuthService(), // instance of a class
  );

  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );

  getIt.registerSingleton<AlertService>(
    AlertService(),
  );

  getIt.registerSingleton<MediaService>(
    MediaService(),
  );

  getIt.registerSingleton<StorageService>(
    StorageService(),
  );

   getIt.registerSingleton<DatabaseService>(
    DatabaseService(),
  );

}

String generateChatID({required String uid1,required String uid2,}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold("", (id,uid) => "$id$uid1");
  return chatID;
}