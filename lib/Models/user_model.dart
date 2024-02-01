import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String fullName;
  final String profileImage;
  final String email;
  final String bio;
  final String userId;
  final List followers;
  final List following;

  const User({
    required this.fullName,
    required this.profileImage,
    required this.email,
    required this.bio,
    required this.userId,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'profileImage': profileImage,
        'email': email,
        'bio': bio,
        'userId': userId,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      fullName: snapshot['fullName'],
      profileImage: snapshot['profileImage'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      userId: snapshot['userId'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
