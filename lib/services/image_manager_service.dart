import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

// Método que te escoge una foto de la galería
Future<XFile?> getImage() async{
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

// Método con te sube la imagen a Firebase storage y te devuelve su URL
Future<String?> uploadImage( File? image) async{

  if(image != null){
    // Acortamos la ruta a el nombre de la imagen unicamente
    final String nameFile = image.path.split("/").last;

    // Se construye la referencia al lugar donde se guarda
    final Reference ref = storage
        .ref()
        .child("cursos")
        .child(nameFile);
    final UploadTask uploadTask = ref.putFile(image);

    // Se sube a Firebase storage
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

    // Se obtiene su url
    final String url = await snapshot.ref.getDownloadURL();

    if(snapshot.state == TaskState.success) {
      return url;
    }
  }
  return '';
}
