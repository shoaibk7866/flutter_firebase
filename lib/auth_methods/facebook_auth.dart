import 'package:flutter/material.dart';

class FbAuthentication extends StatefulWidget {
  const FbAuthentication({Key? key}) : super(key: key);

  @override
  _FbAuthenticationState createState() => _FbAuthenticationState();
}

class _FbAuthenticationState extends State<FbAuthentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facebook Auth"),
      ),
    );
  }
}
