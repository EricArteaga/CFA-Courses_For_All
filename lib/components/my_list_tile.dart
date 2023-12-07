import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget{
  final Widget? image;
  final String title;
  final String teacherName;
  final String language;
  final String duration;
  final Function()? onTap;
  // Note - Aquí no necesito el pdf

  const MyListTile({
    super.key,
    required this.image,
    required this.title,
    required this.teacherName,
    required this.language,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return ListTile(
      tileColor: Colors.grey.shade200,
      leading: image, // Imagen del curso
      title: Text(title,),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto del nombre del profesor
          Text(
            teacherName,
            style: TextStyle(),
          ),

          // Texto del idoma
          Text(
            language,
            style: TextStyle(),
          ),

          // Texto de la duración
          Text(
            duration,
            style: TextStyle(),
          ),

        ],
      ),
      onTap: onTap,
        // Método que te abre una ventana para ver el curso
        // (Creo que si lo haces con un Navigator y la clase
        // declarada en otro fichero no te jode el StreamBuilder
        // del principio)
        // onTap

    );
  }
}