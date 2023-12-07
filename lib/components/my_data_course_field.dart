import 'package:flutter/material.dart';

/*
 *  MyDataCourseField te crea un campo personalizado para los datos de los cursos
 */
class MyDataCourseField extends StatelessWidget{
  final TextEditingController controller;
  final String labelText;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool? enabled;

  const MyDataCourseField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onSaved,
    required this.validator,
    this.enabled,
  });

  @override
  Widget build(BuildContext context){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(
          color: enabled != null && enabled! ? Colors.black : Colors.black,
        ),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: enabled != null && enabled! ? Colors.black : Colors.black,
          ),
          labelText: labelText,
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}

