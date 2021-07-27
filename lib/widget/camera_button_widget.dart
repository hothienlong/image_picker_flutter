import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_flutter/model/media_source.dart';
// import 'dart:html';
import 'dart:io';

class CameraButtonWidget extends StatelessWidget {
  const CameraButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => pickCameraMedia(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: const [
            Icon(Icons.camera_alt),
            SizedBox(width: 25.0,),
            Text("From Camera", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))
          ],
        ),
      ),
    );
  }

  Future pickCameraMedia(BuildContext context) async {
    print("pickCameraMedia");
    final Object? source = ModalRoute.of(context)!.settings.arguments;

    // function
    final getMedia = source == MediaSource.image
        ? ImagePicker().pickImage
        : ImagePicker().pickVideo;

    final media = await getMedia(source: ImageSource.camera);
    print("alo");
    print(media == null);
    final file = File(media!.path);

    print("file: " + file.toString());
    // return data cho intent gọi nó
    Navigator.of(context).pop(file);
  }
}
