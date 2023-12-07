import 'dart:io';

import 'package:flutter/material.dart';
import '../services/image_manager_service.dart';
import 'my_image_widget.dart';

/*
 *  MyImageField te crea un campo de selección de imagen
 */
class MyImageField extends StatefulWidget{
  // bool que permite mostrar, o no, el botón de seleccionar imagen
  final bool? enabled;

  // bool que permite cargar, o no, la imagen del curso
  final bool? exitsCourse;

  // String que almacena la URL de la imagen si hay un curso
  final String? image;

  // Callback de la imagen que seleccionas
  final Function(File?)? getSelectedImage;

  const MyImageField({
    super.key,
    this.enabled,
    this.exitsCourse,
    this.getSelectedImage,
    this.image,
  });

  @override
  State<MyImageField> createState() => _MyImageFieldState();
}

class _MyImageFieldState extends State<MyImageField> {

  // Imagen seleccionada
  File? selectedImage;

  @override
  Widget build(BuildContext context){

    bool? enabled = widget.enabled;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [

          // Imagen a mostrar
          CircleAvatar(
            radius: 100.0,
            backgroundColor: Colors.grey[700],
            backgroundImage: selectedImage == null ? putLocalImage() : null,
            child:  selectedImage != null ? putSelectedImage() : null,
          ),

          const SizedBox(height: 10,),

          // Boton para seleccionar la imagen
          enabled == null || enabled == false ? SizedBox():
          GestureDetector(
            onTap: () async{

              // Se abre la galería para que se pueda seleccionar una imagen
              final image = await getImage();
              setState(() {
                selectedImage = image == null ? null : File(image.path);
              });

              // Se hace un callback para devolver el selectedImage (type File)
              if(widget.getSelectedImage != null){
                widget.getSelectedImage!(selectedImage);
              }

            },
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 75.0),
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: const Center(
                child: Text(
                  "Seleccionar imagen",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // ¿Boton para guardar la imagen?
        ],
      ),
    );
  }

  ImageProvider<Object>? putLocalImage(){
    if(selectedImage != null) {
      return NetworkImage( selectedImage!.path ?? "");
    }else if(widget.image != null) {
      return NetworkImage( widget.image! ?? "");
    }
  }

  Widget? putSelectedImage(){
    return ClipOval(
        child: SizedBox(
        width: 200.0, // Ajusta el tamaño según tus necesidades
        height: 200.0,
        child: Image.file(selectedImage!),
        )
    );

  }
}

