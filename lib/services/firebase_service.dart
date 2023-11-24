
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Region CRUD de la colección Alumno

// ? GET Alumno
Future<List> getAlumnos() async{
  List alumnos = [];
  CollectionReference collectionReferenceAlumnos = db.collection('alumno');

  // get() devuelve un QuerySnapshot con el que se trata gracias a la sintasis
  // de then, recogiendo ese valor y creando una función donde se recorre los
  // resultados del get con un forEach()
   await collectionReferenceAlumnos.get().then((value) {
    value.docs.forEach((element) {
      alumnos.add(element.data());
    });
  });
  return alumnos;
}

// ? CREATE Alumno
Future<void> createAlumno(Map<String, dynamic> alumno) async{
  CollectionReference collectionReferenceAlumno = db.collection('alumno');
  await collectionReferenceAlumno.add(alumno).then((DocumentReference doc) {
    print('DocumentSnapshot añadido con el ID: ${doc.id}');
  });
}

//? UPDATE Alumno
Future<void> updateAlumno(String id, Map<String, dynamic> alumno) async{
  CollectionReference collectionReferenceAlumno = db.collection('alumno');
  await collectionReferenceAlumno.doc(id).update(alumno);
}

//? DELETE Alumno
Future<void> deleteAlumno(String id) async{
  CollectionReference collectionReferenceAlumno = db.collection('alumno');
  await collectionReferenceAlumno.doc(id).delete();
}

// End CRUD de la colección Alumno

// Region CRUD de la colección Profesor

