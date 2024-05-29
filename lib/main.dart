import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/documentationScreen.dart';
import 'package:pfe/screens/home_screen.dart';
import 'package:pfe/screens/notificationScreen.dart';
import 'package:pfe/screens/signin_screen.dart';
import 'package:pfe/screens/tipsScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDVq7vyHe7taXxjzTMWcI6rQWZXmSlrHH8",
    appId: "951992438125:android:b04da2ddfd1f2473701e64",
    messagingSenderId: "951992438125",
    projectId: "pfemariem-a07b5",
    storageBucket: "pfemariem-a07b5.appspot.com",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: HomeScreen(),
    );
  }
}
