import 'dart:io';

import 'package:cfa_coursesforall/components/my_data_course_field.dart';
import 'package:cfa_coursesforall/components/my_image_field.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../services/firebase_service.dart';
import '../services/image_manager_service.dart';


class CourseViewScreen extends StatefulWidget {
  // Atributo final que denota si se está editando o viendo el curso
  // Note - Valores: "Edit" - "View" - "Create"
  final String screenState;

  // Atributo final que es el objeto Map<String, dynamic> del curso
  // Note - Solo para "Edit" y "View"
  final Map<String, dynamic>? course;

  // ID del curso para poder editarlo
  // Note - Solo para "Edit"
  final String? courseID;

  // ID del profesor
  final String? teacherID;

  // Nombre del profesor
  final String teacherName;

  const CourseViewScreen({
    super.key,
    required this.screenState,
    this.course,
    this.courseID,
    this.teacherID,
    required this.teacherName,
  });

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}


class _CourseViewScreenState extends State<CourseViewScreen> {

  // Get del ScreenState
  String get screenState => widget.screenState;

  // Get del id del curso
  String? get courseID => widget.courseID;

  //Get del Nombre del profesor
  String get teacherName => widget.teacherName;

  // Get del curso
  Map<String, dynamic>? get curso => widget.course;

  // Get del ID del usuario si es un profesor
  String? get teacherID => widget.teacherID;

  late String profesorID;

  // Estado del formulario
  final formKeyCreateCourse = GlobalKey<FormState>();

  // Valores del formulario
  final _titleCourseController = TextEditingController();
  final _durationCourseController = TextEditingController();
  final _teacherNameController = TextEditingController();
  final _languageCourseController = TextEditingController();
  File? _selectedImageFile;

  @override
  initState() {
    super.initState();

    // Se cargan los datos de los campos según el método checkDownloadCourse()
    if(checkDownloadCourse()){
      downloadCourseValues();
    }

    // Se obtiene el ID del profesor
    profesorID = teacherID ?? curso?["profesor_id"] ?? "";

    // Se obtiene el Profesor Creador del curso
    //getCreator();

    // Se obtiene el nombre del profesor para el campo profesor
    _teacherNameController.text = teacherName;
  }
 // Note - ¿Se añade PDF?

  // TODO: Implementar lógica para cargar datos del curso
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // TODO: Hacer método appBar()
      appBar: AppBar(
        centerTitle: true,
        title:  Text(
          setAppBarTitle(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.width * 0.1),
            child: Form(
                key: formKeyCreateCourse,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const SizedBox(height: 40,),

                      // Campo del titulo
                      MyDataCourseField(
                        controller: _titleCourseController,
                        labelText: "Título",
                        enabled: checkEnabledFields(),
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

                      // Campo del idioma
                      MyDataCourseField(
                        controller: _languageCourseController,
                        labelText: "Idioma",
                        enabled: checkEnabledFields(),
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

                      const SizedBox(height: 10,),

                      // Campo de la duración
                      MyDataCourseField(
                        controller: _durationCourseController,
                        labelText: "Duración",
                        enabled: checkEnabledFields(),
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

                      // TODO: Cambiar el uid por el nombre del profesor
                      // Note - Debe cargarse por defecto el uid del profesor
                      // Campo del id del profesor
                      MyDataCourseField(
                        controller: _teacherNameController,
                        labelText: "Nombre Profesor",
                        enabled: false,
                        onSaved: (value) {
                          if (value != null) {
                            _teacherNameController.text = value;
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

                      MyImageField(
                        enabled: checkEnabledFields(),
                        exitsCourse: checkDownloadCourse(),
                        image: widget.course?["imagenURL"],
                        getSelectedImage: (File? selectedImage) {
                          _selectedImageFile = selectedImage;
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

  // Note - Me he dado cuenta de que existen dos tipos de comprobaciones
  // Note - 1. La que permite que los campos estén enabled -> "Create" or "Edit"
  // Note - 2. La que te carga los datos del curso -> "Edit" or "View"
  // Método que te comprueba el screenState y te permite modificar el campo o no
  bool checkEnabledFields(){
    // True para "Edit" y "Create", y false para "View"
    return screenState == "Edit" || screenState == "Create" ? true : false;
  }

  // Método que te comprueba el screenState y te carga los datos del curso
  bool checkDownloadCourse(){
    // True para "Edit" y "View", y false para "Create"
    return screenState == "Edit" || screenState == "View" ? true : false;
  }

  // Método que te devuelve un texto para el AppBar según el screenState
   setAppBarTitle(){
    String title = "";
    if(screenState == "View"){
      title = "Datos del curso";
    }else if(screenState == "Edit"){
      title = "Editar Curso";
    }else if(screenState == "Create"){
      title = "Crear Curso";
    }
    return title;
  }

  Widget showBottom(){
    if(checkEnabledFields()){
      // Te muestra el botón según el screenState
      return MyButton(
        text: screenState == "Create" ? "Crear curso" : "Modificar curso",
        onTap: screenState == "Create" ? crearCurso : modificarCurso,
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

      try {
        /*
         * Se sube la imagen al storage y se obtiene la url de donde está, para
         * pasarlo como parametro al curso.
         */
        String? imageURL = await uploadImage(_selectedImageFile);

        // Creamos un mapa que guarda los campos
        Map<String, dynamic> createdCourse = <String, dynamic>{
          "titulo": _titleCourseController.text.trim(),
          "duracion": _durationCourseController.text.trim(),
          "profesor_id": profesorID,
          "idioma": _languageCourseController.text.trim(),
          "imagenURL": imageURL,
        };

        /*
         * Se crea en la colección curso un curso con sus datos del fomulario,
         * y con el id del profesor para saber que profesor es el que ha creado
         * el curso
         */
        await createCurso(createdCourse);
      } catch (e) {
        print("Error: ${e.toString()}");
      }
    }
  }

  Future modificarCurso() async{
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

      try {
        /*
         * Se sube la imagen al storage y se obtiene la url de donde está, para
         * pasarlo como parametro al curso.
         */
        String? imageURL;
        // Se comprueba si se ha seleccionado una imagen y se guarda
        if(_selectedImageFile != null){
          imageURL = await uploadImage(_selectedImageFile);

        // Si no, se guarda la que ya estaba
        } else{
          imageURL = curso?["imagenURL"] ?? "";
        }


        // Creamos un mapa que guarda los campos
        Map<String, dynamic> editedCourse = <String, dynamic>{
          "titulo": _titleCourseController.text.trim(),
          "duracion": _durationCourseController.text.trim(),
          "profesor_id": profesorID,
          "idioma": _languageCourseController.text.trim(),
          "imagenURL": imageURL,
        };

        /*
         * Se crea en la colección curso un curso con sus datos del fomulario,
         * y con el id del profesor para saber que profesor es el que ha creado
         * el curso
         */
        await updateCurso(courseID!, editedCourse);
        Navigator.pop(context);

      } catch (e) {
        print("Error: ${e.toString()}");
      }
    }
  }

  // Método que te carga los datos del curso
  Future downloadCourseValues() async{
    if (curso != null) {
      // Obtener datos del mapa del curso
      String titulo = curso?["titulo"] ?? "";
      String duracion = curso?["duracion"] ?? "";
      String idioma = curso?["idioma"] ?? "";

      // Asignar valores a los controladores
      _titleCourseController.text = titulo;
      _durationCourseController.text = duracion;
      _languageCourseController.text = idioma;
    }
  }

}
