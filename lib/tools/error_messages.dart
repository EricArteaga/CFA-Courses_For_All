
import 'package:flutter/material.dart';

void wrongEmailMessage(BuildContext context){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Email incorrecto'),
        content: const Text('Por favor, introduce un email que pertenezca a una cuenta'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    }
  );
}

void wrongPasswordMessage(BuildContext context){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contraseña incorrecta'),
          content: Text('Por favor, introduce bien la contraseña'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
  );
}