import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kpoma_messaging/services/database_service.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';
import 'package:kpoma_messaging/models/chat_message.dart';
import 'package:kpoma_messaging/models/chat.dart';
import 'package:kpoma_messaging/models/user.dart';


class ChatsPageProvider extends ChangeNotifier{
  AuthenticationProvider _authenticationProvider;
  DatabaseService _databaseService;

  List<Chat> chats;
  StreamSubscription _chatsStreams;


  ChatsPageProvider(this._authenticationProvider){
    _databaseService = GetIt.instance.get<DatabaseService>();
    getChats();
  }


  @override
  void dispose() {
    _chatsStreams.cancel();
    super.dispose();

  }

  void getChats() async {
    try{
      _chatsStreams= _databaseService.getChatForUser(_authenticationProvider.user.uid)
          .listen((_snapshot) async {
            chats = await  Future.wait(_snapshot.docs.map((doc) async {
              Map<String, dynamic> chatData = doc.data() as Map<String, dynamic>;
              List<Users> members=[];
              for(var uid in chatData['members']){
                DocumentSnapshot userSnapshot = await _databaseService.getUser(uid);
                members.add(Users.fromDocument(userSnapshot));
              }

              List<ChatMessage> messages=[];
              QuerySnapshot chatMessages = await _databaseService.getLastMessageForChat(doc.id);
              if(chatMessages.docs.isNotEmpty){
                print(chatMessages.docs.first);
                ChatMessage chatMessage = ChatMessage.fromDocument(chatMessages.docs.first);
                messages.add(chatMessage);
              }

              return Chat(
                  uid: doc.id,
                  currentUserUid: _authenticationProvider.user.uid,
                  members: members,
                  messages: messages,
                  activity: chatData['is_activity'],
                  group: chatData['is_group']
              );
            }).toList());
            notifyListeners();
      });

    }catch(e){
      print(e);
    }
  }

}