import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:kpoma_messaging/models/user.dart';
import 'package:kpoma_messaging/services/database_service.dart';
import 'package:kpoma_messaging/services/navigation_service.dart';


class AuthenticationProvider extends ChangeNotifier{
  FirebaseAuth _auth;
  NavigationService _navigationService;
  DatabaseService _databaseService;
  Users user;

  AuthenticationProvider(){
    this._auth = FirebaseAuth.instance;
    this._navigationService = GetIt.instance.get<NavigationService>();
    this._databaseService  = GetIt.instance.get<DatabaseService>();
    this._auth.authStateChanges().listen((_user) {
      print(_user);
      if(_user!=null){
          this._databaseService.getUser(_user.uid).then((snapshot){
            if(snapshot.exists){
              this._databaseService.updateUserLastSeenTime(_user.uid);
              user =Users.fromDocument(snapshot);
              this._navigationService.removeAndNavigateToRoute("/home");
            }
        });
      }else{
        this._navigationService.removeAndNavigateToRoute("/login");
      }
    });


  }

  Future<void> loginUsingEmailAndPassword(String _email, String _password) async {
    try{
      await this._auth.signOut();
      await _auth.signInWithEmailAndPassword(email: _email, password: _password).then((_user){
        this._databaseService.getUser(_user.user.uid).then((snapshot){
          if(snapshot.exists){
            this._databaseService.updateUserLastSeenTime(_user.user.uid);
            user =Users.fromDocument(snapshot);
            this._navigationService.removeAndNavigateToRoute("/home");
          }
        });
      });
    } on FirebaseException{
      print(" Error in login in with email and password to firebase");
    }catch(e){
      print(e);
    }
  }

  Future<String> registerUsingEmailAndPassword(String _email, String _password) async {
    try{
      UserCredential _userCredential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
      return _userCredential.user.uid;
    } on FirebaseException{
      print(" Error in login in with email and password to firebase");
    }catch(e){
      print(e);
    }
    return null;
  }


  Future<String> logOut() async {
    try{
      await _auth.signOut();
    } on FirebaseException{
      print(" Error in login in with email and password to firebase");
    }catch(e){
      print(e);
    }
  }

}