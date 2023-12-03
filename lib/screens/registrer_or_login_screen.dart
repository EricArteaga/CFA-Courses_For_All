// Usar cuenta

import 'package:cfa_coursesforall/components/my_button.dart';
import 'package:cfa_coursesforall/components/my_textfield.dart';
import 'package:cfa_coursesforall/components/my_wrong_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class RegistrerOrLoginScreen extends StatefulWidget {
  const RegistrerOrLoginScreen({super.key});

  @override
  State<RegistrerOrLoginScreen> createState() => _RegistrerOrLoginScreenState();
}

class _RegistrerOrLoginScreenState extends State<RegistrerOrLoginScreen> {

  // Estados del formulario
  final formKeyLogin = GlobalKey<FormState>();
  final formKeySignUpAlumno = GlobalKey<FormState>();
  final formKeySignUpProfesor = GlobalKey<FormState>();

  // Valores del formulario Login
  final _emailLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();

  // Valores del formulario Sign Up Alumno
  final _nameSUAlumnoController = TextEditingController();
  final _surnamesSUAlumnoController = TextEditingController();
  final _emailSUAlumnoController = TextEditingController();
  final _passwordSUAlumnoController = TextEditingController();
  final _confirmPasswordSUAlumnoController = TextEditingController();


  // Valores del formulario Sign Up Alumno
  final _nameSUProfesorController = TextEditingController();
  final _surnamesSUProfesorController = TextEditingController();
  final _emailSUProfesorController = TextEditingController();
  final _passwordSUProfesorController = TextEditingController();
  final _confirmPasswordSUProfesorController = TextEditingController();

  // Ventanas de SignUp
  late List<Widget> _screens;

  // Variable que cambia las ventanas
  String indexSccafold = "";

