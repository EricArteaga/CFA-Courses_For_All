import 'package:cfa_coursesforall/components/my_course_tile.dart';
import 'package:cfa_coursesforall/screens/course_view_screen.dart';
import 'package:cfa_coursesforall/screens/user_view_screen.dart';
import 'package:cfa_coursesforall/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_wrong_message.dart';
import '../tools/dialog_messages.dart';

class SignedIn extends StatefulWidget{
  const SignedIn({super.key});

  @override
  State<SignedIn> createState() => _SignedInState();
}

class _SignedInState extends State<SignedIn> {
  final user = FirebaseAuth.instance.currentUser!;

  //Datos del usuario
  String _email = "";
  String? _id;

  // Tipo de usuario que ha iniciado sesión
  late String userType = "desconocido";

  // Foto de perfil del usuario
  late String? userImage = "";

  void obetenerDatosDelUsuario() async{
    _email = user.email!;
    _id = user.uid;

    // Determinar el tipo de usuario
    userType = await getUserType(_id!);

    // Imagen de usuario
    Map<String, dynamic>? userData ;
    if(userType == "profesor"){
      userData = await getProfesorById(user.uid);

    // widget.userType == "alumno"
    }else{
      userData = await getAlumnoById(user.uid);
    }

    userImage = userData?["imageURL"] ?? "";

    // Recarga del State para poner el scaffold correspondiente
    setState(() {});

  }

