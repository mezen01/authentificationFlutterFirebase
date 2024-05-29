import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/Generalenergie_screen.dart';
import 'package:pfe/screens/documentationScreen.dart';
import 'package:pfe/screens/notificationScreen.dart';
import 'package:pfe/screens/settingscreen.dart';
import 'package:pfe/screens/signin_screen.dart';
import 'package:pfe/screens/tipsScreen.dart';
import 'package:pfe/utils/color.utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? user = FirebaseAuth.instance.currentUser;
  String _profileImageUrl = '';

  late DatabaseReference _temperatureRef;
  late DatabaseReference _humidityRef;

  late String _temperature = "..";
  late String _humidity = "..";

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
    loadData();
  }

  void loadData() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _profileImageUrl = userDoc['profileImage'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final circleSize = screenSize.width * 0.4;
    final largeCircleSize = screenSize.width * 0.6;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: hexStringToColor("686167"),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundhome.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _buildLargeCircleWithIcon(
              icon: Icons.power,
              value: '$_temperature KW',
              size: largeCircleSize,
              onTap: () {
                // Ajoutez ici le code pour naviguer vers la nouvelle page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Generalenergiescreen()),
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleWithIcon(
                  icon: Icons.thermostat,
                  value: '$_temperature°C',
                  size: circleSize,
                ),
                SizedBox(width: 20),
                _buildCircleWithIcon(
                  icon: Icons.opacity,
                  value: '$_humidity%',
                  size: circleSize,
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildLiveConsumptionCard(
                '$_temperature KW', '$_humidity KW'), // Ajout de la carte
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: hexStringToColor("686167"),
              ),
              child: Center(
                child: ClipOval(
                  child: _profileImageUrl.isNotEmpty
                      ? Image.network(
                          _profileImageUrl,
                          width: 120, // Taille de l'image
                          height: 120, // Taille de l'image
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/placeholder.png', // Chemin de l'image par défaut
                          width: 120, // Taille de l'image
                          height: 120, // Taille de l'image
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            ListTile(
              title: Text('Energy efficency Tips'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TipsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Documentation and Ressources'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocumentationScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
            ),
            Divider(), // Ajout d'une ligne de séparation
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Ajoutez ici le code pour la déconnexion
                FirebaseAuth.instance.signOut().then((value) => {
                      print("Signed Out"),
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      ),
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeCircleWithIcon({
    required IconData icon,
    required String value,
    required double size,
    required Function() onTap, // Nouveau paramètre pour la fonction onTap
  }) {
    return GestureDetector(
      onTap: onTap, // Appel de la fonction onTap lorsque le cercle est cliqué
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hexStringToColor("171d98"),
          border: Border.all(
            color: hexStringToColor("607eff"),
            width: 15,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: size * 0.4,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Text(
                value,
                overflow: TextOverflow.ellipsis, // Limite le texte
                maxLines: 1, // Limite à une seule ligne
                style: TextStyle(fontSize: size * 0.2, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleWithIcon({
    required IconData icon,
    required String value,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size * 0.4,
              color: Colors.white,
            ),
            SizedBox(height: 5),
            Text(
              value,
              overflow: TextOverflow.ellipsis, // Limite le texte
              maxLines: 1, // Limite à une seule ligne
              style: TextStyle(fontSize: size * 0.2, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveConsumptionCard(String value1, String value2) {
    return Card(
      color: Colors.grey, // Couleur de fond gris
      margin: EdgeInsets.symmetric(horizontal: 20), // Marge horizontale
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Live Consommation",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildConsumptionItem("Current usage", value1),
                _buildConsumptionItem("Total today", value2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Alignement horizontal au centre
          children: [
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
