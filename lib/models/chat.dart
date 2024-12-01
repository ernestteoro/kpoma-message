import 'package:kpoma_messaging/models/chat_message.dart';
import 'package:kpoma_messaging/models/user.dart';

class Chat{

  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<Users> members;
  final List<ChatMessage> messages;
  List<Users> recepient;

  Chat({
    this.uid,
    this.currentUserUid,
    this.activity,
    this.members,
    this.messages,
    this.group
  }){
    recepient = members.where((_i) => uid != currentUserUid).toList();
  }

  List<Users> recepients(){
    return recepient;
  }

  String title(){
    return group? recepient.first.name : recepient.map((_user) => _user.name).join(",");
  }

  String imageUrl(){
    return group? recepient.first.imageUrl : "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
  }

}