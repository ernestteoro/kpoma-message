import 'package:flutter/material.dart';
import 'package:kpoma_messaging/models/chat.dart';
import 'package:kpoma_messaging/models/chat_message.dart';
import 'package:kpoma_messaging/models/user.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';
import 'package:kpoma_messaging/widget/top_bar.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:kpoma_messaging/widget/custom_list_view_tiles.dart';
import 'package:kpoma_messaging/provider/chats_page_provider.dart';
import 'package:kpoma_messaging/services/navigation_service.dart';

import 'chat_page.dart';


class ChatsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return _ChatsPageState();
  }
}


class _ChatsPageState  extends State<ChatsPage>{

  double _deviceHeight;
  double _deviceWidth;
  final _registerFormKey = GlobalKey<FormState>();
  AuthenticationProvider _authenticationProvider;
  ChatsPageProvider _chatPageProvider;
  NavigationService _navigationService;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService  = GetIt.instance.get<NavigationService>();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_authenticationProvider),
        )
      ],
      child: buildUI(),
    );
  }


  // function to build
  buildUI(){
    return Builder(builder: (BuildContext _context){
      _chatPageProvider = _context.watch<ChatsPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            vertical: _deviceHeight*0.02,
            horizontal: _deviceWidth*0.03
        ),
        height: _deviceHeight * 0.98,
        width:  _deviceWidth * 0.97,
        child: Column(
          mainAxisSize:  MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              "Chats",
              primaryAction: IconButton(
                icon: Icon(Icons.logout),
                color: Colors.white,
                onPressed: (){
                  _authenticationProvider.logOut();
                },
              ),
            ),
            _chatsList(),

          ],
        ),
      );
    });
  }

  Widget _chatsList(){
    List<Chat> _chats =_chatPageProvider.chats;

    return Expanded(
        child:((){
          if(_chats!=null){
            if(_chats.isNotEmpty){
              return ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: (BuildContext _context, int index){
                  return _chatTile(_chats[index]);
                });
            }else{
              return Text(
                "No chat found",
                style: TextStyle(color: Colors.white),
              );
            }
          }else{
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        })()
    );
  }

  Widget _chatTile(Chat chat){
    List<Users> _recepients = chat.recepients();
    bool _isActive = _recepients.any((r) => r.wasRecentlyActive());
    String _subtitleText ="";
    if(chat.messages.isNotEmpty){
      _subtitleText = chat.messages.first.type!=MessageType.TEXT ? "Media Attachment": chat.messages.first.content;
    }

    return CustomListViewTileAvivity(
      height: _deviceHeight*0.10,
      title:chat.title(),
      subTitle: _subtitleText,
      isActive: _isActive,
      isActivity: chat.activity,
      onTap: (){
        _navigationService.navigateToPage(ChatPage(chat: chat,));
      },
      imagePath: chat.imageUrl(),
    );
  }

}