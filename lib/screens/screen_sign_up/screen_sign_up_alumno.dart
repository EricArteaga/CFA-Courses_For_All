import 'package:cfa_coursesforall/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpAlumno extends StatefulWidget{
  const SignUpAlumno({Key? key}) : super(key : key);

  @override
  State<SignUpAlumno> createState() =>  _SignUpAlumnoState();
}

class _SignUpAlumnoState extends State<SignUpAlumno>{
  late String name, surnames, email, password, confirmPassword;

  // Valores del formulario
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _name = "";
  String _surnames = "";

  // Estado del formulario
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    // size ayuda a mantener una relación responsive con la pantalla
    final size = MediaQuery.of(context).size;

    Future crearCuenta() async{
      if (_name.isEmpty || _surnames.isEmpty || _email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Todos los campos son obligatorios"),
          ),
        );
      } else if (_password!= _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Las contraseñas no coinciden"),
          ),
        );
      } else if(!validateEmail(_email)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("El email es incorrecto"),
          ),
        );
      } else{
        // Creamos un mapa que guarda los campos
        Map<String, dynamic> alumno = <String, dynamic>{
          "name": _name,
          "surnames": _surnames,
          "email": _email,
          "password": _password,
        };

        // Lo guardamos en FireStore
        await createAlumno(alumno);
        FirebaseAuth.instance
            .userChanges()
            .listen((User? user) {
          if (user == null) {
            print('El usuario ya existía!');
          } else {
            print('El usuario ha sido creado con existo!');
          }
        });

      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
        child: Form (
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              const Text(
                "Crear cuenta para Alumno",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),

              ),
              SizedBox(height: 20,),
              TextFormField(
                onSaved: (value) {
                  if(value != null) {
                    _name = value;
                  }
                },
                validator: (value) {
                  if(value == null) {
                    return 'El nombre no puede estar vacio';
                  } else if(value.isEmpty) {
                    return 'El nombre no puede estar vacio';
                  } else {
                    return null;
                  };
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nombre",
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                onSaved: (value) {
                  if(value != null) {
                    _surnames = value;
                  }
                },
                validator: (value) {
                  if(value == null) {
                    return 'Los apellidos no puede estar vacio';
                  } else if(value.isEmpty) {
                    return 'Los apellidos no puede estar vacio';
                  } else {
                    return null;
                  };
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Apellidos",
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
                  labelText: "Correo electrónico",
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                onSaved: (value) {
                  if(value != null) {
                    _password = value;
                  }
                },
                validator: (value) {
                  if(value == null) {
                    return 'La contraseña no puede estar vacia';
                  } else if(value.isEmpty) {
                    return 'La contraseña no puede estar vacia';
                  } else {
                    return null;
                  };
                },
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Contraseña",
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                onSaved: (value) {
                  if(value != null) {
                    _confirmPassword = value;
                  }
                },
                validator: (value) {
                  if(value == null) {
                    return 'La contraseña no puede estar vacia';
                  } else if(value.isEmpty) {
                    return 'La contraseña no puede estar vacia';
                  } else {
                    return null;
                  };
                },
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Confirmar Contraseña",
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: crearCuenta,
                child: const Text("Crear Cuenta"),
                style: ElevatedButton.styleFrom(
                  maximumSize: Size(200,77),
                  minimumSize: Size(130,50),
                )
              )
            ]
          )
        )
      )
    );
  }
}

// Método para comprobar si el email es correto
bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern as String);
  return regex.hasMatch(value);
}

