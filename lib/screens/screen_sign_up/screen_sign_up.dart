// Crear cuenta

import 'package:cfa_coursesforall/screens/screen_sign_up/screen_sign_up_alumno.dart';
import 'package:cfa_coursesforall/screens/screen_sign_up/screen_sign_up_profesor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ScreenSingUp extends StatefulWidget{
  const ScreenSingUp({Key? key}) : super(key : key);

  @override
  ScreenSingUpState createState() => ScreenSingUpState();
}

class ScreenSingUpState extends State<ScreenSingUp>{
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final screens = [
      const SignUpAlumno(),
      const SignUpProfesor(),
    ];
    return Scaffold(
      appBar: headerBar(),
      body:  IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        currentIndex: selectedIndex,
        onTap: (int index){
             setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: "Crear Alumno",
            backgroundColor: colors.primary
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.supervisor_account),
            label: "Crear Profesor",
            backgroundColor: colors.primary
          ),
        ],
      ),
    );
  }
}

// Barra de arriba
PreferredSizeWidget headerBar() {
  return AppBar(
    title: Text("Crear cruenta"),

  );
}

