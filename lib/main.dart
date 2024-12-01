import 'package:flutter/material.dart';
import 'package:kpoma_messaging/pages/login_pages.dart';
import 'package:kpoma_messaging/pages/registration_page.dart';
import 'package:kpoma_messaging/pages/splash_creen.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';

import 'package:kpoma_messaging/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:kpoma_messaging/pages/home_page.dart';


void main() {
  runApp(SplashScreen(key: UniqueKey(),onInitializationComplete:(){
    runApp(MainApp());
  }));
}


class MainApp extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(create: (BuildContext _context){
          return AuthenticationProvider();
        })
      ],
      child: MaterialApp(
        title: 'Kpoma Message',
        theme: ThemeData(
            backgroundColor: Color.fromRGBO(150,75,10,1.0),
            scaffoldBackgroundColor:  Color.fromRGBO(150,75,10,1.0),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Color.fromRGBO(110,80,15,1.0)
            )
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login':(BuildContext _context)=> LoginPage(),
          '/register':(BuildContext _context) => RegistrationPage(),
          '/home':(BuildContext _context) => HomePage(),
        },
      ),
    );
  }
}

