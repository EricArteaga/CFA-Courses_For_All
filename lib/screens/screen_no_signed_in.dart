import 'dart:ui';

import 'package:cfa_coursesforall/components/my_button.dart';
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
      backgroundColor: Colors.grey[300],
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),

            // Logo
            CircleAvatar(
              radius: 100.0,
              backgroundColor: Colors.grey[500],
              backgroundImage: AssetImage('lib/images/Logo_CFA.png'),
            ),

            const SizedBox(height: 50,),

            Text("Bienvenido a ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10,),

            textoBienvenida(),

            const SizedBox(height: 25,),

            MyButton(
                text: "Crear Cuenta",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => ScreenSingUp()));
                }
            ),

            const SizedBox(height: 25,),

            MyButton(
                text: "Iniciar Sesión",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => login_screen()));
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget textoBienvenida() {
    return const Text(
      " Courses For All",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}