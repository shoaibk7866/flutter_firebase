import 'package:flutter/material.dart';
import 'package:flutter_firebase_email_auth/auth_methods/facebook_auth.dart';
import 'package:flutter_firebase_email_auth/auth_methods/phone_authentication.dart';
import 'package:flutter_firebase_email_auth/auth_methods/registration_screen.dart';

import 'auth_methods/google_auth.dart';

class AuthOptions extends StatefulWidget {
  const AuthOptions({Key? key}) : super(key: key);

  @override
  _AuthOptionsState createState() => _AuthOptionsState();
}

class _AuthOptionsState extends State<AuthOptions> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Email Auth"),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
            },
            child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
                ),
                child:  const Center(
                  child: Text('Email and Password',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                )),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PhoneAuthentication()));
            },
            child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
                ),
                child:  const Center(
                  child: Text('Phone Authentication',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                )),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GoogleAuth()));
            },
            child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:  const Center(
                  child: Text('Google Authentication',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                )),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FbAuthentication()));
            },
            child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:  const Center(
                  child: Text('Facebook Authentication',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

}
