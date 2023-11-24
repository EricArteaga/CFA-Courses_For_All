// Usar cuenta

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenSingIn extends StatelessWidget{
  const ScreenSingIn({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {

    // size ayuda a mantener una relación responsive con la pantalla
    final size = MediaQuery.of(context).size;

    // Controladores del formulario
    TextEditingController nameContoller =  TextEditingController(text:"");
    TextEditingController passwordController = TextEditingController(text:"");

    signUserIn() async{

      showDialog(
          context: context,
          builder: (context){
            return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );

      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: nameContoller.text,
            password: passwordController.text
        );
      }on FirebaseAuthException catch(e) {
        if(e.code == 'user-not-found'){
          print("No se ha encontrado ningun usuario con ese email");
        }else if(e.code == "wrong-password"){
          print("La contraseña es incorrecta");
        }
      }

      // pop the loading circle
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Iniciar Sesión"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
        child: Center (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              const Text(
                "Iniciar Sesión",
                style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),

              ),
              SizedBox(height: 20,),
              TextField(
                controller: nameContoller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Contraseña",
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: signUserIn, child: Text("Sign in"))
            ]
          )
        )
      )
    );
  }
}

