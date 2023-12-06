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

    // Declaración del Scaffold
    return teacherScaffold();
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

  // TODO: Hacer que este scaffold solo te muestre tus cursos creados (profesor)
  // Método que te devuelve un scaffold con todos los cursos creados
  Scaffold teacherScaffold(){
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.grey[300],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: createFloatingActionButton(),
      body: SafeArea(
        child: FutureBuilder(
          future: getCursos(),
          builder: ((context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {

                  // Variable que almacena el id del curso
                  final String id = snapshot.data![index]['id'];

                  // Variable final curso de tipo "dynamic", que en verdad siempre será
                  // un Map<String, dynamic>?
                  final Map<String, dynamic> course = snapshot.data![index]['data'];

                  // Componente con la información del curso
                  return MyCourseTile(
                    course: course,
                    onTap: () async{
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CourseViewScreen(
                              screenState: "View",
                              course: course,
                          )));

                      // Se actualizan los datos cuando se vuelve a la página
                      _reloadData();
                    },
                    editTapped: (context) async{
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CourseViewScreen(
                            screenState: "Edit",
                            course: course,
                            courseID: id,
                          )));

                      // Se actualizan los datos cuando se vuelve a la página
                      _reloadData();
                    },
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
  FloatingActionButton createFloatingActionButton(){
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: Colors.green[500],
      elevation: 30.0,

      // Método que te abre la ventana de crear cursos
      onPressed: () async{
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CourseViewScreen(
              screenState: "Create",
              teacherID: _id,
            )));

        // Se actualizan los datos cuando se vuelve a la página
        _reloadData();
      },

      child: const Icon(Icons.add, size: 40,),
    );
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