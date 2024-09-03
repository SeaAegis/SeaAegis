import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String username;
  final String email;
  

  UserDetails(
    {
      required this.uid,
      required this.username,
      required this.email,
});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
      };

  static UserDetails fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return UserDetails(
        uid: snapshot['uid'],
        username: snapshot['username'],
        email: snapshot['email'],
      );
  }
}