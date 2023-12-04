import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Region CRUD de la colección Alumno

// ? GET Alumno
Future<List> getAlumnos() async{
  List alumnos = [];
  CollectionReference collectionReferenceAlumnos = db.collection('alumno');

  // get() devuelve un QuerySnapshot con el que se trata gracias a la sintasis
  // de then, recogiendo ese valor y creando una función donde se recorre los
  // resultados del get() con un forEach()
   await collectionReferenceAlumnos.get().then((value) {
    value.docs.forEach((element) {
      alumnos.add(element.data());
    });
  });
  return alumnos;
}

// ? CREATE Alumno
Future<void> createAlumno(Map<String, dynamic> alumno, String? uid) async{
  CollectionReference collectionReferenceAlumno = db.collection('alumno');
  await collectionReferenceAlumno.doc(uid).set(alumno);
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
// ? GET Profesor
Future<List> getProfesores() async{
  List profesores = [];
  CollectionReference collectionReferenceProfesores = db.collection('profesor');

  // get() devuelve un QuerySnapshot con el que se trata gracias a la sintasis
  // de then, recogiendo ese valor y creando una función donde se recorre los
  // resultados del get() con un forEach()
  await collectionReferenceProfesores.get().then((value) {
    value.docs.forEach((element) {
      profesores.add(element.data());
    });
  });
  return profesores;
}

// ? CREATE Profesor
Future<void> createProfesor(Map<String, dynamic> profesor, String? uid) async{
  CollectionReference collectionReferenceProfesor = db.collection('profesor');
  await collectionReferenceProfesor.doc(uid).set(profesor);
}

//? UPDATE Profesor
Future<void> updateProfesor(String id, Map<String, dynamic> profesor) async{
  CollectionReference collectionReferenceProfesor = db.collection('profesor');
  await collectionReferenceProfesor.doc(id).update(profesor);
}

//? DELETE Profesor
Future<void> deleteProfesor(String id) async{
  CollectionReference collectionReferenceProfesor = db.collection('profesor');
  await collectionReferenceProfesor.doc(id).delete();
}

// End CRUD de la colección Profesor
// Region CRUD de la colección Curso
// ? GET Curso
Future<List> getCursos() async{
  List cursos = [];
  CollectionReference collectionReferenceCursos = db.collection('curso');

  // get() devuelve un QuerySnapshot con el que se trata gracias a la sintasis
  // de then, recogiendo ese valor y creando una función donde se recorre los
  // resultados del get() con un forEach()
  await collectionReferenceCursos.get().then((value) {
    value.docs.forEach((element) {
      cursos.add(element.data());
    });
  });

  // Retardamos la petición para que aparezca el circulo de carga
  await Future.delayed(const Duration(seconds: 1, milliseconds: 5));


  return cursos;
}

// ? CREATE Curso
Future<void> createCurso(Map<String, dynamic> curso) async{
  CollectionReference collectionReferenceCurso = db.collection('curso');
  await collectionReferenceCurso.add(curso);
}

//? UPDATE Curso
Future<void> updateCurso(String id, Map<String, dynamic> curso) async{
  CollectionReference collectionReferenceCurso = db.collection('curso');
  collectionReferenceCurso.doc(id).update(curso);
}

//? DELETE Curso
Future<void> deleteCurso(String id) async{
  CollectionReference collectionReferenceCurso = db.collection('curso');
  await collectionReferenceCurso.doc(id).delete();
}
// End CRUD de la colección Curso
