import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pfe/reusable_widget/reusable_widget.dart';
import 'package:pfe/screens/home_screen.dart';
import 'package:pfe/utils/color.utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _roleTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
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
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage('assets/images/placeholder.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Choisir une image"),
                ),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Role", Icons.person_outline, false,
                    _roleTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Phone Number", Icons.phone, false,
                    _phoneTextController,
                    keyboardType: TextInputType.number),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : firebaseUIButton(context, "Sign Up", _signUp)
              ],
            ),
          ))),
    );
  }

  void _signUp() async {
    // Vérifiez si toutes les informations nécessaires sont remplies
    if (_userNameTextController.text.isEmpty ||
        _emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty ||
        _roleTextController.text.isEmpty ||
        _phoneTextController.text.isEmpty) {
      // Affichez un message d'erreur si des informations sont manquantes
      Fluttertoast.showToast(
        msg: "Tous les champs doivent être remplis",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Affichez un indicateur de chargement
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential;
      User? user;

      // Créez l'utilisateur dans Firebase Auth avec l'URL de l'image
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      // Récupérez l'utilisateur créé
      user = userCredential.user;

      // Vérifiez si une image a été sélectionnée
      if (_image != null) {
        // Si oui, téléchargez l'image vers Firebase Storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(user!.uid + '.jpg');
        await ref.putFile(_image!);

        // Récupérez l'URL de téléchargement de l'image
        String imageUrl = await ref.getDownloadURL();

        // Enregistrez les données de l'utilisateur dans Firestore avec l'URL de l'image
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _userNameTextController.text,
          'email': _emailTextController.text,
          'role': _roleTextController.text,
          'phone': _phoneTextController.text,
          'profileImage':
              imageUrl, // Ajoutez l'URL de l'image dans les données de l'utilisateur
        });
      } else {
        // Si aucune image n'a été sélectionnée, enregistrez les données de l'utilisateur dans Firestore sans l'URL de l'image
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'username': _userNameTextController.text,
          'email': _emailTextController.text,
          'role': _roleTextController.text,
          'phone': _phoneTextController.text,
        });
      }

      // Affichez un message de succès
      Fluttertoast.showToast(
        msg: "Compte créé avec succès",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Naviguez vers l'écran d'accueil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      // Affichez un message d'erreur s'il y a eu une erreur lors de la création du compte
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      // Arrêtez l'indicateur de chargement
      setState(() {
        _isLoading = false;
      });
    }
  }
}
