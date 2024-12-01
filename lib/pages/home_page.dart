
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpoma_messaging/pages/chats_page.dart';
import 'package:kpoma_messaging/pages/user_page.dart';

class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{

  int _currentPage =0;
  List<Widget> _pages=[
    ChatsPage(),
    UserPage()
  ];


  @override
  Widget build(BuildContext context) {
   return _buildUI();
  }


  // function to build home UI
  Widget _buildUI(){
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index){
          setState(() {
            _currentPage = _index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: "Chats",
              icon: Icon(Icons.chat_bubble_sharp)
          ),
          BottomNavigationBarItem(
              label: "Users",
              icon: Icon(Icons.supervised_user_circle_sharp)
          )
        ],
      ),
    );
  }
}