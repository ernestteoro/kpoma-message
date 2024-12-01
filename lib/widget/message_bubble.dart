import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeage;

import 'package:kpoma_messaging/models/chat_message.dart';

class TextMessageBubble extends StatelessWidget{

  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  TextMessageBubble({
    this.isOwnMessage,
    this.message,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage ? [Color.fromRGBO(0,136, 249, 1.0),Color.fromRGBO(0,82, 280, 1.0)]: [Color.fromRGBO(51,49, 68, 1.0),Color.fromRGBO(51,49, 68, 1.0)];
    return Container(
      height: height + (message.content.length)/20*6.0,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30,0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          Text(
            timeage.format(message.sentTime),
            style: TextStyle(
                color: Colors.white70
            ),
          )
        ],
      ),
    );
  }

}



class ImageMessageBubble extends StatelessWidget{

  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  ImageMessageBubble({
    this.isOwnMessage,
    this.message,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage ? [Color.fromRGBO(0,136, 249, 1.0),Color.fromRGBO(0,82, 280, 1.0)]: [Color.fromRGBO(51,49, 68, 1.0),Color.fromRGBO(51,49, 68, 1.0)];
    DecorationImage _image = DecorationImage(
        image: NetworkImage(message.content),
        fit: BoxFit.cover
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width*0.02, vertical: height*0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: _colorScheme,
              stops: [0.30,0.70],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
           height: height,
           width: width,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),
             image: _image
           ),
         ),
          SizedBox(height: height*0.02,),
          Text(
            timeage.format(message.sentTime),
            style: TextStyle(
                color: Colors.white70
            ),
          )
        ],
      ),
    );
  }

}