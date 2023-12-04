import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'my_list_tile.dart';

class MyCourseTile extends StatelessWidget{
  // TODO: Implementar subida de imagen del Curso
  // final String imagen;
  final String title;
  final String teacherID;
  final String language;
  final String duration;
  final Function()? onTap;
  // Note - Aquí no necesito el pdf

  const MyCourseTile({
    super.key,
    required this.title,
    required this.teacherID,
    required this.language,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return Slidable(
      endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            // Opción de editar
            SlidableAction(
              onPressed: editCourse,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
            ),

            // Opción de borrar
            SlidableAction(
              onPressed: deleteCourse,
              backgroundColor: Colors.red.shade500,
              icon: Icons.delete,
            ),
          ]
      ),
      child: MyListTile(

        // Aquí estaría la imagen del curso
        image: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey[500],
          backgroundImage: const AssetImage('lib/images/Logo_CFA.png'),
        ),
        title: title,
        duration: duration,
        onTap: onTap,
        teacherName: "Paco", // Hay que llamar al método que te busca el nombre
        language: language,
      ),
    );
  }

  // Método para eliminar el curso
  void deleteCourse(BuildContext context){

  }

  // Métodopara abrir la venta de edición del curso
  void editCourse(BuildContext context){

  }

  // Método que mediante el atributo de clase "final String teacher_i"
  // te busca su nombre en la coleccion firestore (controlar excepciones)

}