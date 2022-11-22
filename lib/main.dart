import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //     apiKey: "AIzaSyDFSOpkcN6RJiX0AIhyPp8-AZA_dC9Qv7M",
      //     authDomain: "todoapp-8995b.firebaseapp.com",
      //     projectId: "todoapp-8995b",
      //     storageBucket: "todoapp-8995b.appspot.com",
      //     messagingSenderId: "609965736461",
      //     appId: "1:609965736461:web:ed827b4976732996018b44")
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
