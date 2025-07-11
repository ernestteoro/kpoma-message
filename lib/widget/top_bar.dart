import 'package:flutter/material.dart';

class TopBar extends StatelessWidget{
  String barTitle;
  Widget primaryAction;
  Widget secondaryAction;
  double fontSize;
  double _deviceHeight;
  double _deviceWidth;

  TopBar(this.barTitle, {
        this.primaryAction,
        this.secondaryAction,
        this.fontSize=35
 });


  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceHeight *0.10,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(secondaryAction!=null) secondaryAction,
          _titleBAr(),
          if(primaryAction!=null) primaryAction,

        ],
      ),
    );
  }

  _titleBAr() {
    return Text(
      barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w700
      ),
    );
  }
}