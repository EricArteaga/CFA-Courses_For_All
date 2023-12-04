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
    return primerScaffold();
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

  // Método que te devuelve un scaffold con una lista de ListTile con los cursos
  // creados
  Scaffold primerScaffold(){
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.grey[300],
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
}