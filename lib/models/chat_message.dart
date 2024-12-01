import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType{
  TEXT,
  IMAGE,
  UNKNOWN
}

class ChatMessage{
  final String senderID;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({this.senderID, this.type,this.content, this.sentTime});

  factory ChatMessage.fromDocument(DocumentSnapshot doc){

    MessageType messageType;
    switch(doc["type"]){
      case "text":
        messageType = MessageType.TEXT;
        break;
      case "image":
        messageType = MessageType.IMAGE;
        break;
      default:
        messageType = MessageType.UNKNOWN;
        break;
    }

    List<String> items = doc["senderID"].toString().replaceAll("[", "").split("},");
    print("======================== items length =======================");

    items.forEach((element) {
      print(jsonDecode(element));
      jsonDecode(element);
    });

    return ChatMessage(
      senderID: doc["senderID"],
      type: messageType,
      content: doc["content"],
      sentTime: doc["sentTime"].toDate(),
    );
  }

  Map<dynamic, dynamic> toJson(){
    String messageType;
    switch(type){
      case MessageType.TEXT:
        messageType = "text";
        break;
      case MessageType.IMAGE:
        messageType = "image";
        break;
      default:
        messageType = "unknown";
        break;
    }
    return {
      "senderID":senderID,
      "type":messageType,
      "content":content,
      "sentTime":Timestamp.fromDate(sentTime)
    };
  }
}