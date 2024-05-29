import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/home_screen.dart';
import 'package:pfe/utils/color.utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late DatabaseReference _temperatureRef;
  late DatabaseReference _humidityRef;
  late DatabaseReference _movementRef;

  String _temperature = "..";
  String _humidity = "..";
  bool _movement = false;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase database reference
    _temperatureRef = FirebaseDatabase.instance.ref().child('temperature');
    _humidityRef = FirebaseDatabase.instance.ref().child('humidity');
    _movementRef = FirebaseDatabase.instance.ref().child('mouvement');

    // Listen to changes in temperature value
    _temperatureRef.onValue.listen((event) {
      setState(() {
        _temperature = event.snapshot.value.toString().trim();
        print("Temperature updated: $_temperature"); // Debugging line
      });
    });
    _humidityRef.onValue.listen((event) {
      setState(() {
        _humidity = event.snapshot.value.toString().trim();
        print("Humidity updated: $_humidity"); // Debugging line
      });
    });
    _movementRef.onValue.listen((event) {
      setState(() {
        _movement = event.snapshot.value as bool;
        print("Movement updated: $_movement"); // Debugging line
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double? temperatureValue =
        double.tryParse(_temperature.replaceAll(RegExp(r'[^0-9.]'), ''));
    double? humidityValue =
        double.tryParse(_humidity.replaceAll(RegExp(r'[^0-9.]'), ''));

    print("Parsed temperature: $temperatureValue"); // Debugging line
    print("Parsed humidity: $humidityValue"); // Debugging line

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Notification",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("696969"),
          hexStringToColor("332d4f"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                if (temperatureValue != null) ...[
                  if (temperatureValue < 18)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Temperature is low',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ),
                    ),
                  if (temperatureValue > 25)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Temperature is high',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                    ),
                ] else
                  Text(
                    'Unable to retrieve temperature',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                if (humidityValue != null) ...[
                  if (humidityValue < 30)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Humidity is low',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ),
                    ),
                  if (humidityValue > 70)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Humidity is high',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                    ),
                ] else
                  Text(
                    'Unable to retrieve humidity',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                if (_movement)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Il y a une personne',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