  @override
  initState(){
    super.initState();

    // Se cargan los datos del usuario
    obetenerDatosDelUsuario();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // En base al tipo se muestra un scaffold u otro
      future: userType == "profesor" ? teacherScaffold() : studentScaffold(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          // Cuando el Future está completo, se devuelve el  Scaffold
          return snapshot.data as Widget;
        } else {

          // Mientras el Future no tiene el valor de vuelta, se muestra un
          // indicador de carga
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }

  // Region Profesor
  // Método que te devuelve un scaffold con todos los cursos creados
  Future<Scaffold> teacherScaffold() async{
    return Scaffold(
      appBar: headerBarSingIn(),
      drawer: userDrawer(),
      backgroundColor: Colors.grey[300],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: await createFloatingActionButton(),
      body: SafeArea(
        child: FutureBuilder(
          future: getCursos(user.uid),
          builder: ((context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {

                  // Variable que almacena el id del curso
                  final String courseID = snapshot.data![index]['id'];

                  // Variable final curso
                  final Map<String, dynamic> course = snapshot.data![index]['data'];

                  // Variable del id del creador (profesor) del curso
                  final String teacherCreatorID = course['profesor_id'];

                  // Componente con la información del curso
                  return FutureBuilder(
                    future: getCreator(teacherCreatorID),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return MyCourseTile(
                          course: course,
                          userType: userType,
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    CourseViewScreen(
                                      screenState: "View",
                                      course: course,

                                      // El snapshot trae el nombre del profesor
                                      teacherName: snapshot.data!,
                                    )));

                            // Se actualizan los datos cuando se vuelve a la página
                            reloadData();
                          },
                          editTapped: (context) async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    CourseViewScreen(
                                      screenState: "Edit",
                                      course: course,
                                      courseID: courseID,

                                      // El snapshot trae nombre del profesor
                                      teacherName: snapshot.data!,
                                    )));

                            // Se actualizan los datos cuando se vuelve a la página
                            reloadData();
                          },
                          deleteTapped: (context) async {
                            deleteCourse( courseID);
                          },
                        );
                      }else{
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  );
                }
              );
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          ),
        ),
      )
    );
  }

  // Método para eliminar el curso
  void deleteCourse(String courseID) async{
    bool confirmedDelete = await confirmDeleteCourseMessage(context);

    if(confirmedDelete){
      try {
        await deleteCurso(courseID);
        reloadData();
      } catch (e){
        unknownErrorMessage();
      };
    }

  }

  // Método que devuelve un floatingActionButton para crear cursos
  Future<FutureBuilder<String>> createFloatingActionButton() async{
    return FutureBuilder(
      future: getCreator(user.uid),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.green[500],
            elevation: 30.0,

            // Método que te abre la ventana de crear cursos
            onPressed: () async {
              await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                CourseViewScreen(
                  screenState: "Create",
                  teacherID: _id,

                  // El snapshot es el nombre del profesor
                  teacherName: snapshot.data!,
            )));

          // Se actualizan los datos cuando se vuelve a la página
            reloadData();
          },

          child: const Icon(Icons.add, size: 40,),
          );
        }else{
          // No devuelve nada
          return FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.grey[500],
            onPressed: (){},
            child: const Icon(Icons.not_interested, size: 40,),
          );
        }
        }
    );
  }

  // End Profesor
  // Region Alumno
  Future<Scaffold> studentScaffold() async{
    return Scaffold(
      appBar: headerBarSingIn(),
      drawer: userDrawer(),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: FutureBuilder(
          future: getCursos(),
          builder: ((context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {

                    // Variable final curso
                    // Note - Esto es para cargar los campos en la vista, NO se elimina
                    final Map<String, dynamic> course = snapshot.data![index]['data'];

                    // Variable del id del creador (profesor) del curso
                    // Note - Esto es para obtener el nombre del profesor
                    final String teacherCreatorID = course['profesor_id'];

                    // Componente con la información del curso
                    return FutureBuilder(
                        future: getCreator(teacherCreatorID),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {

                            return MyCourseTile(
                              course: course,
                              userType: userType,
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        CourseViewScreen(
                                          screenState: "View",
                                          course: course,

                                          // El snapshot trae el nombre del profesor
                                          teacherName: snapshot.data!,
                                        )));

                                // Se actualizan los datos cuando se vuelve a la página
                                reloadData();
                              },
                              editTapped: (context) async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        CourseViewScreen(
                                          screenState: "Edit",
                                          course: course,
                                          // El snapshot trae nombre del profesor
                                          teacherName: snapshot.data!,
                                        )));

                                // Se actualizan los datos cuando se vuelve a la página
                                reloadData();
                              },
                            );
                          }else{
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    );
                  }
              );
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          ),
        ),
      )
    );
  }
  // End Alumno
  // Region Funcionalidades Comunes
  // Método para quitar el usuario
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  // Center(child: Text("Logged in as: $_email")),

  // Barra del encabezado en la que tienes las opciones de usuario
  AppBar headerBarSingIn(){
    return AppBar(
      title: CircleAvatar(
        radius: 26.0,
        backgroundColor: Colors.grey[500],
        backgroundImage: const AssetImage('lib/images/Logo_CFA.png'),
      ),
      centerTitle: true,
      backgroundColor: Colors.grey[300],
      actions: [
        IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)),
      ],
    );
  }

  // Drawer con los datos de tu perfil
  Drawer userDrawer(){
    return Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [

          // Logo + email
          DrawerHeader(
            child: Column(
              children: [

                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(userImage ?? ''),
                ),

                const SizedBox(height: 5.0),

                Text(
                  user.email ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),

          //const Divider(),

          // Botón gestionar cuenta
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gestionar cuenta'),
            onTap: () async{
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => UserViewScreen(
                      userType: userType,
                    )));

              setState(() {
                obetenerDatosDelUsuario();
              });
            },
          ),


          Expanded(child: Container()),
          const Divider(),

          // Botón eliminar cuenta
          ListTile(

            leading: const Icon(Icons.person_off),
            title: const Text('Eliminar cuenta',
              style: TextStyle(color:  Colors.redAccent)),
            onTap: () async{
              deleteUser();
            },
          ),
        ],
      ),
    );
  }

  // Método para eliminar el curso
  void deleteUser() async{
    bool confirmedDelete = await confirmDeleteUserMessage(context);

    if(confirmedDelete) {

      // Se obtiene el tipo de usuario
      String userTypeForDelete = await getUserType(user.uid);

      try {

        // Se borra de la colección al que pertenezca el usuario
        if (userTypeForDelete == "profesor") {
          // Se borra el usuario de Authentication
          await FirebaseAuth.instance.currentUser?.delete();

          deleteProfesor(user.uid);

        } else if (userTypeForDelete == "alumno") {
          // Se borra el usuario de Authentication
          await FirebaseAuth.instance.currentUser?.delete();

          deleteAlumno(user.uid);
        }
      }on FirebaseAuthException catch (e){
        if(e.code == "requires-recent-login"){
          requiresRecentLoginMessage();
        }else {
          unknownErrorMessage();
        }
      }
    }
  }

  // Método que obtiene el nombre del profesor creador del curso
  Future<String> getCreator(profesorID) async{
    // Se saca de la base de datos el profesor creador del curso
    Map<String, dynamic>? profesor = await getProfesorById(profesorID);
    String nombre = profesor!["name"];
    return nombre;
  }
  
  // Método para recargar los datos
  void reloadData() async {
    // Se muestra el circulo de carga
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    setState(() {});

    Navigator.pop(context);
  }

  // Mensaje de error desconocido
  void unknownErrorMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Error desconocido",
              content: "No se ha podido realizar la operación por un error "
                  "desconocido"
          );
        }
    );
  }

  void requiresRecentLoginMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return const MyWrongMessage(
              title: "Error inicio de sesión reciente requerido",
              content: "Se requiere haber iniciado sesión recientemente",
          );
        }
    );
  }

// End Funcionalidades Comunes
}