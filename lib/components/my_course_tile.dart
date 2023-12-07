import 'package:cfa_coursesforall/components/my_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../screens/course_view_screen.dart';
import '../services/firebase_service.dart';
import 'my_list_tile.dart';

class MyCourseTile extends StatelessWidget{
  // Mapa que almacena los datos del curso
  final Map<String, dynamic>? course;

  // String que denota el tipo de usuario
  final String userType;

  // Método que recoje el curso para pasarselo al padre
  final Function() onTap;

  // Métodos de los botones del Slidable
  final Function(BuildContext)? editTapped;
  final Function(BuildContext)? deleteTapped;
  // Note - Aquí no necesito el pdf


  const MyCourseTile({
    super.key,
    required this.course,
    required this.userType,
    required this.onTap,
    this.editTapped,
    this.deleteTapped
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10, top: 20),
      child: userType == "profesor" ? courseTileForTeacher()
            :
        courseTileForStudent(),
    );
  }

  // Método que te crea un MyCourseTile para profesor
  Widget courseTileForTeacher(){
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [

          // Opción de editar
          SlidableAction(
            onPressed: editTapped,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(10),

          ),

          // Opción de borrar
          // TODO: Implementar método para eliminar con un pop up de confirmación
          SlidableAction(
            onPressed: deleteTapped,
            backgroundColor: Colors.red.shade500,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(10),
          ),
        ]
      ),
      child: FutureBuilder(
        future: getProfesorById(course?["profesor_id"] ?? ""),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return MyListTile(

              // Aquí estaría la imagen del curso
              image: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.grey[500],
                backgroundImage: NetworkImage( course?["imagenURL"] ?? ""),
              ),

              title: course?["titulo"] ?? "",
              duration: course?["duracion"] ?? "",
              onTap: onTap,
              teacherName:  snapshot.data?["name"],
              language: course?["idioma"] ?? "",
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  // Método que te crea un MyCourseTile para alumno
  Widget courseTileForStudent(){
    return FutureBuilder(
      future: getProfesorById(course?["profesor_id"] ?? ""),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return MyListTile(

            // Aquí estaría la imagen del curso
            image: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.grey[500],
              backgroundImage: NetworkImage( course?["imagenURL"] ?? ""),
            ),

            title: course?["titulo"] ?? "",
            duration: course?["duracion"] ?? "",
            onTap: onTap,
            teacherName:  snapshot.data?["name"],
            language: course?["idioma"] ?? "",
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}