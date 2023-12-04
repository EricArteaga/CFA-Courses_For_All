import 'package:cfa_coursesforall/components/my_course_tile.dart';
import 'package:cfa_coursesforall/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignedIn extends StatefulWidget{

  @override
  State<SignedIn> createState() => _SignedInState();
}

class _SignedInState extends State<SignedIn> {
  final user = FirebaseAuth.instance.currentUser!;

  //Datos del usuario
  String _email = "";

  //String _foto = "";
  void obetenerDatosDelUsuario(){
    _email = user.email!;
    //_nombre = user.displayName!;
    //_foto = user.photoURL!;
  }

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    obetenerDatosDelUsuario();

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
        IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
      ],
    );
  }

  // TODO: Hacer que este scaffold solo te muestre tus cursos creados
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
                  return MyCourseTile(
                    title: snapshot.data?[index]["titulo"],
                    duration: snapshot.data?[index]["duracion"],
                    teacherID: snapshot.data?[index]["profesor_id"],
                    language: snapshot.data?[index]["idioma"],
                    // TODO: Se debe implementar un método que te abra la ventana para ver ese curso en especifico
                    onTap: (){
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
      child: const Icon(Icons.add, size: 40,),
      elevation: 30.0,
      // Método que te abre la ventana de crear cursos
      onPressed: (){

      },
    );
  }
}