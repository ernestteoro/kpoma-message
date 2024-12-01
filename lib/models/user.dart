import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final DateTime lastActive;

  Users({
    this.uid,
    this.name,
    this.email,
    this.imageUrl,
    this.lastActive,
  });

  factory Users.fromDocument(DocumentSnapshot doc){
   return Users(
     uid: doc["uid"],
      name: doc["name"],
      email: doc["email"],
      imageUrl: doc["imageUrl"],
      lastActive: doc["lastActive"].toDate(),
    );
  }

  Map<dynamic, dynamic> toJson(){
    return {
      "email":email,
      "name":name,
      "imageUrl":imageUrl,
      "lastActive":lastActive
    };
  }

  String lastDayActive(){
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }
 bool wasRecentlyActive(){
    return DateTime.now().difference(lastActive).inHours < 1;
  }


}