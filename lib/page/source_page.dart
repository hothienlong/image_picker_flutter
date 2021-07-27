import 'package:flutter/material.dart';
import 'package:image_picker_flutter/widget/camera_button_widget.dart';
import 'package:image_picker_flutter/widget/gallery_button_widget.dart';

class SourcePage extends StatelessWidget {
  const SourcePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Source"),
      ),
      body: ListView(
        children: const[
          CameraButtonWidget(),
          GalleryButtonWidget(),
        ],
      ),
    );
  }
}

