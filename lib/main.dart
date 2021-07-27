import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_flutter/page/source_page.dart';
import 'package:image_picker_flutter/widget/video_widget.dart';
import 'package:path/path.dart' as pk_path;
import 'model/media_source.dart';
import 'package:http_parser/http_parser.dart';

// chạy đc cho máy ảo Pixel 3 29
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ko nên dùng await ở đây sẽ làm app chờ ko cần thiết
  // -> dùng Future & Future builder để bất đồng bộ
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // final Future<FirebaseApp> firebaseApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
        // home: FutureBuilder(
        //   future: firebaseApp,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       print('You have an error! ${snapshot.error.toString()}');
        //       return const Text('Something went wrong');
        //     } else if (snapshot.hasData) {
        //       return const MyHomePage();
        //     } else {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   },
        // )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? fileMedia;
  MediaSource? source;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick image & video"),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: fileMedia == null
                ? const Icon(Icons.photo, size: 120)
                : (source == MediaSource.image
                    ? Image.file(fileMedia!)
                    : VideoWidget(fileMedia!)),
          ),
          MaterialButton(
            onPressed: () {
              capture(MediaSource.image);
            },
            child: const Text("Capture Image"),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            shape: const StadiumBorder(),
          ),
          MaterialButton(
            onPressed: () {
              capture(MediaSource.video);
            },
            child: const Text("Capture Video"),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            shape: const StadiumBorder(),
          ),
          MaterialButton(
            onPressed: () {
              uploadPic();
            },
            child: const Text("Upload Firebase"),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            shape: const StadiumBorder(),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      )),
    );
  }

  Future capture(MediaSource source) async {
    setState(() {
      this.source = source;
      this.fileMedia = null; // set image null when back to home screen
    });

    // get return data from intent SourcePage
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SourcePage(),
          // gửi data qua intent
          settings: RouteSettings(
            arguments: source,
          )),
    );

    if (result == null) {
      print("not ok");
      return;
    } else {
      print("ok");
      setState(() {
        fileMedia = result;
      });
    }
  }

  uploadPic() async {
    // String fileName = pk_path.basename(fileMedia!.path);
    // DatabaseReference _testRef = FirebaseDatabase.instance.reference().child("image");
    // _testRef.set(fileMedia);
    // await Dio().post("http://10.0.2.2:3000/upload");

    String filename = fileMedia!.path.split('/').last;
    print(filename);
    FormData formData = FormData.fromMap({
      "pic": await MultipartFile.fromFile(fileMedia!.path,
          filename: filename, contentType: MediaType('image', 'jpg')),
      "type": "image/jpg"
    });

    Response response = await Dio().post("http://10.0.2.2:3000/upload",
        data: formData,
        options: Options(headers: {
          "accept": "*/*",
          "Authorization": "Bearer accesstoken",
          "Content-Type": "multipart/form-data"
        }));

    print(response.statusCode);
  }
}
