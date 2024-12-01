import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kpoma_messaging/services/cloud_storage_service.dart';

import 'package:kpoma_messaging/services/database_service.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';
import 'package:kpoma_messaging/models/chat_message.dart';
import 'package:kpoma_messaging/models/chat.dart';
import 'package:kpoma_messaging/models/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kpoma_messaging/services/media_service.dart';
import 'package:kpoma_messaging/services/navigation_service.dart';



class ChatPageProvider extends ChangeNotifier{
  AuthenticationProvider _authenticationProvider;
  DatabaseService _databaseService;
  CloudStorageService _cloudStorageService;
  MediaService _mediaService;
  NavigationService _navigationService;
  ScrollController _messagesListViewController;
  String chatId;
  List<ChatMessage> messages;
  List<ChatMessage> chatsMessage;
  String _message;

  StreamSubscription _messagesStreams;
  StreamSubscription _keyboardVisibilityStream;
  KeyboardVisibilityController _keyboardVisibilityController;


  ChatPageProvider(this.chatId,this._authenticationProvider, this._messagesListViewController){
    _databaseService = GetIt.instance.get<DatabaseService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _keyboardVisibilityController = KeyboardVisibilityController();

    listenToMessages();
    listenToKeyboarChanges();
  }

  String getMessage(){
    return _message;
  }


  String setMessage(String message){
    this._message = message;
  }


  @override
  void dispose() {
    _messagesStreams.cancel();
    super.dispose();

  }

  void listenToMessages() async {
    try{
      _messagesStreams = _databaseService.streamMessagesForChat(chatId).listen((_snapshot) {
        List<ChatMessage>  _messages = _snapshot.docs.map((doc){
          return ChatMessage.fromDocument(doc);
        }).toList();
        messages = _messages;
        notifyListeners();
        // Add keyboard scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(_messagesListViewController.hasClients){
            _messagesListViewController.jumpTo(_messagesListViewController.position.maxScrollExtent);
          }
        });

      });
    }catch(e){
      print(e);
    }

  }

  void listenToKeyboarChanges(){
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen((_keyBoardEvent) {
      _databaseService.updateChatData(chatId,{
        "is_activity": _keyBoardEvent
      });
    });
  }

  void sendTextMessage(){
    if(_message!=null || _message.isNotEmpty){
      ChatMessage _messageToSend = ChatMessage(
          content: _message,
          type: MessageType.TEXT,
          senderID: _authenticationProvider.user.uid,
          sentTime: DateTime.now()
      );

      print(chatId);
      _databaseService.addMessage(chatId, _messageToSend);

    }
  }


  void sendImageMessage() async {
    try{
      PlatformFile _file = await _mediaService.pickImageFromLibrary();
      if(_file!=null){
        print(" Data before saving them");
        print(_file.path);
        print(_authenticationProvider.user.uid);
        print(chatId);
        String _downloadImageUrl = await _cloudStorageService.saveChatImageToStorage(chatId, _authenticationProvider.user.uid,_file);
        ChatMessage _messageToSend = ChatMessage(
            content: _downloadImageUrl,
            type: MessageType.IMAGE,
            senderID: _authenticationProvider.user.uid,
            sentTime: DateTime.now()
        );
        _databaseService.addMessage(chatId, _messageToSend);
      }
    }catch(e){
      print(e);
    }
  }


  void deleteChat(){
    goBack();
    _databaseService.deleteChat(chatId);
  }

  void goBack(){
    _navigationService.goBack();
  }
}