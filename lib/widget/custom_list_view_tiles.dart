import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kpoma_messaging/widget/message_bubble.dart';
import 'package:kpoma_messaging/widget/rounded_image.dart';
import 'package:kpoma_messaging/models/chat_message.dart';
import 'package:kpoma_messaging/models/user.dart';


class CustomListViewTileAvivity extends  StatelessWidget{

  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  CustomListViewTileAvivity({
    this.height,
    this.title,
    this.subTitle,
    this.imagePath,
    this.isActive,
    this.isActivity,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ()=> onTap(),
      minVerticalPadding: height*0.20,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w500
        ),
      ),
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        size: height/2,
        imagePath: imagePath,
        isActive: isActive,
      ),
      subtitle: isActivity ? Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitThreeBounce(
            color: Colors.black,
            size: height *0.10,
          )
        ],
      ): Text(
          subTitle,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w400
        ),
      )


    );
  }


}

class CustomChatListViewTile extends StatelessWidget{
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final Users sender;


  CustomChatListViewTile({
    this.width,
    this.deviceHeight,
    this.isOwnMessage,
    this.message,
    this.sender
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: isOwnMessage? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
         isOwnMessage ? Container():  RoundedNetworkImage(
           key: UniqueKey(),
           imagePath: sender.imageUrl,
           size: width*0.08,
         ),
          SizedBox(width: 0.05,),
          message.type==MessageType.TEXT?
          TextMessageBubble(
            isOwnMessage: isOwnMessage,
            height: deviceHeight*0.06,
            width: width,
            message: message,
          ):
          ImageMessageBubble(
            isOwnMessage: isOwnMessage,
            height: deviceHeight*0.30,
            width: width *0.55,
            message: message,
          )
        ],
      ),
    );
  }

}

class CustomListViewTile extends StatelessWidget{
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;

  CustomListViewTile({
    this.height,
    this.title,
    this.subTitle,
    this.imagePath,
    this.isActive,
    this.isSelected,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSelected ? Icon(Icons.check, color: Colors.white,) : null,
      onTap: ()=> onTap(),
      minVerticalPadding: height*0.20,
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        size: height/2,
        imagePath: imagePath,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:Text(
        subTitle,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ) ,

    );
  }

}