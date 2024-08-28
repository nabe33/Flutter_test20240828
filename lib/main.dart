import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseOptions for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-Firebase Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter-Firebase Auth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Authentication
  String _email = '';
  String _password = '';

  //-------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'パスワード（6文字以上）',
                ),
              ),
              // ユーザ登録ボタン
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final User? user = (await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      ))
                          .user;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('ユーザ登録成功:  ${user?.email}, ${user?.uid}'),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('ユーザ登録失敗: ${e.message}'),
                        ),
                      );
                    }
                  },
                  child: const Text('ユーザ登録'),
                ),
              ),

              // ログインボタン
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final User? user = (await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      ))
                          .user;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('ログイン成功: ${user?.email}, ${user?.uid}'),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('ログイン失敗: ${e.message}'),
                        ),
                      );
                    }
                  },
                  child: const Text('ログイン'),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Firestoreからデータを取得
                  FirebaseFirestore.instance
                      .collection('test1')
                      .doc('doc1')
                      .get()
                      .then((ref) {
                    print(ref.get('data'));
                  });
                }, // OnPressed(
                child: const Text(
                  'FireStoreから読み込み',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Firestoreにデータを書き込む
                  FirebaseFirestore.instance
                      .doc('test1/doc1')
                      .set({'data': 'Hello Firestore!'}).then(
                          (value) => print('Firestoreに書き込みました'));
                },
                child: const Text(
                  'FireStoreに書き込み',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Firestoreにデータを追加
                  FirebaseFirestore.instance
                      .collection('test1')
                      .add({'data': 'test add2collection!'}).then(
                          (value) => print('Firestoreに追加しました'));
                },
                child: const Text(
                  'FireStoreにデータ追加',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Firestoreの全データを取得
                  FirebaseFirestore.instance.collection('test1').get().then(
                      (event) => {
                            for (var doc in event.docs)
                              print('${doc.id} => ${doc.data()}')
                          }); // get().then
                },
                child: const Text(
                  'データをすべて取得',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => {
                  // Firestoreページに遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirebasePage()),
                  )
                },
                child: const Text(
                  'Firebaseページ',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}