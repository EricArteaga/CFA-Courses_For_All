import 'package:cfa_coursesforall/screens/login_screen.dart';
import 'package:cfa_coursesforall/screens/screen_sign_up/screen_sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class noSignedIn extends StatefulWidget{
  const noSignedIn({Key? key, }) : super(key: key);

  @override
  State<noSignedIn> createState() => _noSignedInState();
}

class _noSignedInState extends State<noSignedIn> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerBar(),
      body: body(context),
    );
  }

// Barra de arriba
  PreferredSizeWidget headerBar() {
    return AppBar(
      title: const Text("CFA"),
    );
  }

// Body
  Widget body(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: const BoxDecoration(
            backgroundBlendMode: BlendMode.colorDodge,
            color: Colors.black
        ),
        child: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Icono de la aplicación
                    const Icon(
                        Icons.lock,
                        size: 100
                    ),

                    const SizedBox(height: 100,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: textoBienvenida(),
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: boton_sing_up(),
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: boton_sing_in(),
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }

  Widget textoBienvenida() {
    return const Text(
      "Bienvenido a Courses For All.", style: TextStyle(fontSize: 20),);
  }

// Boton Sing Up
  Widget boton_sing_up() {
    return ElevatedButton(child: Text("Crear cuenta",),
        style: estiloBoton(),
        onPressed: () => presionarSingUp());
  }

// Boton Sing In
  Widget boton_sing_in() {
    return ElevatedButton(child: Text("Iniciar sesión",),
        style: estiloBoton(),
        onPressed: () => presionarSingIn());
  }

// ? Acción de Boton Sing Up
  void presionarSingUp() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ScreenSingUp()));
  }

// ? Acción de Boton Sing In
  void presionarSingIn() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => login_screen()));
  }

// Style ButtonStyle
  ButtonStyle estiloBoton() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme
                .of(context)
                .colorScheme
                .primary
                .withOpacity(0.5);
          }
          return null; // Use the component's default.
        },
      ),
    );
  }
}