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
// ? GET Alumno By ID
Future<Map<String, dynamic>?> getAlumnoById(String? studentID) async {
  CollectionReference collectionReferenceAlumno = db.collection('alumno');


  DocumentSnapshot alumnoSnapshot;
  if (studentID != null) {
    alumnoSnapshot = await collectionReferenceAlumno
        .doc(studentID)
        .get();
  } else {
    alumnoSnapshot = await collectionReferenceAlumno
        .doc("falloAPosta") // Hacemos que falle para que devuelva null
        .get();
  }

  if (alumnoSnapshot.exists) {
    // El alumno existe, devuelve sus datos como un mapa
    return alumnoSnapshot.data() as Map<String, dynamic>;
  } else {
    // El alumno no existe
    return null;
  }
}

// ? CREATE Alumno
Future<void> createAlumno(Map<String, dynamic> alumno, String? uid) async{
  CollectionReference collectionReferenceAlumno = db.collection('alumno');
  await collectionReferenceAlumno
      .doc(uid)
      .set(alumno);
}

//? UPDATE Alumno
Future<void> updateAlumno(String id, Map<String, dynamic> alumno) async{
  CollectionReference collectionReferenceAlumno = db.collection('alumno');
  await collectionReferenceAlumno
      .doc(id)
      .update(alumno);
}

//? DELETE Alumno
Future<void> deleteAlumno(String id) async{
  CollectionReference collectionReferenceAlumno = db.collection('alumno');
  await collectionReferenceAlumno
      .doc(id)
      .delete();
}

// End CRUD de la colección Alumno
// Region CRUD de la colección Profesor
// ? GET Profesores
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

// ? GET Profesor By ID
Future<Map<String, dynamic>?> getProfesorById(String? teacherID) async {
  CollectionReference collectionReferenceProfesor = db.collection('profesor');


  DocumentSnapshot profesorSnapshot;
  if (teacherID != null) {
    profesorSnapshot = await collectionReferenceProfesor
        .doc(teacherID)
        .get();
  } else {
    profesorSnapshot = await collectionReferenceProfesor
        .doc("falloAPosta") // Hacemos que falle para que devuelva null
        .get();
  }

  if (profesorSnapshot.exists) {
    // El profesor existe, devuelve sus datos como un mapa
    return profesorSnapshot.data() as Map<String, dynamic>;
  } else {
    // El profesor no existe
    return null;
  }
}
// ? CREATE Profesor
Future<void> createProfesor(Map<String, dynamic> profesor, String? uid) async{
  CollectionReference collectionReferenceProfesor = db.collection('profesor');
  await collectionReferenceProfesor
      .doc(uid)
      .set(profesor);
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
// ? GET Cursos
Future<List<Map<String, dynamic>>> getCursos([String? teacherID]) async{
  List<Map<String, dynamic>> cursos = [];
  CollectionReference collectionReferenceCursos = db.collection('curso');

  // get() devuelve un QuerySnapshot con el que se trata gracias a la sintasis
  // de then, recogiendo ese valor y creando una función donde se recorre los
  // resultados del get() con un forEach()
  QuerySnapshot querySnapshot;

  // Si hay un id del profesor se recogen los cursos de ese profesor
  if (teacherID != null) {
    querySnapshot = await collectionReferenceCursos.where('profesor_id', isEqualTo: teacherID).get();

  // Si no, se recogen todos los cursos
  } else {
    querySnapshot = await collectionReferenceCursos.get();
  }

  cursos = querySnapshot.docs.map((element) {
    return {
      "id": element.id,
      "data": element.data(),
    };
  }).toList();

  // Retardamos la petición para que aparezca el circulo de carga
  await Future.delayed(const Duration(milliseconds: 500));

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
  collectionReferenceCurso
      .doc(id)
      .update(curso);
}

//? DELETE Curso
Future<void> deleteCurso(String id) async{
  CollectionReference collectionReferenceCurso = db.collection('curso');
  await collectionReferenceCurso
      .doc(id)
      .delete();
}
// End CRUD de la colección Curso
// Region Complementos
// Método que me devuelve el tipo de usuario del id introducido
Future<String> getUserType(String userID) async{
  // Consulta para verificar si el usuario está en la colección de profesor
  bool isProfessor = await isUserInCollection(userID, "profesor");

  // Consulta para verificar si el usuario está en la colección de alumno
  bool isStudent = await isUserInCollection(userID, "alumno");

  if (isProfessor) {
    return "profesor";
  } else if (isStudent) {
    return "alumno";
  } else {
    return "desconocido";
  }
}

// Método que me comprueba si un usuario está en una colección
Future<bool> isUserInCollection(String userId, String collectionName) async {
  // Consulta para verificar si el usuario está en la colección
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(userId)
        .get();

    return userDoc.exists;
  } catch (e) {
    print("Error al verificar la existencia del usuario en la colección: $e");
    return false;
  }
}
// End