import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_email_auth/firestore_home.dart';
import 'package:flutter_firebase_email_auth/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _success;
  late String _userEmail;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users"); //it create the root with the name of Users

  @override
  void initState() {
    _success = false;
    _userEmail = '';
    print('Current User=${getCurrentUserId()}');

    // checkUserLogin(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Firebase Email Auth"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      registerToFb();
                    }
                  },
                  child: const Text('Register'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {
                    _signInWithEmailAndPassword();
                  },
                  child: const Text('Login'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {
                    resetPassword(_emailController.text);
                  },
                  child: const Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerToFb() {
    _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((result) {
      dbRef.child(result.user!.uid).set({
        //for add single value use set() and for json object use set({})
        "email": _emailController.text,
        "age": _passwordController.text,
        "name": "Shoaib",
        "address": {"city": "Lahore", "country": "Pakistan"}
      }).then((res) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  void _signInWithEmailAndPassword() async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    final User user = result.user!;
    if (user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const FirestoreHome()));
    }
  }

  void resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> checkUserLogin({
    required BuildContext context,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const RegistrationScreen()));
    }
  }

  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }

}
