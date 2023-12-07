

import 'dart:async';

import 'package:flutter/material.dart';

/*
 * Dialogo de confirmación de eliminar un Curso
 */
Future<bool> confirmDeleteCourseMessage(BuildContext context) async{
Completer<bool> completer = Completer<bool>();

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: const Text("Eliminar Curso",
              style: TextStyle(color:  Colors.white70)),
          content: const Text("¿Estás seguro de eliminar el curso?",
              style: TextStyle(color:  Colors.white70)),
          actions: <Widget>[

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
              child: const Text('No, me lo he pensado mejor',
                  style: TextStyle(color:  Colors.white70)),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(true);
              },
              child: const Text('Sí, estoy seguro',
                  style: TextStyle(color:  Colors.redAccent)),
            ),
          ],
        );
      }
  );

  return completer.future;
}