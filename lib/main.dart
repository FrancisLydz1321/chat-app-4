import 'package:chat_app/pages/login_pages.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // FirebaseAnalytics
  await setup();
  // if(kIsWeb) { // condition: if platform is web
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyBT8cFZzF_cFV8FFlQUMiNbUjGRIeDBIYs",
  //         authDomain: "chat-app-4-e54a4.firebaseapp.com",
  //         projectId: "chat-app-4-e54a4",
  //         storageBucket: "chat-app-4-e54a4.appspot.com",
  //         messagingSenderId: "141913459369",
  //         appId: "1:141913459369:web:a1a7d898c49bdab14337b8"));
  // }
  // else {
  //   await Firebase.initializeApp();
  // }

  runApp(MyApp());
}

Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupFirebase();
    await registerServices();
    
}


class MyApp extends StatelessWidget {

  final GetIt _getIt = GetIt.instance ; // access navigation service
  
  late NavigationService _navigationService; // because it errors in navigation_service.dart late is placed here

  late AuthService _authService = AuthService(); // late AuthService _authService @@@ REVAMPED @@@

  MyApp({super.key}) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey, // setting navigator key
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      // home: LoginPage(),
      initialRoute: _authService.user != null ? "/home" : "/login", 
      routes: _navigationService.routes,
    );
  }
}

