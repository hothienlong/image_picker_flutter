// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_flutter/model/media_source.dart';

class GalleryButtonWidget extends StatelessWidget {
  const GalleryButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => pickGalleryMedia(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: const [
            Icon(Icons.photo),
            SizedBox(width: 25.0,),
            Text("From Gallery", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))
          ],
        ),
      ),
    );
  }

  Future pickGalleryMedia(BuildContext context) async{
    final Object? source = ModalRoute.of(context)!.settings.arguments;

    // function
    final getMedia = source == MediaSource.image
        ? ImagePicker().pickImage
        : ImagePicker().pickVideo;

    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);

    // return data cho intent gọi nó
    Navigator.of(context).pop(file);
  }

}
