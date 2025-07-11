import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget{
  final String name;
  final double height;
  final double width;
  final Function onPressed;

  RoundedButton({this.name, this.height, this.width, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height*0.25),
          color: Color.fromRGBO(110,80,15,1.0)
      ),
      child: TextButton(
        onPressed:()=> onPressed(),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            height: 1.5
          ),
        ),
      ),
    );
  }
}