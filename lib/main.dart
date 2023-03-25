import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/component/toast.dart';
import 'package:notes/crud/edit_note.dart';
import 'package:notes/crud/view_note.dart';
import 'package:notes/ui/auth/log_in.dart';
import 'package:notes/ui/auth/sign_up.dart';
import 'package:notes/ui/home.dart';

import 'crud/add_note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FToast().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: FToastBuilder(),
      theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 20, color: Colors.white),
            headlineSmall: TextStyle(fontSize: 30, color: Colors.blue),
            bodyMedium: TextStyle(fontSize: 20, color: Colors.black),
          )),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/log_in": (context) => const LogIn(),
        "/sign_up": (context) => const SignUp(),
        "/add_note": (context) => const AddNotes(),

      },
    );
  }
}