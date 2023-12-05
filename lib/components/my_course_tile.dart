import 'package:cfa_coursesforall/components/my_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../services/firebase_service.dart';
import 'my_list_tile.dart';

class MyCourseTile extends StatelessWidget{
  // TODO: Implementar subida de imagen del Curso
  final String title;
  final String teacherID;
  final String language;
  final String duration;
  final String imageURL;
  final Function()? onTap;
  // Note - Aquí no necesito el pdf

  const MyCourseTile({
    super.key,
    required this.title,
    required this.teacherID,
    required this.language,
    required this.duration,
    required this.imageURL,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Slidable(
        endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              // Opción de editar
              SlidableAction(
                onPressed: editCourse,
                backgroundColor: Colors.grey.shade800,
                icon: Icons.settings,
                borderRadius: BorderRadius.circular(10),
              ),

              // Opción de borrar
              SlidableAction(
                onPressed: deleteCourse,
                backgroundColor: Colors.red.shade500,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(10),
              ),
            ]
        ),
        child: FutureBuilder(
          future: getProfesorById(teacherID),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return MyListTile(

                // Aquí estaría la imagen del curso
                image: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey[500],
                  //backgroundImage: const AssetImage('lib/images/Logo_CFA.png'),
                  child: ClipOval(
                    child: MyImageWidget(imageUrl: imageURL),
                  ),
                ),

                title: title,
                duration: duration,
                onTap: onTap,
                teacherName:  snapshot.data?["name"],
                language: language,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        ),
      ),
    );
  }

  // Método para eliminar el curso
  void deleteCourse(BuildContext context){

  }

  // Métodopara abrir la venta de edición del curso
  void editCourse(BuildContext context){

  }

}