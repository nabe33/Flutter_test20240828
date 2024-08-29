import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStoragePage extends StatefulWidget {
  const FirebaseStoragePage({super.key});

  @override
  _FirebaseStoragePageState createState() => _FirebaseStoragePageState();
}

class _FirebaseStoragePageState extends State<FirebaseStoragePage> {
  Image? _img;
  Text? _text;

  Future<void> _download() async {
    // file download
    FirebaseStorage storage = FirebaseStorage.instance;
    // image
    Reference ImageRef = storage.ref().child('download').child('nabe.png');
    String imageUrl = await ImageRef.getDownloadURL();
    // text
    Reference textRef = storage.ref('download/nabe.txt');
    var data = await textRef.getData();
    // 画面に反映
    setState(() {
      _img = Image.network(imageUrl);
      _text = Text(utf8.decode(data!)); // ascii.decode() でも可
    });

    // 画像ファイルはローカルにも保存
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/downloaded.png');
    try {
      await ImageRef.writeToFile(downloadToFile);
    } catch (e) {
      print('Download Error: $e');
    }
  }

  // アップロード処理
  void _upload() async {
    // ImagePickerで画像を選択
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) return;
    File file = File(pickerFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref('upload/test.png').putFile(file);
      setState(() {
        _img = null;
        _text = const Text('Upload complete');
      });
    } catch (e) {
      print('Upload Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase Storage(Kindle本版)'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ダウンロードした画像とテキストファイル内の文字を表示
            children: <Widget>[
              if (_img != null) _img!,
              if (_text != null) _text!,
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _upload,
              tooltip: 'Upload',
              heroTag: 'uploadButton', // Unique heroTag
              child: const Icon(Icons.file_upload),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _download,
              tooltip: 'Download',
              heroTag: 'downloadButton', // Unique heroTag
              child: const Icon(Icons.file_download),
            ),
          ]),
    );
  }
}