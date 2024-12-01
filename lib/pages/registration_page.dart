import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';
import 'package:kpoma_messaging/services/cloud_storage_service.dart';
import 'package:kpoma_messaging/services/database_service.dart';
import 'package:kpoma_messaging/services/navigation_service.dart';
import 'package:kpoma_messaging/services/media_service.dart';
import 'package:kpoma_messaging/widget/custom_input_field.dart';
import 'package:kpoma_messaging/widget/rounded_button.dart';
import 'package:kpoma_messaging/widget/rounded_image.dart';
import 'package:provider/provider.dart';


class RegistrationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}


class _RegistrationPageState extends State<RegistrationPage>{

  double _deviceHeight;
  double _deviceWidth;
  final _registerFormKey = GlobalKey<FormState>();
  PlatformFile _profileImageFile;
  String _name;
  String _email;
  String _password;
  AuthenticationProvider _authenticationProvider;
  NavigationService _navigationService;
  DatabaseService _databaseService;
  CloudStorageService _cloudStorageService;


  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService  = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    return _buildUI();
  }


  // function to build the register page UI
  Widget _buildUI(){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight *0.03
        ),
        height: _deviceHeight * 0.98,
        width:  _deviceWidth * 0.97,
        child: Column(
          mainAxisSize:  MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerForm(),
            SizedBox(
                height: _deviceHeight*0.04
            ),
            _registerButton(),
          ],
        ),

      ),
    );
  }

  // function to return the page title
  Widget _pageTitle(){
    return Container(
      height: _deviceHeight *0.10,
      child: Text(
        "Create an account",
        style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  // function to create register form
  Widget _registerForm(){
    return Container(
      height: _deviceHeight *0.40,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            CustomTextFormField(
              onSaved:(_value){
                setState(() {
                  _name =_value;
                });
              },
              regEx: r".{6,}",
              hintText: "Name",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved:(_value){
                setState(() {
                  _email =_value;
                });
              },
              regEx: r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved:(_value){
                setState(() {
                  _password =_value;
                });
              },
              regEx: r".{6,}",
              hintText: "Password",
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  // function to add profile image
  Widget _profileImageField(){
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((_file){
          setState(() {
            _profileImageFile =_file;
          });
        });
      },
      child: (){
        if(_profileImageFile!=null){
          return RoundedImageFile(
              key: UniqueKey(),
              image: _profileImageFile,
              size: _deviceWidth*.15
          );
        }else{
          return RoundedNetworkImage(
              key: UniqueKey(),
              imagePath: "https://i.pravatar.cc/1000?img=2",
              size: _deviceWidth*.15
          );
        }
      }(),
    );
  }

  // function to return register button
  Widget _registerButton(){
    return RoundedButton(
      name: "Register",
      height: _deviceHeight *0.065,
      width: _deviceWidth *0.65,
      onPressed: () async {
        if(_registerFormKey.currentState.validate() && _profileImageFile!=null){
          _registerFormKey.currentState.save();
          await _authenticationProvider.registerUsingEmailAndPassword(_email, _password).then((_uid) async {
            if(_uid!=null){
                await _cloudStorageService.saveUserImageToStorage(_uid, _profileImageFile).then((_imageDownloadUr) async {
                await _databaseService.createUser(_uid, _email, _name, _imageDownloadUr);
                _navigationService.goBack();
              });
            }
          });
        }
      },
    );
  }

}