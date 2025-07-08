import 'package:flutter/material.dart';
import 'package:todoapp0/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp0/screens/login_register_page.dart';
import 'package:todoapp0/service/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final authService = Auth();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
        if(snapshot.hasData){ // kullanıcı giriş yapmışsa datası varsa
          return HomeScreen();
        }
        else{
          return LoginRegisterPage();
        }
      },),
    );
  }
}
