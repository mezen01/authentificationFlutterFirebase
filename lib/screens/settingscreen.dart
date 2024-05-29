import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe/screens/home_screen.dart';
import 'package:pfe/utils/color.utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  File? _profileImage;
  late String _profileImageUrl = '';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['username'];
          _roleController.text = userDoc['role'];
          _telController.text = userDoc['phone'];
          _profileImageUrl = userDoc['profileImage'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: const Text(
          "Setting",
          textAlign: TextAlign.center,
        ),
        backgroundColor: hexStringToColor("686167"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("696969"),
              hexStringToColor("332d4f"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : AssetImage('assets/images/placeholder.png')
                              as ImageProvider,
                ),
                SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: Text(
                    "Edit profile image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildFormField("Name", _nameController),
                      SizedBox(height: 10),
                      buildFormField("Role", _roleController),
                      SizedBox(height: 10),
                      buildFormField("Tel", _telController, isTel: true),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_isEditing) {
                            updateUser();
                          } else {
                            setState(() {
                              _isEditing = true;
                            });
                          }
                        },
                        child: Text(_isEditing
                            ? 'Enregistrer la modification'
                            : 'Modifier'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormField(String label, TextEditingController controller,
      {bool isEmail = false, bool isTel = false}) {
    return Row(
      children: [
        Container(
          width: 80,
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: _isEditing,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  void updateUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_profileImage != null) {
        // Téléchargez l'image mise à jour vers Firestore Storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(user.uid + '.jpg');
        await ref.putFile(_profileImage!);
        String newImageUrl = await ref.getDownloadURL();

        // Mettez à jour l'URL de l'image de profil dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'username': _nameController.text,
          'role': _roleController.text,
          'phone': _telController.text,
          'profileImage': newImageUrl,
        });
      } else {
        // Mettre à jour les autres informations sans l'image
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'username': _nameController.text,
          'role': _roleController.text,
          'phone': _telController.text,
        });
      }

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Modifications enregistrées avec succès!'),
      ));
    }
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }
}
