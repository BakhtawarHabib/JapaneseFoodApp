import 'package:flutter/material.dart';

class StyleFunctions {
  ///Decoration Function for form Text Field
  InputDecoration formTextFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey)),
    );
  }

  TextStyle formFieldTextStyle(){
    return TextStyle(fontSize: 18);
  }
}
