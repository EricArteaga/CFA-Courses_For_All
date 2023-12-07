import 'package:cfa_coursesforall/components/my_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../screens/course_view_screen.dart';
import '../services/firebase_service.dart';
import 'my_list_tile.dart';

class MyCourseTile extends StatelessWidget{
  // TODO: Implementar subida de imagen del Curso
  // TODO: Refactorizar atributos por el curso entero
  final Map<String, dynamic>? course;

  // Método que recoje el curso para pasarselo al padre
  final Function() onTap;

  // Métodos de los botones del Slidable
  final Function(BuildContext)? editTapped;
  final Function(BuildContext)? deleteTapped;
  // Note - Aquí no necesito el pdf

  const MyCourseTile({
    super.key,
    required this.course,
    required this.onTap,
    this.editTapped,
    this.deleteTapped
  });


  // TODO: Implementar que Slidable solo esté para el profesor
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Slidable(
        endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [

              // Opción de editar
              // TODO: Implementar método para abrir CourseScreenView en edición
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
                  //backgroundImage: const AssetImage('lib/images/Logo_CFA.png'),
                  child: ClipOval(
                    child: SizedBox(
                        height: 200,
                        width: 200,
                        child: MyImageWidget(imageUrl: course?["imagenURL"] ?? "")
                    ),
                  ),
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
      ),
    );
  }

  // Método para eliminar el curso
  void deleteCourse(BuildContext context){

  }

  // Métodopara abrir la venta de edición del curso
  void editCourse(BuildContext context){
    MaterialPageRoute(builder: (context) => CourseViewScreen(
      screenState: "Edit",
      course: course,
      teacherName: "",
    ));
  }

}