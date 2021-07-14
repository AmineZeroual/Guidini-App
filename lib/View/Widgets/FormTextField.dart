import 'package:flutter/material.dart';


class FormTextField extends StatelessWidget {
  final String hint;
  final Function validator;
  final Function function;
final bool abscur;

  const FormTextField({this.hint, this.validator, this.function, this.abscur});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: abscur,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Spartan5',
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusColor: Colors.white,
        hintText: hint,
        hoverColor: Colors.white,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      validator: validator,
      onChanged: function,
    );
  }
}