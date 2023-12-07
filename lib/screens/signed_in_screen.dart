import 'package:cfa_coursesforall/components/my_course_tile.dart';
import 'package:cfa_coursesforall/screens/course_view_screen.dart';
import 'package:cfa_coursesforall/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  //String _foto = "";
  void obetenerDatosDelUsuario(){
    _email = user.email!;
    _id = user.uid;
    //_nombre = user.displayName!;
    //_foto = user.photoURL!;
  }

  @override
  initState(){
    super.initState();

    obetenerDatosDelUsuario();
  }

  @override
  Widget build(BuildContext context) {

    // Scaffold del profesor
    return FutureBuilder(
      future: teacherScaffold(),
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

  // Método para quitar el usuario
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  // Barra de la app
  AppBar appBar(){
    return AppBar(
      title: Center(child: Text("Logged in as: $_email")),
      actions: [
        IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)),
      ],
    );
  }

  // Método que te devuelve un scaffold con todos los cursos creados
  Future<Scaffold> teacherScaffold() async{
    return Scaffold(
      appBar: appBar(),
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
                  final String id = snapshot.data![index]['id'];

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
                            _reloadData();
                          },
                          editTapped: (context) async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    CourseViewScreen(
                                      screenState: "Edit",
                                      course: course,
                                      courseID: id,

                                      // El snapshot trae nombre del profesor
                                      teacherName: snapshot.data!,
                                    )));

                            // Se actualizan los datos cuando se vuelve a la página
                            _reloadData();
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
            _reloadData();
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

  // Método que obtiene el nombre del profesor creador del curso
  Future<String> getCreator(profesorID) async{
    // Se saca de la base de datos el profesor creador del curso
    Map<String, dynamic>? profesor = await getProfesorById(profesorID);
    String nombre = profesor!["name"];
    return nombre;
  }
  
  // Método para recargar los datos
  void _reloadData() async {
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
}