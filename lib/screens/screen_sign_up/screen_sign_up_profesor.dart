import 'package:flutter/material.dart';

class SignUpProfesor extends StatefulWidget{
  const SignUpProfesor({Key? key}) : super(key : key);

  @override
  State<SignUpProfesor> createState() =>  _SignUpProfesorState();
}

class _SignUpProfesorState extends State<SignUpProfesor>{

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Center (
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Crear cuenta para Profesor",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nombre",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Correo",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Contraseña",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirmar Contraseña",
                    ),
                  ),
                  SizedBox(height: 20),
                ]
            )
        )
    );
  }
}