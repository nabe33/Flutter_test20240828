import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class FirebasePage extends StatelessWidget {
  FirebasePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Firestore
    final cities = FirebaseFirestore.instance.collection("cities");
    final data1 = <String, dynamic>{
      "name": "San Francisco",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 860000,
      "regions": ["west_coast", "norcal"]
    };
    cities.doc("SF").set(data1);

    final data2 = <String, dynamic>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 3900000,
      "regions": ["west_coast", "socal"],
    };
    cities.doc("LA").set(data2);

    final data3 = <String, dynamic>{
      "name": "Washington D.C.",
      "state": null,
      "country": "USA",
      "capital": true,
      "population": 680000,
      "regions": ["east_coast"]
    };
    cities.doc("DC").set(data3);

    final data4 = <String, dynamic>{
      "name": "Tokyo",
      "state": null,
      "country": "Japan",
      "capital": true,
      "population": 9000000,
      "regions": ["kanto", "honshu"]
    };
    cities.doc("TOK").set(data4);

    final data5 = <String, dynamic>{
      "name": "Beijing",
      "state": null,
      "country": "China",
      "capital": true,
      "population": 21500000,
      "regions": ["jingjinji", "hebei"],
    };
    cities.doc("BJ").set(data5);

    // **Ex: Get various references to the Firestore service **
    // final docRef = FirebaseFirestore.instance.collection("cities").doc("SF");

    // final docRef = FirebaseFirestore.instance.collection("cities");

    final docRef = FirebaseFirestore.instance
        .collection("cities")
        .orderBy("name", descending: true)
        .limit(3);

    // final docRef = FirebaseFirestore.instance
    //     .collection("cities")
    //     .where("state", isEqualTo: "CA");

    // final docRef = FirebaseFirestore.instance
    //     .collection("cities")
    //     .where("capital", isEqualTo: true);

    // docRef.snapshots().listen(
    //       (event) => print("current data: ${event.data()}"),
    //       onError: (error) => print("Listen failed: $error"),
    //     );
    docRef.get().then(
      (event) {
        print("成功!");
        for (var doc in event.docs) {
          print('${doc.id} => ${doc.data()}');
        }
      },
      onError: (error) => print("Error completing: $error"),
    );

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
            ],
          ),
        ),
      ),
    );
  }
}