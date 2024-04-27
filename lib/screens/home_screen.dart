import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseReference _temperatureRef;
  late DatabaseReference _humidityRef;

  late String _temperature = "Loading...";
  late String _humidity = "Loading...";

  @override
  void initState() {
    super.initState();
    // Initialize Firebase database reference
    _temperatureRef = FirebaseDatabase.instance.ref().child('temperature');
    _humidityRef = FirebaseDatabase.instance.ref().child('humidity');

    // Listen to changes in temperature value
    _temperatureRef.onValue.listen((event) {
      setState(() {
        _temperature = event.snapshot.value.toString();
      });
    });
    _humidityRef.onValue.listen((event) {
      setState(() {
        _humidity = event.snapshot.value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) => {
                    print("Signed Out"),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen())),
                  });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Temperature: $_temperature",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              "Humidity: $_humidity",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
