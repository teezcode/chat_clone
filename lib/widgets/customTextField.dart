import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String ? hintText;
  final String? Function(String?) ? validator;
  final TextEditingController ?  controller;

  const CustomTextField({
    this.hintText,
    Key? key, this.controller, this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: Colors.white54,
      ),
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white54),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
          )
      ),
    );
  }
}

TextStyle simpleTextstyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 16
  );
}

TextStyle mediumTextstyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 17
  );
}