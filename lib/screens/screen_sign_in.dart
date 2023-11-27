// Usar cuenta

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenSignIn extends StatefulWidget {
  const ScreenSignIn({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ScreenSignInState();
}
  class _ScreenSignInState extends State<ScreenSignIn>{
  @override
  Widget build(BuildContext context) {

    // size ayuda a mantener una relación responsive con la pantalla
    final size = MediaQuery.of(context).size;

    // Estado del formulario
    final formKey = new GlobalKey<FormState>();

    // Valores del formulario
    String _email = "";
    String _password = "";

    bool validateAndSave(){
      final form = formKey.currentState;
      dynamic val = form?.validate();
      if(val == true){
        form!.save();
        print('El formulario es válido.'+' Email: $_email, password: $_password');
      }else if(val == false) {
        print('El formulario es inválido.'+' Email: $_email, password: $_password');
      }
      return val;
    }

    signUserIn() async{
      if(validateAndSave()){
        // Se muestra el circulo de carga
        showDialog(
            context: context,
            builder: (context){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        );

        try{
          UserCredential userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _email.trim(),
              password: _password.trim()
          );
          print("ID del usuario iniciado: ${userCredentials.user!.uid}");
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
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Iniciar Sesión"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
        child: Form (
          key: formKey,
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
              TextFormField(
                onSaved: (value) {
                  if(value != null) {
                    _email = value;
                  }
                },
                validator: (value) {
                  if(value == null) {
                    return 'El Email no puede estar vacio';
                  } else if(value.isEmpty) {
                    return 'El Email no puede estar vacio';
                  } else {
                    return null;
                  };
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                onSaved:(value) {
                  if(value != null) {
                    _password = value;
                  }
                },
                obscureText: true,
                validator: (value) {
                  if(value == null) {
                    return 'La contraseña no puede estar vacia';
                  } else if(value.isEmpty) {
                    return 'La contraseña no puede estar vacia';
                  } else {
                    return null;
                  };
                },
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

