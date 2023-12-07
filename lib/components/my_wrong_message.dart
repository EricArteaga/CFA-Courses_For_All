import 'package:flutter/material.dart';

/* *
*  MyWorngMessage te crea un campo de formulario
*
*
* */
class MyWrongMessage extends StatelessWidget{
final String title;
final String content;

  const MyWrongMessage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(title,
            style: const TextStyle(color:  Colors.white70)),
        content: Text(content,
            style: const TextStyle(color:  Colors.white70)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK',
            style: TextStyle(color:  Colors.white70)),
          ),
        ],
      );
  }
}

