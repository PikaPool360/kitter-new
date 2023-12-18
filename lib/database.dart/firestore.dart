/*

This database stores post that the users have published in the app.
It is stored in a collection called 'Posts' in Firebase

Each post contains;
- a message
- email of user
- timestamp

*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user

  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase

  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  // post a message

  Future<void> addPost(String message) {
    //print("Start listening");
    //startListening();

    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  //read posts from database

  Stream<QuerySnapshot> getPostsStream() {
    print("testing here!!!");
    final postsStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }

  StreamSubscription<QuerySnapshot>? postSubscription;

  void listenToPosts() {
    postSubscription = getPostsStream().listen((QuerySnapshot snapshot) {
      // Access the documents in the snapshot
      print("Got response");
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        // Access the data in each document
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Verify the value (replace 'fieldName' with the actual field name)
        dynamic fieldValue = data['PostMessage'];

        print("Field value is $fieldValue");
      }
    });
  }

// Call this method to start listening to the stream
  void startListening() {
    listenToPosts();
  }
}
