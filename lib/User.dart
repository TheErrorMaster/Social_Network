import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String profileImageUrl;
  final String email;
  final String bio;
  final String name;
  final String phone;

  User({
    this.id,
    this.username,
    this.profileImageUrl,
    this.email,
    this.bio,
    this.name,
    this.phone,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      username: doc['username'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      name: doc['name'] ?? '',
      phone: doc['phone'] ?? '',
    );
  }
}
