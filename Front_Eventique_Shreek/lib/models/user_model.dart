import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class OneUser {
  int? id;
  String? name;
  String? email;
  String? imageUrl;
  OneUser({this.id, this.name, this.email, this.imageUrl});
  factory OneUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OneUser(
      id: doc.id as int,
      name: data['name'],
      email: data['email'],
      imageUrl: data['imageUrl'],
    );
  }
}
