import 'dart:io';

import 'package:cfa_coursesforall/components/my_image_field.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/firebase_service.dart';
import '../services/image_manager_service.dart';


class CourseViewScreen extends StatefulWidget {
  // Atributo final que denota si se está editando o viendo el curso
  // Valores: "Edit" - "View" - "Create"
  final String screenState;

  // Atributo final que es el objeto Map<String, dynamic> del curso
  // Note - Solo para editar y mirar
  final Map<String, dynamic>? curso;

  const CourseViewScreen({
    super.key,
    required this.screenState,
    this.curso
  });

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}


class _CourseViewScreenState extends State<CourseViewScreen> {

  // Get del ScreenState
  String get screenState => widget.screenState;

  // Get del curso
  Map<String, dynamic>? get curso => widget.curso;

  // Estado del formulario
  final formKeyCreateCourse = GlobalKey<FormState>();

  // Valores del formulario
  final _titleCourseController = TextEditingController();
  final _durationCourseController = TextEditingController();
  final _teacherIDCourseController = TextEditingController();
  final _languageCourseController = TextEditingController();
  File? _selectedImageController;
 // Note - ¿Se añade PDF?

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

                      // TODO: Hacer que los campos del form estén desabilitados si se está viendo el curso
                      // Texto crear curso
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
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
                        enabled: comprobateScreenState(),
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
                        enabled: comprobateScreenState(),
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

                      // Note - Debe cargarse por defecto el uid del profesor
                      // Campo del id del profesor
                      MyTextFormField(
                        controller: _teacherIDCourseController,
                        labelText: "ID Profesor",
                        enabled: true,
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
                        enabled: comprobateScreenState(),
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

                      // TODO: Implementar subida de imagen
                      MyImageField(
                        getSelectedImage: (File? selectedImage) {
                          _selectedImageController = selectedImage;
                        },
                      ),

                      // TODO: Implementar subida de pdf

                      const SizedBox(height: 30,),

                      // TODO: Implemntar buen funcionamiento
                      // Boton de crear curso
                      showBottom(),
                    ]
                )
            )
        ),
      )
    );
  }

  // Método que te comprueba el screenState y te permite modificar el campo o no
  bool comprobateScreenState(){
    // True para "Edit" y "Create", y false para "View"
    return screenState == "Edit" || screenState == "Create" ? true : false;
  }

  Widget showBottom(){
    if(comprobateScreenState()){
      // Te muestra el botón según el screenState
      return MyButton(
        text: screenState == "Create "? "Crear curso" : "Modificar curso",
        onTap: screenState == "Create "? crearCurso : modificarCurso,
      );
    }else{

      // No te muestra nada
      return const SizedBox(height: 0,);
    }
  }

  // Método que valida los campos del formulario de los cursos
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

  // Método que valida el curso, te muestra errores y te crea el curso en FireStore
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


      /*
       * Se sube la imagen al storage y se obtiene la url de done está, para
       * pasarlo como parametro al curso.
       */
      Future<String?> imageURL = uploadImage(_selectedImageController);

      // Creamos un mapa que guarda los campos
      Map<String, dynamic> curso = <String, dynamic>{
        "titulo": _titleCourseController.text.trim(),
        "duracion": _durationCourseController.text.trim(),
        "profesor_id": _teacherIDCourseController.text.trim(),
        "idioma": _languageCourseController.text.trim(),
        "imagenURL": imageURL,
      };

      /*
       * Se crea en la colección curso un curso con sus datos del fomulario,
       * y con el id del profesor para saber que profesor es el que ha creado
       * el curso
       */
      //await createCurso(curso);
    }
  }

  Future modificarCurso() async{

  }
}
