import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodie3_admin/components/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCTHqRcqM-SUQpTaqdFjwu5EkFC95jaOOY",
        authDomain: "foodie3-2cbfd.firebaseapp.com",
        projectId: "foodie3-2cbfd",
        storageBucket: "foodie3-2cbfd.appspot.com",
        messagingSenderId: "216134536345",
        appId: "1:216134536345:web:e079712afb743130e43c08",
        measurementId: "G-DK9C0850Z5"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie3',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