  @override
  void initState() {
    super.initState();
    _screens = [signUpAlumnoWidget(), signUpProfesorWidget()];
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        print('No hay usuario iniciado!');
      } else {
        print('El usuario ha iniciado con exito!');
      }
    });
    // size ayuda a mantener una relación responsive con la pantalla
    //final size = MediaQuery.of(context).size;

    switch(indexSccafold){
      case "Login":
        return loginScaffold();
        break;
      case "SignUpAlumno":
        return signUpSccafold();
        break;
      default:
        return loginScaffold();
        break;
    }
  }

  // Region Login
  /*
   *  Scaffold del Login
   */
  Scaffold loginScaffold() {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            //padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
              child: Form(
                  key: formKeyLogin,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50,),

                        // Logo
                        CircleAvatar(
                          radius: 100.0,
                          backgroundColor: Colors.grey[500],
                          backgroundImage: const AssetImage(
                              'lib/images/Logo_CFA.png'),
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
                          controller: _emailLoginController,
                          autofocus: true,
                          labelText: "Email",
                          onSaved: (value) {
                            if (value != null) {
                              _emailLoginController.text = value;
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'El Email no puede estar vacio';
                            } else if (value.isEmpty) {
                              return 'El Email no puede estar vacio';
                            } else {
                              return null;
                            }
                          },
                        ),

                        const SizedBox(height: 10,),

                        // Campo contraseña
                        MyTextFormField(
                          controller: _passwordLoginController,
                          obscureText: true,
                          labelText: "Contraseña",
                          onSaved: (value) {
                            if (value != null) {
                              _passwordLoginController.text = value;
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'La contraseña no puede estar vacia';
                            } else if (value.isEmpty) {
                              return 'La contraseña no puede estar vacia';
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
                          onTap: LoginUser,
                        ),

                        const SizedBox(height: 25,),

                        // Barra con una o
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                      thickness: 1.0,
                                      color: Colors.grey[400],
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "¿Aún no te has registrado?",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                      thickness: 1.0,
                                      color: Colors.grey[400],
                                    )
                                ),
                              ]
                          ),
                        ),

                        const SizedBox(height: 25,),

                        // Botón de iniciar sesión
                        MyButton(
                          text: "Crear cuenta",
                          onTap: () {
                            setState(() => indexSccafold = "SignUpAlumno");
                          },
                        ),
                      ]
                  )
              )
          ),
        )
    );
  }


  // Método que valida el estado del formulario
  bool validateAndSaveLogin() {
    final form = formKeyLogin.currentState;
    dynamic val = form?.validate();

    // Muestro mensajes por consola para que se pueda apreciar el estado de
    // validación sin hacer un debug
    if (val == true) {
      form!.save();
      print('El formulario es válido.  Email: ${_emailLoginController
          .text}, password: ${_passwordLoginController.text}');
    } else if (val == false) {
      print('El formulario es inválido. Email: ${_emailLoginController
          .text}, password: ${_passwordLoginController.text}');
    }
    return val;
  }

  LoginUser() async {
    if (validateAndSaveLogin()) {
      // Se muestra el circulo de carga
      showDialog(
          context: context,
          builder: (context) {
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
      try {
        final userCredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _emailLoginController.text.trim(),
            password: _passwordLoginController.text.trim()
        );
        print("ID del usuario iniciado: ${userCredentials.user?.uid}");
        // Se quita el circulo de carga
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Se quita el circulo de carga
        Navigator.pop(context);

        if (e.code == "user-not-found") {
          wrongEmailMessage();
        } else if (e.code == "wrong-password") {
          wrongPasswordMessage();
        } else if (e.code == "invalid-email") {
          invalidMessageMessage();
        } else if (e.code == "invalid-credential") {
          invalidCredentialMessage();
        }
      }
    }
  }

  // End Login
  // Region Sign Up
  int _selectedIndex = 0;

  Scaffold signUpSccafold() {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: headerBarSignUp(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Crear Alumno",
              backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account),
              label: "Crear Profesor",
              backgroundColor: Colors.black
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget headerBarSignUp() {
    return AppBar(
      title: CircleAvatar(
        radius: 26.0,
        backgroundColor: Colors.grey[500],
        backgroundImage: const AssetImage('lib/images/Logo_CFA.png'),
      ),
      centerTitle: true,
      backgroundColor: Colors.grey[300],
      leading: IconButton(
          onPressed:(){
            setState(() => indexSccafold = "Login");
          },
          icon: const Icon(Icons.arrow_back)),
    );
  }

  // End Sign Up
  // Region sign up Alumno
  Widget signUpAlumnoWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
          child: Form(
              key: formKeySignUpAlumno,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 20,),

                    // Texto crear cuenta
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Crear cuenta para",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Alumno",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    // Campo nombre
                    MyTextFormField(
                      controller: _nameSUAlumnoController,
                      labelText: "Nombre",
                      onSaved: (value) {
                        if (value != null) {
                          _nameSUAlumnoController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'El nombre no puede estar vacio';
                        } else if (value.isEmpty) {
                          return 'El nombre no puede estar vacio';
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: 10,),

                    // Campo apellidos
                    MyTextFormField(
                      controller: _surnamesSUAlumnoController,
                      labelText: "Apellidos",
                      onSaved: (value) {
                        if (value != null) {
                          _surnamesSUAlumnoController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Los apellidos no puede estar vacios';
                        } else if (value.isEmpty) {
                          return 'Los apellidos no puede estar vacios';
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: 10,),

                    // Campo email
                    MyTextFormField(
                      controller: _emailSUAlumnoController,
                      labelText: "Email",
                      onSaved: (value) {
                        if (value != null) {
                          _emailSUAlumnoController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'El Email no puede estar vacio';
                        } else if (value.isEmpty) {
                          return 'El Email no puede estar vacio';
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: 10,),

                    MyTextFormField(
                      controller: _passwordSUAlumnoController,
                      labelText: "Contraseña",
                      obscureText: true,
                      onSaved: (value) {
                        if (value != null) {
                          _passwordSUAlumnoController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'La contraseña no puede estar vacia';
                        } else if (value.isEmpty) {
                          return 'La contraseña no puede estar vacia';
                        } else {
                          return null;
                        }
                      },

                    ),

                    const SizedBox(height: 10,),

                    // Campo confirmar la contraseña
                    MyTextFormField(
                      controller: _confirmPasswordSUAlumnoController,
                      labelText: "Confirmar contraseña",
                      obscureText: true,
                      onSaved: (value) {
                        if (value != null) {
                          _confirmPasswordSUAlumnoController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'La contraseña no puede estar vacia';
                        } else if (value.isEmpty) {
                          return 'La contraseña no puede estar vacia';
                        } else {
                          return null;
                        }
                      },

                    ),

                    const SizedBox(height: 30,),

                    // Boton de crear cuenta
                    MyButton(
                      text: "Crear cuenta",
                      onTap: crearCuentaAlumno,
                    ),
                  ]
              )
          )
      ),
    );
  }

  /*
   * Método que valida el estado del formulario
   */
  bool validateAndSaveSignUpAlumno() {
    final form = formKeySignUpAlumno.currentState;
    dynamic val = form?.validate();

    // Muestro mensajes por consola para que se pueda apreciar el estado de
    // validación sin hacer un debug
    if (val == true) {
      form!.save();
      print('El formulario es válido.');
    } else if (val == false) {
      print('El formulario es inválido.');
    }
    return val;
  }

  /*
   * Método que crea una cuenta en Authentication y luego un doc. en la colección
   * de alumnos.
   */
  Future crearCuentaAlumno() async {
    if (validateAndSaveSignUpAlumno()) {
      // Se muestra el circulo de carga
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );

      // Se comprueban las contraseñas
      if ((_passwordSUAlumnoController.text == "") ||
          (_confirmPasswordSUAlumnoController.text == "") ||
          (_passwordSUAlumnoController.text != _confirmPasswordSUAlumnoController.text)) {
        Navigator.pop(context);
        dontMatchPasswordsMessage();


        // Se comprueba el email
      } else if (!validateEmail(_emailSUAlumnoController.text.trim())) {
        Navigator.pop(context);
        wrongEmailMessage();
      } else {
        // Creamos un mapa que guarda los campos
        Map<String, dynamic> alumno = <String, dynamic>{
          "name": _nameSUAlumnoController.text.trim(),
          "surnames": _surnamesSUAlumnoController.text.trim(),
          "email": _emailSUAlumnoController.text.trim(),
          "password": _passwordSUAlumnoController.text.trim(),
        };

        // TODO: Hacer que el email introducido sea un valido real
        /*
          (En una de las prueba se introdujo manuelisorna@gmail.comskeje como email
          y se dio por válido.)
         */
        try {
          // Se crea un User con el Authentication
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: _emailSUAlumnoController.text.trim(),
            password: _passwordSUAlumnoController.text.trim(),
          );

          /*
            Se crea en la colección alumno un usuario con sus datos del fomulario,
            y lo más importante, con un ID del documento igual al ID de usuario
            del Authentication.
          */
          // TODO: Implementar con userCredential.additionalUserInfo.isNewUser un método que te muestre un mensaje de nuevo usuario al iniciar la aplicación
          String? uid = userCredential.user?.uid;
          await createAlumno(alumno, uid);
          Navigator.pop(context);

        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);

          if (e.code == 'weak-password') {
            weakPasswordMessage();
          } else if (e.code == 'email-already-in-use') {
            alreadyExistsUserMessage();
          }
        }
      }
    }
  }

  // End  sign up Alumno
  // Region sign up Profesor
  Widget signUpProfesorWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
          child: Form(
              key: formKeySignUpProfesor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 20,),

                    // Texto crear cuenta
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Crear cuenta para",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Profesor",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    // Campo nombre
                    MyTextFormField(
                      controller: _nameSUProfesorController,
                      labelText: "Nombre",
                      onSaved: (value) {
                        if (value != null) {
                          _nameSUProfesorController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'El nombre no puede estar vacio';
                        } else if (value.isEmpty) {
                          return 'El nombre no puede estar vacio';
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: 10,),

                    // Campo apellidos
                    MyTextFormField(
                      controller: _surnamesSUProfesorController,
                      labelText: "Apellidos",
                      onSaved: (value) {
                        if (value != null) {
                          _surnamesSUProfesorController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Los apellidos no puede estar vacios';
                        } else if (value.isEmpty) {
                          return 'Los apellidos no puede estar vacios';
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: 10,),

                    // Campo email
                    MyTextFormField(
                      controller: _emailSUProfesorController,
                      labelText: "Email",
                      onSaved: (value) {
                        if (value != null) {
                          _emailSUProfesorController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'El Email no puede estar vacio';
                        } else if (value.isEmpty) {
                          return 'El Email no puede estar vacio';
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: 10,),

                    // Campo contraseña
                    MyTextFormField(
                      controller: _passwordSUProfesorController,
                      labelText: "Contraseña",
                      obscureText: true,
                      onSaved: (value) {
                        if (value != null) {
                          _passwordSUProfesorController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'La contraseña no puede estar vacia';
                        } else if (value.isEmpty) {
                          return 'La contraseña no puede estar vacia';
                        } else {
                          return null;
                        }
                      },

                    ),

                    const SizedBox(height: 10,),

                    // Campo confirmar la contraseña
                    MyTextFormField(
                      controller: _confirmPasswordSUProfesorController,
                      labelText: "Confirmar contraseña",
                      obscureText: true,
                      onSaved: (value) {
                        if (value != null) {
                          _confirmPasswordSUAlumnoController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'La contraseña no puede estar vacia';
                        } else if (value.isEmpty) {
                          return 'La contraseña no puede estar vacia';
                        } else {
                          return null;
                        }
                      },

                    ),

                    SizedBox(height: 30,),

                    // Boton de crear cuenta
                    MyButton(
                      text: "Crear cuenta",
                      onTap: crearCuentaProfesor,
                    ),
                  ]
              )
          )
      ),
    );
  }

  /*
   * Método que valida el estado del formulario
   */
  bool validateAndSaveSignUpProfesor() {
    final form = formKeySignUpProfesor.currentState;
    dynamic val = form?.validate();

    // Muestro mensajes por consola para que se pueda apreciar el estado de
    // validación sin hacer un debug
    if (val == true) {
      form!.save();
      print('El formulario es válido.');
    } else if (val == false) {
      print('El formulario es inválido.');
    }
    return val;
  }

  /*
   * Método que crea una cuenta en Authentication y luego un doc. en la colección
   * de profesores.
   */
  Future crearCuentaProfesor() async {
    if (validateAndSaveSignUpProfesor()) {
      // Se muestra el circulo de carga
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );

      // Se comprueban las contraseñas
      if ((_passwordSUProfesorController.text == "") ||
          (_confirmPasswordSUProfesorController.text == "") ||
          (_passwordSUProfesorController.text != _confirmPasswordSUProfesorController.text)) {
        Navigator.pop(context);
        dontMatchPasswordsMessage();

        // Se comprueba el email
      } else if (!validateEmail(_emailSUProfesorController.text.trim())) {
        Navigator.pop(context);
        wrongEmailMessage();

      } else {
        // Creamos un mapa que guarda los campos
        Map<String, dynamic> profesor = <String, dynamic>{
          "name": _nameSUProfesorController.text.trim(),
          "surnames": _surnamesSUProfesorController.text.trim(),
          "email": _emailSUProfesorController.text.trim(),
          "password": _passwordSUProfesorController.text.trim(),
        };

        // TODO: Hacer que el email introducido sea un valido real
        /*
          (En una de las prueba se introdujo manuelisorna@gmail.comskeje como email
          y se dio por válido.)
         */
        try {
          // Se crea un User con el Authentication
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: _emailSUProfesorController.text.trim(),
            password: _passwordSUProfesorController.text.trim(),
          );

          /*
            Se crea en la colección alumno un usuario con sus datos del fomulario,
            y lo más importante, con un ID del documento igual al ID de usuario
            del Authentication.
          */
          // TODO: Implementar con userCredential.additionalUserInfo.isNewUser un método que te muestre un mensaje de nuevo usuario al iniciar la aplicación
          String? uid = userCredential.user?.uid;
          await createProfesor(profesor, uid);
          Navigator.pop(context);

        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);

          if (e.code == 'weak-password') {
            weakPasswordMessage();
          } else if (e.code == 'email-already-in-use') {
            alreadyExistsUserMessage();
          }
        }
      }
    }
  }
  // End sign up Profesor
  // Region Mensajes de error y métodos funcionales
  // Método para comprobar si el email es correto
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    return regex.hasMatch(value);
  }

  /*
   *   Los errores están declarados aquí en vez de en el método signUserIn
   *   por la recomendación:
   *   <<Don't use 'BuildContext's across async gaps>>
   *   Esto se debe a que se necesita el BuildContext de la ventana para enseñar
   *   el mensaje de error.
   */

  // Mensaje de email incorrecto
  void wrongEmailMessage() {
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

  void wrongPasswordMessage() {
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

  void invalidMessageMessage() {
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

  void invalidCredentialMessage() {
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

  // Mensaje de las contraseñas no coinciden
  void dontMatchPasswordsMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Las contraseñas no coinciden",
              content: "Las contraseñas deben coincidir"
          );
        }
    );
  }

  // Mensaje de campos obligatorios
  void alreadyExistsUserMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Email ya en uso",
              content: "Ya existe una cuenta con ese email"
          );
        }
    );
  }

  // Mensaje de campos obligatorios
  void weakPasswordMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Contraseña debil",
              content: "La contraseña es demasiado debil"
          );
        }
    );
  }
}
// End Mensajes de error y métodos funcionales