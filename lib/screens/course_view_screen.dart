import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/firebase_service.dart';


class CourseViewScreen extends StatefulWidget {
  const CourseViewScreen({super.key});

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen> {

  // Variable que actua como palanca para activar funcionalidades según el
  // perfil de usuario y lo que se quiera hacer (ver, modificar, etc)
  final screenState = "";

  // Estado del formulario
  final formKeyCreateCourse = GlobalKey<FormState>();

  // Valores del formulario
  final _titleCourseController = TextEditingController();
  final _durationCourseController = TextEditingController();
  final _teacherIDCourseController = TextEditingController();
  final _languageCourseController = TextEditingController();
 // Note - ¿Se añade PDF y imagen del curso?

  @override
  void initState() {
    super.initState();
    // TODO: Implementar método que te cambie screenState según el perfil con el que se logea y los permisos
  }

  // TODO: Desabilitar campos cuando se entre para ver los datos del curso
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          //padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
            child: Form(
                key: formKeyCreateCourse,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const SizedBox(height: 20,),

                      // Texto crear curso
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Crear Curso",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),

                      // Campo del titulo
                      MyTextFormField(
                        controller: _titleCourseController,
                        labelText: "Título",
                        onSaved: (value) {
                          if (value != null) {
                            _titleCourseController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'El título no puede estar vacio';
                          } else if (value.isEmpty) {
                            return 'El título no puede estar vacio';
                          } else {
                            return null;
                          }
                        },
                      ),

                      const SizedBox(height: 10,),

                      // Campo de la duración
                      MyTextFormField(
                        controller: _durationCourseController,
                        labelText: "Duración",
                        onSaved: (value) {
                          if (value != null) {
                            _durationCourseController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'La duración no puede estar vacia';
                          } else if (value.isEmpty) {
                            return 'La duración no puede estar vacia';
                          } else {
                            return null;
                          }
                        },
                      ),

                      const SizedBox(height: 10,),

                      // TODO: hacer que este campo esté siempre desabilitado
                      // Note - Debe cargarse por defecto el uid del profesor
                      // Campo del id del profesor
                      MyTextFormField(
                        controller: _teacherIDCourseController,
                        labelText: "ID Profesor",
                        onSaved: (value) {
                          if (value != null) {
                            _teacherIDCourseController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'El Id del profesor no puede estar vacio';
                          } else if (value.isEmpty) {
                            return 'El Id del profesor no puede estar vacio';
                          } else {
                            return null;
                          }
                        },
                      ),

                      const SizedBox(height: 10,),

                      // Campo del idioma
                      MyTextFormField(
                        controller: _languageCourseController,
                        labelText: "Idioma",
                        obscureText: true,
                        onSaved: (value) {
                          if (value != null) {
                            _languageCourseController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'El idioma no puede estar vacia';
                          } else if (value.isEmpty) {
                            return 'El idioma no puede estar vacio';
                          } else {
                            return null;
                          }
                        },
                      ),
                      // TODO: Implemntar subida de imagen

                      // TODO: Implemntar subida de pdf

                      const SizedBox(height: 30,),

                      // Boton de crear cuenta
                      MyButton(
                        text: "Crear cuenta",
                        onTap: crearCurso,
                      ),
                    ]
                )
            )
        ),
      )
    );
  }

  bool validateAndSaveCourse() {
    final form = formKeyCreateCourse.currentState;
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

  // Método que crea el curso
  Future crearCurso()  async {
    if(validateAndSaveCourse()){
      // Se muestra el circulo de carga
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );

      // TODO: Añadir las comprobaciones necesarias y los mensajes de error

      // Creamos un mapa que guarda los campos
      Map<String, dynamic> curso = <String, dynamic>{
        "titulo": _titleCourseController.text.trim(),
        "duracion": _durationCourseController.text.trim(),
        "profesor_id": _teacherIDCourseController.text.trim(),
        "idioma": _languageCourseController.text.trim(),
      };

      /*
       * Se crea en la colección curso un curso con sus datos del fomulario,
       * y con el id del profesor para saber que profesor es el que ha creado
       * el curso
       */
      await createCurso(curso);
    }
  }
}
