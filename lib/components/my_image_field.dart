import 'dart:io';

import 'package:flutter/material.dart';
import '../services/image_manager_service.dart';

/*
 *  MyImageField te crea un campo de selección de imagen
 */
class MyImageField extends StatefulWidget{
  final bool? enabled;

  // Callback
  final Function(File?)? getSelectedImage;

  const MyImageField({
    super.key,
    this.enabled,
    required this.getSelectedImage,
  });

  @override
  State<MyImageField> createState() => _MyImageFieldState();
}

class _MyImageFieldState extends State<MyImageField> {

  @override
  Widget build(BuildContext context){

    bool? enabled = widget.enabled;

    // Imagen seleccionada
    File? selectedImage;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [

          // Imagen a mostrar
          CircleAvatar(
            radius: 100.0,
            backgroundColor: Colors.grey[500],
            child: selectedImage != null ? Image.file(selectedImage) : Text("imagen"),
          ),

          // Boton para seleccionar la imagen
          ElevatedButton(
            child: const Text("Seleccionar imagen"),
            onPressed: () async{

              if(enabled == null || enabled == false){

              }else{
                final image = await getImage();
                setState(() {
                  selectedImage = File(image!.path);
                });

                // Se hace un callback para devolver el selectedImage
                if(widget.getSelectedImage != null){
                  widget.getSelectedImage!(selectedImage);
                }
              }
            },
          ),

          // ¿Boton para guardar la imagen?
        ],
      ),
    );
  }
}

