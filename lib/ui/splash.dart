import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/ui/login.dart';

import 'add_book.dart';
import 'main.dart';
import 'register.dart';

var nextScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      nextScreen = LoginPage();
    } else {
      nextScreen = HomePage();
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/Login': (context) => LoginPage(),
        '/Register': (context) => RegisterPageState(),
        '/Home': (context) => HomePage(),
        '/AddBook': (context) => AddBookPage()
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: nextScreen,
    );
  }
}
