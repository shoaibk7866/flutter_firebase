import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../google_auth_profile.dart';

class GoogleAuth extends StatefulWidget {
  const GoogleAuth({Key? key}) : super(key: key);

  @override
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {

  @override
  void initState() {
    Authentication.initializeFirebase(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Google Auth"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: GestureDetector(
        onTap: () async{
          User? user =
              await Authentication.signInWithGoogle(context: context);
          if (user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserInfoScreen(
                  user: user,
                ),
              ),
            );
          }
        },
        child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: const Center(
              child: Text(
                'Google Authentication',
                style: TextStyle(color: Colors.white),
              ),
            )),
      ),
    );
  }

}

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('SignOut =$e');
    }
  }

  static Future<void> initializeFirebase({required BuildContext context,}) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfoScreen(user: user),));
    }
  }

}
