
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kpoma_messaging/models/chat_message.dart';

const String USER_COLLECTION="users";
const String CHAT_COLLECTION="chats";
const String MESSAGE_COLLECTION="messages";

class DatabaseService{

  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseService(){
  }

  Future<DocumentSnapshot> getUser(String _uid) async{
    return await db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<QuerySnapshot> getUsers(String _name){
    Query _query = db.collection(USER_COLLECTION);
    if(_name!=null){
      _query = _query.where("name",isGreaterThanOrEqualTo: _name)
          .where("name",isLessThanOrEqualTo: _name+"z");

    }
    return _query.get();
  }

  Future<void> updateUserLastSeenTime(String _uid) async{
    try{
      await  db.collection(USER_COLLECTION).doc(_uid).update({
        "lastActive" : DateTime.now().toUtc()
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> createUser(String uid, String email, String name, String imageUrl) async{
    try{
      await  db.collection(USER_COLLECTION).doc(uid).set({
        "uid":uid,
        "email":email,
        "name":name,
        "imageUrl":imageUrl,
        "lastActive":DateTime.now().toUtc()
      });
    }catch(e){
      print(e);
    }
  }

  Stream<QuerySnapshot> getChatForUser(String _uid){
    return db.collection(CHAT_COLLECTION).where('members', arrayContains: _uid).snapshots();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatId){
    return db.collection(CHAT_COLLECTION)
        .doc(_chatId).collection(MESSAGE_COLLECTION).where('sentTime',isEqualTo: DateTime.now())
        .orderBy('sentTime',descending: false)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatId){
    return db.collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy('sentTime',descending: true)
        .limit(1).get();
  }

  Future<void> addMessage(String _chatId, ChatMessage _chatMessage) async{
    try{
      await db.collection(CHAT_COLLECTION)
          .doc(_chatId).collection(MESSAGE_COLLECTION).add({
            "senderID":_chatMessage.senderID,
            "type":_chatMessage.type==MessageType.TEXT? "text":"image",
            "content":_chatMessage.content,
            "sentTime":_chatMessage.sentTime
          });
    }catch(e){
      print(e);
    }
  }

  Future<void> updateChatData(String _chatId, Map<String, dynamic> _data) async{
    try{
      await db.collection(CHAT_COLLECTION).doc(_chatId).update(_data);
    }catch(e){
      print(e);
    }
  }

  Future<void> deleteChat(String _chatId) async{
    await db.collection(CHAT_COLLECTION)
        .doc(_chatId)
        .get().then((doc){
          if(doc.exists){
            doc.reference.delete();
          }
    });
  }

  Future<DocumentReference> createChat(Map<String , dynamic> _data) async{
    try{
      DocumentReference _chatReference = await db.collection(CHAT_COLLECTION).add(_data);
      return _chatReference;
    }catch(e){
      print(e);
    }

  }

}