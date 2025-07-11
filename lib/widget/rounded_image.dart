import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RoundedNetworkImage extends StatelessWidget{

  final String imagePath;
  final double size;

  RoundedNetworkImage({Key key, this.imagePath, this.size}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imagePath)
        ),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: Colors.black
      ),
    );
  }
}



class RoundedImageFile extends StatelessWidget{

  final PlatformFile image;
  final double size;

  RoundedImageFile({Key key, this.image, this.size}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(File(image.path))
          ),
          borderRadius: BorderRadius.all(Radius.circular(size)),
          color: Colors.black
      ),
    );
  }
}

class RoundedImageNetworkWithStatusIndicator extends RoundedNetworkImage{
  final bool isActive;

  RoundedImageNetworkWithStatusIndicator({Key key,String imagePath, double size, this.isActive}): super(key:key, imagePath: imagePath, size: size);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Container(
          height: size *0.20,
          width: size *0.20,
          decoration: BoxDecoration(
            color: isActive ? Colors.green: Colors.red,
            borderRadius: BorderRadius.circular(size),
          ),
        )
      ],
    );

  }

}