import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kpoma_messaging/services/database_service.dart';

import 'package:kpoma_messaging/services/navigation_service.dart';
import 'package:kpoma_messaging/services/media_service.dart';
import 'package:kpoma_messaging/services/cloud_storage_service.dart';

class  SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  SplashScreen({Key key, this.onInitializationComplete}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_){
      _setup().then((_) => widget.onInitializationComplete());
    });

  }


  // A function to setup configuration and move to login page
  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  // A function to register services
  void _registerServices(){
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance.registerSingleton<CloudStorageService>(CloudStorageService());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kpoma Message',
      theme: ThemeData(
          backgroundColor: Color.fromRGBO(150,75,10,1.0),
          scaffoldBackgroundColor:  Color.fromRGBO(150,75,10,1.0)
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage("assets/images/logo_chat.png"),
              ),
              borderRadius: BorderRadius.all(Radius.circular(55.0))
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

} 