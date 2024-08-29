import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fb_storage.dart';

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  _FirebasePageState createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  List<String> _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final docRef = FirebaseFirestore.instance
        .collection("cities")
        .orderBy("name", descending: true)
        .limit(3);

    docRef.get().then(
      (event) {
        print("成功!");
        List<String> dataList = [];
        for (var doc in event.docs) {
          dataList.add('${doc.id} => ${doc.data()}');
        }
        setState(() {
          _dataList = dataList;
        });
      },
      onError: (error) => print("Error completing: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase Firestore'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Firebase Firestore'),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_dataList[index]),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () => {
                  // Firestoreページに遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirebaseStoragePage()),
                  )
                },
                child: const Text(
                  'Firebase Storageページ',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}