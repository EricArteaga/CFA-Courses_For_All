

import 'package:flutter/material.dart';

class signedIn extends StatefulWidget{
  const signedIn({Key? key, }) : super(key: key);

  @override
  State<signedIn> createState() => _signedInState();
}

class _signedInState extends State<signedIn> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // TODO: Hacer el Scaffold de cuando has hecho el login de la app
        body: Center(child: Text("Logged in"))
    );
  }
}