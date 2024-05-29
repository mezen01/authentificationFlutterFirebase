import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe/reusable_widget/reusable_widget.dart';
import 'package:pfe/utils/color.utils.dart';

class resetpassword extends StatefulWidget {
  const resetpassword({super.key});

  @override
  State<resetpassword> createState() => _resetpasswordState();
}

class _resetpasswordState extends State<resetpassword> {
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Couleur de la flèche de retour
          ),
          onPressed: () {
            Navigator.pop(context); // Retour à l'écran précédent
          },
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("696969"), // hedha couleur l gris
            hexStringToColor("332d4f"), // hedha l couleur l azra9
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Reset Password", () {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailTextController.text)
                      .then((value) => Navigator.of(context).pop());
                })
              ],
            ),
          ))),
    );
  }
}
