import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:kpoma_messaging/services/cloud_storage_service.dart';
import 'package:kpoma_messaging/services/database_service.dart';
import 'package:kpoma_messaging/services/media_service.dart';
import 'package:kpoma_messaging/services/navigation_service.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';


import 'package:kpoma_messaging/models/user.dart';
import 'package:kpoma_messaging/models/chat.dart';


import 'package:kpoma_messaging/pages/chat_page.dart';


class UsersPageProvider extends ChangeNotifier{

  AuthenticationProvider _authenticationProvider;
  DatabaseService _databaseService;
  //CloudStorageService _cloudStorageService;
  //MediaService _mediaService;
  NavigationService _navigationService;
  ScrollController _messagesListViewController;
  List<Users> users;
  List<Users> _selectedUsers;
  String _message;


  UsersPageProvider(this._authenticationProvider){
    _selectedUsers=[];
    _databaseService = GetIt.instance.get<DatabaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  List<Users> getSelectedUsers(){
    return _selectedUsers;
  }

  void getUsers({String name}){
    _selectedUsers=[];
    try{
      _databaseService.getUsers(name).then((_snapshot){
        users=_snapshot.docs.map((doc){
          return Users.fromDocument(doc);
        }).toList();
        notifyListeners();

      });
    }catch(e){
      
    }
  }

  void updateSelectedUsers(Users user){
    if(_selectedUsers.contains(user)){
      _selectedUsers.remove(user);
    }else{
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async{
    try{
      List<String> _memberIds = _selectedUsers.map((_user){
        return _user.uid;
      }).toList();
      _memberIds.add(_authenticationProvider.user.uid);
      bool isGroup = _selectedUsers.length>1;

      DocumentReference documentReference= await _databaseService.createChat({
        "is_group": isGroup,
        "is_activity" :false,
        "members" : _memberIds
      });

      // Navigate to chat page
      List<Users> members = [];
      for(var uid in _memberIds){
        DocumentSnapshot _userSnapshot = await _databaseService.getUser(uid);
        members.add(Users.fromDocument(_userSnapshot));
        ChatPage _chatPage = ChatPage(
            chat: Chat(
                uid: documentReference.id,
                currentUserUid: _authenticationProvider.user.uid,
                group:isGroup,
                messages: [],
                activity: false,
                members: members
            )
        );
        _selectedUsers=[];
        notifyListeners();
        _navigationService.navigateToPage(_chatPage);

      }

    }catch(e){
      print(e);
    }

  }



}