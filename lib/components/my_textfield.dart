import 'package:flutter/material.dart';

/*
 *  MyTextField te crea un campo de formulario
 */
class MyTextFormField extends StatelessWidget{
  final TextEditingController controller;
  final String labelText;
  final bool? obscureText;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool? autofocus;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText,
    required this.onSaved,
    required this.validator,
    this.autofocus,
  });

  @override
  Widget build(BuildContext context){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureTextCorrect(this.obscureText),
        autofocus: autofocusCorrect(this.autofocus),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          labelText: labelText,
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}

bool obscureTextCorrect(bool? obscureText){
  return obscureText == null ? false : obscureText;
}

bool autofocusCorrect(bool? autofocus){
  return autofocus == null ? false : autofocus;
}
// onSaved: (value) {
    //       if(value != null) {
    //         _email = value;
    //       }
    //     },
    //     autofocus: true,
    //     validator: (value) {
    //       if(value == null) {
    //         return 'El Email no puede estar vacio';
    //       } else if(value.isEmpty) {
    //         return 'El Email no puede estar vacio';
    //       } else {
    //         return null;
    //       }
    //     },
