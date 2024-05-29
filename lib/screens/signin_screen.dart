import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe/reusable_widget/reusable_widget.dart';
import 'package:pfe/screens/home_screen.dart';
import 'package:pfe/screens/reset_password_screen.dart';
import 'package:pfe/screens/signup_screen.dart';
import 'package:pfe/utils/color.utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("696969"),
            hexStringToColor("332d4f"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : firebaseUIButton(context, "Sign In", _signIn),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  void _signIn() async {
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text;

    // Vérifier si les champs sont vides
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez saisir votre email et mot de passe.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Connexion réussie");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (error) {
      print("Erreur de connexion: $error");
      setState(() {
        if (error is FirebaseAuthException) {
          if (error.code == 'user-not-found') {
            _errorMessage = 'L\'e-mail n\'est pas enregistré.';
          } else if (error.code == 'wrong-password') {
            _errorMessage = 'Le mot de passe est incorrect.';
          } else {
            _errorMessage = 'Erreur : ${error.message}';
          }
        } else {
          _errorMessage = 'Une erreur s\'est produite.';
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

Widget forgetPassword(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 35,
    alignment: Alignment.bottomRight,
    child: TextButton(
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.right,
      ),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => resetpassword())),
    ),
  );
}
