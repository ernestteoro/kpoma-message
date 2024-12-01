

import 'package:file_picker/file_picker.dart';

class MediaService{

  MediaService();

  Future<PlatformFile> pickImageFromLibrary() async{
    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(type: FileType.image);
    if(filePickerResult!=null){
      return filePickerResult.files[0];
    }
    return null;
  }



}