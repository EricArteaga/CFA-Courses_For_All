import 'package:cfa_coursesforall/screens/auth_screen.dart';
import 'package:cfa_coursesforall/screens/screen_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/screen_sign_up/screen_sign_up.dart';

// Imports de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CFA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Georgia'
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerBar(),
      body: body(context),
    );
  }
}

// Barra de arriba
PreferredSizeWidget headerBar() {
  return AppBar(
    title: const Text("CFA"),

  );
}

// Body
Widget body(BuildContext context){
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: const BoxDecoration(
      backgroundBlendMode: BlendMode.colorDodge,
      color: Colors.black
    ),
    child: Center (
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: textoBienvenida(),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: boton_sing_up(context),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: boton_sing_in(context),
        ),
        ],
      )
    )
  );
}

Widget textoBienvenida(){
  return Text("Bienvenido a Courses For All.", style: const TextStyle(fontSize: 25),);
}

// Boton Sing Up
Widget boton_sing_up(BuildContext context){
  return ElevatedButton(child: Text("Crear cuenta",),
      style: estiloBoton(context),
      onPressed: ()=>presionarSingUp(context));
}

// Boton Sing In
Widget boton_sing_in(BuildContext context){
  return ElevatedButton(child: Text("Iniciar sesión",),
      style: estiloBoton(context),
      onPressed: ()=>presionarSingIn(context));
}

// ? Acción de Boton Sing Up
void presionarSingUp(BuildContext context){
  Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ScreenSingUp()));
}

// ? Acción de Boton Sing In
void presionarSingIn(BuildContext context){
  Navigator.push(context,
    MaterialPageRoute(builder: (context)=> AuthPage()));
}

// Style ButtonStyle
ButtonStyle estiloBoton(BuildContext context){
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Theme.of(context).colorScheme.primary.withOpacity(0.5);
        }
        return null; // Use the component's default.
      },
    ),
  );
}