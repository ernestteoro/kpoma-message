import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kpoma_messaging/widget/custom_list_view_tiles.dart';
import 'package:kpoma_messaging/widget/top_bar.dart';


import 'package:kpoma_messaging/models/chat.dart';
import 'package:kpoma_messaging/models/chat_message.dart';

import 'package:kpoma_messaging/provider/authentication_provider.dart';
import 'package:kpoma_messaging/provider/chat_page_provider.dart';
import 'package:kpoma_messaging/widget/custom_input_field.dart';

class ChatPage extends StatefulWidget{
  final Chat chat;

  ChatPage({this.chat});

  @override
  State<StatefulWidget> createState() {
    return _ChatPage();
  }


}

class _ChatPage extends State<ChatPage>{

  double _deviceHeight;
  double _deviceWidth;
  GlobalKey<FormState> _messageFormKey;
  AuthenticationProvider _authenticationProvider;
  ChatPageProvider _chatPageProvider;
  ScrollController _messageViewListController;

  @override
  void initState() {
    super.initState();
    _messageFormKey = GlobalKey<FormState>();
    _messageViewListController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chat.uid);
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatPageProvider>(
              create: (_) => ChatPageProvider(
                  this.widget.chat.uid,
                  _authenticationProvider,
                  _messageViewListController
              )
          ),
    ],
      child: _buildUI(),
    );
  }

  Widget _buildUI(){

    return Builder(
        builder: (BuildContext _context){
          _chatPageProvider = _context.watch<ChatPageProvider>();
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: _deviceWidth*0.03,
                    vertical: _deviceHeight*0.02
                ),
                width: _deviceWidth *0.97,
                height: _deviceHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TopBar(
                      this.widget.chat.title(),
                      fontSize: 14,
                      primaryAction: IconButton(
                          onPressed: (){
                            _chatPageProvider.deleteChat();
                          },
                          icon: Icon(
                              Icons.delete,
                              color: Colors.blue
                          )
                      ),
                      secondaryAction: IconButton(
                          onPressed: (){
                            _chatPageProvider.goBack();
                          },
                          icon: Icon(
                              Icons.arrow_back,
                              color: Colors.blue
                          )
                      ),
                    ),
                    _messagesListView(),
                    _sendMessageForm()
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _sendMessageForm(){
    return Container(
      height: _deviceHeight*0.055,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30,29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth*0.004,
          vertical: _deviceHeight*0.03
      ),

      child: Form(
        key: _messageFormKey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton()
          ],
        ),
      ),

    );
  }

  Widget _messageTextField(){
    return SizedBox(
      width: _deviceWidth*0.70,
      child: CustomTextFormField(
        obscureText: false,
        hintText: "Type a message ...",
        regEx: r"^(?!\s*$).+",
        onSaved: (_value){
          _chatPageProvider.setMessage(_value);
        },
      ),
    );
  }

  Widget _sendMessageButton(){
    final double _size = _deviceHeight*0.055;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        icon: Icon(
          Icons.send, color: Colors.white
        ),
        onPressed: (){
          if(_messageFormKey.currentState.validate()){
            _messageFormKey.currentState.save();
            _chatPageProvider.sendTextMessage();
            _messageFormKey.currentState.reset();
          }
        },
      ),
    );

  }

  Widget _imageMessageButton(){
    final double _size = _deviceHeight*0.055;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: (){
          print("Inside image button message");
          _chatPageProvider.sendImageMessage();
        },
        child: Icon(Icons.camera_enhance),
      ),
    );
  }



  Widget _messagesListView(){
    if(_chatPageProvider.messages!=null){
      if(_chatPageProvider.messages.isNotEmpty){
        return Container(
          height: _deviceHeight*0.74,
          child: ListView.builder(
              controller: _messageViewListController,
              itemCount: _chatPageProvider.messages.length,
              itemBuilder: (BuildContext _context, int index){
                ChatMessage msg = _chatPageProvider.messages[index];
                bool isOwnMessage = msg.senderID == _authenticationProvider.user.uid;
                return Container(
                  child: CustomChatListViewTile(
                    deviceHeight: _deviceHeight,
                    width: _deviceWidth*0.80,
                    message: msg,
                    isOwnMessage: isOwnMessage,
                    sender: this.widget.chat.members.where((_u)=> _u.uid==msg.senderID).first,
                  ),
                );
          }),
        );
      }else{
        return Center(
          child: Container(
            child: Text(" No messages to display"),
          ),
        );
      }
    }else{
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }
}
