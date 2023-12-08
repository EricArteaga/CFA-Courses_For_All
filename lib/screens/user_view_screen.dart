import 'dart:io';

import 'package:cfa_coursesforall/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_image_field.dart';
import '../components/my_textfield.dart';
import '../components/my_wrong_message.dart';
import '../services/image_manager_service.dart';

class UserViewScreen extends StatefulWidget {

  // Tipo de usuario
  final String userType;

  const UserViewScreen({
    super.key,
    required this.userType,
  });

  @override
  State<UserViewScreen> createState() => _UserViewScreenState();
}

class _UserViewScreenState extends State<UserViewScreen> {

  // Usuario que tiene la sesión iniciada
  final user = FirebaseAuth.instance.currentUser!;

  // Estados del formulario
  final formKeyUserView = GlobalKey<FormState>();

  // Valores del formulario Sign Up Alumno
  final _userNameController = TextEditingController();
  final _userSurnamesController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _confirmUserPasswordController = TextEditingController();

  File? _selectedImageFile;
  String _userImageURL = "";

  @override
  void initState() {
    super.initState();

    // Se cargan los datos de los campos
      downloadUserValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: headerBarUserView(),
      body: userViewBody(),

    );
  }

  // Barra del encabezado de la vista del usuario
  PreferredSizeWidget headerBarUserView() {
    return AppBar(
      title: CircleAvatar(
        radius: 26.0,
        backgroundColor: Colors.grey[500],
        backgroundImage: const AssetImage('lib/images/Logo_CFA.png'),
      ),
      centerTitle: true,
      backgroundColor: Colors.grey[300],
    );
  }

  Widget userViewBody(){
    return SafeArea(
      child: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
          child: Form(
              key: formKeyUserView,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 20,),

                    // Texto crear cuenta
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Modificar cuenta",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    // Campo nombre
                    MyTextFormField(
                      controller: _userNameController,
                      labelText: "Nombre",
                      onSaved: (value) {
                        if (value != null) {
                          _userNameController.text = value;
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
                      controller: _userSurnamesController,
                      labelText: "Apellidos",
                      onSaved: (value) {
                        if (value != null) {
                          _userSurnamesController.text = value;
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
                      controller: _userEmailController,
                      labelText: "Email",
                      onSaved: (value) {
                        if (value != null) {
                          _userEmailController.text = value;
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
                      controller: _userPasswordController,
                      labelText: "Contraseña",
                      obscureText: true,
                      onSaved: (value) {
                        if (value != null) {
                          _userPasswordController.text = value;
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
                      controller: _confirmUserPasswordController,
                      labelText: "Confirmar contraseña",
                      obscureText: true,
                      onSaved: (value) {
                        if (value != null) {
                          _confirmUserPasswordController.text = value;
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

                    MyImageField(
                      image: _userImageURL,
                      enabled: true,
                      getSelectedImage: (File? selectedImage) {
                        _selectedImageFile = selectedImage;
                      },
                    ),

                    const SizedBox(height: 30,),

                    // Boton de crear cuenta
                    MyButton(
                      text: "Modificar Cuenta",
                      onTap: editUser,
                    ),
                  ]
              )
          )
      ),
    );
  }

  // Método que te carga los datos del curso
  Future downloadUserValues() async{
    Map<String, dynamic>? userData;

    // Note: La imagen es tratada por MyImageField

    // TODO: Cargar datos de la colección
    if(widget.userType == "profesor"){
      userData = await getProfesorById(user.uid);

    // widget.userType == "alumno"
    }else{
      userData = await getAlumnoById(user.uid);
    }

    // Obtener datos
    String name = userData?["name"] ?? "";
    String surnames = userData?["surnames"] ?? "";
    String email = user.email ?? "";
    String password = userData?["password"] ?? "";
    String imageURL = userData?["imageURL"] ?? "";

    // Asignar valores a los controladores
    _userNameController.text = name;
    _userSurnamesController.text = surnames;
    _userEmailController.text = email;
    _userPasswordController.text = password;
    _userImageURL = imageURL;

    setState(() {});
  }

  // Método que valida los campos del formulario de la cuenta
  bool validateAndSaveUser() {
    final form = formKeyUserView.currentState;
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

  // Método para modficar la cuenta
  Future editUser() async{
    if(validateAndSaveUser()){
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
      if ((_userPasswordController.text == "") ||
          (_confirmUserPasswordController.text == "") ||
          (_userPasswordController.text != _confirmUserPasswordController.text)) {
        Navigator.pop(context);
        dontMatchPasswordsMessage();

      // Se comprueba que la contraseña no sea debil
      } else if(_userPasswordController.text.length > 6){
        Navigator.pop(context);
        weakPasswordMessage();

        // Se comprueba el email
      } else if (!validateEmail(_userEmailController.text.trim())) {
        Navigator.pop(context);
        wrongEmailMessage();
      } else {
        try {
          /*
         * Se sube la imagen al storage y se obtiene la url de donde está, para
         * pasarlo como parametro al curso.
         */
          String? imageURL;
          // Se comprueba si se ha seleccionado una imagen y se guarda
          if (_selectedImageFile != null) {
            imageURL = await uploadUserImage(_selectedImageFile);

            // Si no, se guarda la que ya estaba
          } else {
            imageURL = _userImageURL;
          }

          // Creamos un mapa que guarda los campos
          Map<String, dynamic> editedUser = <String, dynamic>{
            "name": _userNameController.text.trim(),
            "surnames": _userSurnamesController.text.trim(),
            "password": _userPasswordController.text.trim(),
            "imageURL": imageURL,
          };

          /*
         * Se actualiza en la colección del tipo de usuario un usuario con sus datos
         * del fomulario
         */
          if (widget.userType == "profesor") {
            Navigator.pop(context);
            await updateProfesor(user.uid, editedUser);

            // widget.userType == "alumno"
          } else {
            Navigator.pop(context);
            await updateAlumno(user.uid, editedUser);
          }
          String uid = FirebaseAuth.instance.currentUser!.uid;

          // Actualizar el correo electrónico del usuario en Authentication
          await FirebaseAuth.instance.currentUser!.updateEmail(_userEmailController.text.trim());

          // Actualiza el usuario en Authentication
          await FirebaseAuth.instance.currentUser!.updatePassword(_userPasswordController.text.trim());

        } on FirebaseAuthException catch (e) {

          if (e.code == 'weak-password') {
            weakPasswordMessage();
          } else if(e.code == 'invalid-email'){
            invalidEmailMessage();
          }
        }
      }
    }
  }

  // Método para comprobar si el email es correto
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    return regex.hasMatch(value);
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

  // Email invalido
  void invalidEmailMessage() {
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

}