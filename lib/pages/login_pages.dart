import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';
import 'package:kpoma_messaging/services/navigation_service.dart';
import 'package:kpoma_messaging/widget/custom_input_field.dart';
import 'package:kpoma_messaging/widget/rounded_button.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _LoginPageState();
  }
}


class _LoginPageState extends State<LoginPage>{

  double _deviceHeight;
  double _deviceWidth;
  final _loginFormKey = GlobalKey<FormState>();
  String _email;
  String _password;
  AuthenticationProvider _authenticationProvider;
  NavigationService _navigationService;


  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService  = GetIt.instance.get<NavigationService>();
    //FirebaseAuth.instance.signOut();
    return _buildUI();
  }


  // function to build the login page UI
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
            _pageTitle(),
            SizedBox(
                height: _deviceHeight*0.02
            ),
            _loginForm(),
            SizedBox(
                height: _deviceHeight*0.02
            ),
            _loginButton(),
            SizedBox(
                height: _deviceHeight*0.02
            ),
            _registerAccountLink()

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
        "Kpoma Message",
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  // function to create login form
  Widget _loginForm(){
    return Container(
      height: _deviceHeight *0.24,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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


  // function to return login button
  Widget _loginButton(){
      return RoundedButton(
        name: "LOGIN",
        height: _deviceHeight *0.065,
        width: _deviceWidth *0.65,
        onPressed: () {
          if(_loginFormKey.currentState.validate()){
            _loginFormKey.currentState.save();
            _authenticationProvider.loginUsingEmailAndPassword(_email, _password);
          }
        },
      );
  }

  // function to return login button
  Widget _registerAccountLink(){
    return GestureDetector(
      child: Container(
        child: Text(
          "Don't have an account",
          style: TextStyle(
              color: Colors.white54
          ),
        ),
      ),
      onTap: ()=> _navigationService.navigateToRoute("/register")
    );
  }
}