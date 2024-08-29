import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;

class FirebaseStoragePage extends StatefulWidget {
  FirebaseStoragePage({super.key});

  @override
  _FirebaseStoragePageState createState() => _FirebaseStoragePageState();
}

class _FirebaseStoragePageState extends State<FirebaseStoragePage> {
  final storageRef = FirebaseStorage.instance.ref();
  String? imageUrl;

  // Create a reference to image file
  final myImageRef = FirebaseStorage.instance.ref().child("upload");

  //
  @override
  void initState() {
    super.initState();
    _fetchImage();
    _uploadImage();
  }

  void _fetchImage() async {
    try {
      final ref = storageRef.child('download/nabe.png');
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
      print('Image URL: $imageUrl');
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  void _uploadImage() async {
    try {
      final data =
          await rootBundle.load('assets/images/Book.jpg'); // アップロードするファイル
      final ref = myImageRef.child('test.jpg'); // upload先のファイル名
      final uploadTask = ref.putData(data.buffer.asUint8List());
      final snapshot =
          await uploadTask.whenComplete(() => print('Upload complete'));
      final url = await snapshot.ref.getDownloadURL();
      print('Uploaded image URL: $url');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase Storage'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Firebase Storage'),
              const SizedBox(height: 24),
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Failed to load image: ${error}');
                      },
                    )
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}