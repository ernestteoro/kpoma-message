import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget{
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  CustomTextFormField({
    this.onSaved,
    this.regEx,
    this.hintText,
    this.obscureText
  });


  @override
  Widget build(BuildContext context) {
   return TextFormField(
     onSaved: (_value) => onSaved(_value),
     cursorColor: Colors.white,
     style: TextStyle(
       color: Colors.white
     ),
     obscureText: obscureText,
     validator: (_value){
       return RegExp(regEx).hasMatch(_value)? null : 'Enter a valid value';
     },
     decoration: InputDecoration(
       filled: true,
       fillColor:Color.fromRGBO(30,29, 37, 1.0),// Color.fromRGBO(110,80,15,1.0),
       border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(15.0),
         borderSide: BorderSide.none
       ),
       hintText: hintText,
       hintStyle: TextStyle(
         color: Colors.white54
       ),
       errorStyle: TextStyle(
         color: Colors.white54
       )
     ),
   );
  }

}

class CustomTextField extends StatelessWidget{
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController editingController;
  IconData icon;

  CustomTextField({
    this.onEditingComplete,
    this.hintText,
    this.obscureText,
    this.editingController,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      onEditingComplete:()=> onEditingComplete(editingController.value.text),
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white54
        ),
        prefixIcon: Icon(icon,color: Colors.white54)
      ),

    );
  }


}