// Usar cuenta

import 'package:cfa_coursesforall/components/my_button.dart';
import 'package:cfa_coursesforall/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../tools/error_messages.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  @override
  Widget build(BuildContext context) {

    // size ayuda a mantener una relación responsive con la pantalla
    final size = MediaQuery.of(context).size;

    // Estado del formulario
    final formKey = GlobalKey<FormState>();

    // Valores del formulario
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // bool validateAndSave(){
    //   final form = formKey.currentState;
    //   dynamic val = form?.validate();
    //   if(val == true){
    //     form!.save();
    //     print('El formulario es válido.  Email: $_email, password: $_password');
    //   }else if(val == false) {
    //     print('El formulario es inválido. Email: $_email, password: $_password');
    //   }
    //   return val;
    // }

     signUserIn() async{}
    //   if(validateAndSave()){
    //     // Se muestra el circulo de carga
    //     showDialog(
    //         context: context,
    //         builder: (context){
    //           return const Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //     );
    //
    //     // TODO: Solucionar esto
    //     //  Cuando el email y la contraseña no son correctas tira el siguiente
    //     //  error:
    //     //  exception - The supplied auth credential is incorrect, malformed or
    //     //  has expired.
    //     // lo que hace que no muestre los mensajes de error...
    //     try{
    //       final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //           email: _email.trim(),
    //           password: _password.trim()
    //       );
    //       print("ID del usuario iniciado: ${userCredentials.user!.uid}");
    //       // Se quita el circulo de carga
    //       Navigator.pop(context);
    //     }on FirebaseAuthException catch(e) {
    //       // Se quita el circulo de carga
    //       Navigator.pop(context);
    //
    //       if(e.code == 'user-not-found'){
    //         wrongEmailMessage(context);
    //       }else if(e.code == "wrong-password"){
    //         wrongPasswordMessage(context);
    //       }
    //     }
    //   }
    // }

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
                const SizedBox(height: 10,),

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
                  controller: emailController,
                  obscureText: false,
                  labelText: "Email",
                ),

                const SizedBox(height: 10,),

                // Campo contraseña
                MyTextFormField(
                  controller: passwordController,
                  obscureText: true,
                  labelText: "Contraseña",
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
}

