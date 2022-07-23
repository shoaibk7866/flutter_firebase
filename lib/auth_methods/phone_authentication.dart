import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_email_auth/home_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);

  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final SmsAutoFill _autoFill = SmsAutoFill();

  @override
  void initState() {
    initializeFirebase(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Email Auth"),
      ),
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                  labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                  child: Text("Get current number"),
                  onPressed: () async =>
                      {_phoneNumberController.text = (await _autoFill.hint)!},
                  color: Colors.greenAccent[700]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                color: Colors.greenAccent[400],
                child: Text("Verify Number"),
                onPressed: () async {
                  verifyPhoneNumber();
                },
              ),
            ),
            TextFormField(
              controller: _smsController,
              decoration: const InputDecoration(labelText: 'Verification code'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                  color: Colors.greenAccent[200],
                  onPressed: () async {
                    signInWithPhone(_smsController.text);
                  },
                  child: Text("Sign in")),
            ),
          ],
        ));
  }

  void verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: _phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Sign the user in (or link) with the auto-generated credential
          //await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          verificationCode = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
        },
      );
    } on FirebaseAuthException catch (e) {
      print("Failed to Verify Phone Number: ${e.code}");
    }
  }

  void signInWithPhone(String code) async{
    String smsCode = code;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: smsCode
    );

    await _auth.signInWithCredential(credential).then((value){
      if (value.user != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      else {
        print("Please enter valid OTP");
      }
    });

  }

  Future<void> initializeFirebase({required BuildContext context,}) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

}
