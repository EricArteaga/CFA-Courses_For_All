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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _colors = Theme.of(context).colorScheme;
    final _screens = [
      const SignUpAlumno(),
      const SignUpProfesor(),
    ];
    return Scaffold(
      appBar: headerBar(),
      body:  IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (int index){
             setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: "Crear Alumno",
            backgroundColor: _colors.primary
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.supervisor_account),
            label: "Crear Profesor",
            backgroundColor: _colors.primary
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

