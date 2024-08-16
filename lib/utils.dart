import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_services.dart';
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


Future<void> registerServices() async {
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
}
