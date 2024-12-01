import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION="users";

class CloudStorageService{

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  CloudStorageService(){}


  Future<String> saveUserImageToStorage(String uid, PlatformFile file) async{
   try{
     Reference ref  = _firebaseStorage.ref().child("images/users/$uid/profile.${file.extension}");
     UploadTask uploadTask = ref.putFile(File(file.path));
     return await uploadTask.then((_result){
       return _result.ref.getDownloadURL();
     });
   }catch(e){
     print(e);
   }
   return null;
  }


  Future<String> saveChatImageToStorage(String chatId, String userId, PlatformFile file) async{
    try{
      Reference ref  = _firebaseStorage.ref().child("images/chats/$chatId/${userId}_${Timestamp.now().microsecondsSinceEpoch}.${file.extension}");
      UploadTask uploadTask = ref.putFile(File(file.path));
      return await uploadTask.then((_result){
        return _result.ref.getDownloadURL();
      });
    }catch(e){
      print(e);
    }
    return null;
  }


}