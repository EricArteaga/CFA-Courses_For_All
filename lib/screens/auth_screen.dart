import 'package:cfa_coursesforall/screens/screen_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return ScreenSingIn();
          }
        },

    ),
    );
  }
}