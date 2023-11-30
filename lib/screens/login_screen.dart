// Usar cuenta

import 'package:cfa_coursesforall/components/my_button.dart';
import 'package:cfa_coursesforall/components/my_textfield.dart';
import 'package:cfa_coursesforall/components/my_wrong_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {

    // size ayuda a mantener una relación responsive con la pantalla
    //final size = MediaQuery.of(context).size;

    // Estado del formulario
    final formKey = GlobalKey<FormState>();

    // Valores del formulario
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    bool validateAndSave(){
      final form = formKey.currentState;
      dynamic val = form?.validate();
      if(val == true){
        form!.save();
        print('El formulario es válido.  Email: ${_emailController.text}, password: ${_passwordController.text}');
      }else if(val == false) {
        print('El formulario es inválido. Email: ${_emailController.text}, password: ${_passwordController.text}');
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

        // TODO: Solucionar esto
        // Cuando el email y la contraseña no son correctas tira el siguiente
        // error:
        // exception - The supplied auth credential is incorrect, malformed or
        // has expired.
        // lo que hace que no muestre los mensajes de error...
        try{
          final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim()
          );
          print("ID del usuario iniciado: ${userCredentials.user!.uid}");
          // Se quita el circulo de carga
          Navigator.pop(context);
        }on FirebaseAuthException catch(e) {
          // Se quita el circulo de carga
          Navigator.pop(context);

          if(e.code == "user-not-found"){
            wrongEmailMessage();
          }else if(e.code == "wrong-password"){
            wrongPasswordMessage();
          }else if(e.code == "invalid-email"){
            invalidMessageMessage();
          }else if(e.code == "invalid-credential"){
            invalidCredentialMessage();
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          //padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
          child: Form (
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                const SizedBox(height: 50,),

                // Logo
                CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.grey[500],
                  backgroundImage: AssetImage('lib/images/Logo_CFA.png'),
                ),

                const SizedBox(height: 10,),

                // Texto de presentación
                const Text(
                  "Te echabamos de menos,",
                  style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "¡es un placer tenerte de vuelta!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10,),

                // Campo email
                MyTextFormField(
                  controller: _emailController,
                  autofocus: true,
                  labelText: "Email",
                  onSaved: (value) {
                    if(value != null) {
                      _emailController.text = value;
                    }
                  },
                  validator: (value) {
                    if(value == null) {
                      return 'El Email no puede estar vacio';
                    } else if(value.isEmpty) {
                      return 'El Email no puede estar vacio';
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 10,),

                // Campo contraseña
                MyTextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  labelText: "Contraseña",
                  onSaved: (value) {
                    if(value != null) {
                      _passwordController.text = value;
                    }
                  },
                  validator: (value) {
                    if(value == null) {
                      return 'La contraseña no puede estar vacio';
                    } else if(value.isEmpty) {
                      return 'La contraseña no puede estar vacio';
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 15,),

                // ¿Se ha olvidado la contraseña?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '¿Se te ha olvidado la contraseña?',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                        )
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25,),

                // Botón de iniciar sesión
                MyButton(
                    text: "Iniciar sesión",
                    onTap: signUserIn,
                ),
              ]
            )
          )
        ),
      )
    );
  }

  // Los errores están declarados aquí en vez de en el método signUserIn
  // por la recomendación:
  // <<Don't use 'BuildContext's across async gaps>>
  // Esto se debe a que se necesita el BuildContext de la ventana para enseñar
  // el mensaje de error.


  // Mensaje de email incorrecto
  void wrongEmailMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Email incorrecto",
              content: "Por favor, introduce un email que pertenezca a una cuenta"
          );
        }
    );
  }

  void wrongPasswordMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Email incorrecto",
              content: "Por favor, introduce un email que pertenezca a una cuenta"
          );
        }
    );
  }

  void invalidMessageMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Email invalido",
              content: "El email es invalido, asegurate que lo has escrito bien"
          );
        }
    );
  }

  void invalidCredentialMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Vaya... invalid-credential",
              content: "Si te ha salido esto es porque ha saltado un error de "
                  "invalid-credential, un error provocado por algo desconocido "
                  "a los conocimientos del programador ;-;"
          );
        }
    );
  }
}

