import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signedIn extends StatefulWidget{
  const signedIn({super.key });

  @override
  State<signedIn> createState() => _signedInState();
}

class _signedInState extends State<signedIn> {

  final user = FirebaseAuth.instance.currentUser!;

  //Datos del usuario
  //String _nombre = "";
  String _email = "";
  //String _foto = "";

  void obetenerDatosDelUsuario(){
    _email = user.email!;
    //_nombre = user.displayName!;
    //_foto = user.photoURL!;
    }

  @override
  Widget build(BuildContext context) {
    obetenerDatosDelUsuario();

    void signUserOut(){
      FirebaseAuth.instance.signOut();
    }
    // Barra de la app
    AppBar appBar(){
      return AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
        ],
      );
    }

    return Scaffold(
      appBar: appBar(),
      // TODO: Hacer el Scaffold de cuando has hecho el login de la app
      body: Center(child: Text("Logged in as:" + _email!))
    );
  }
}