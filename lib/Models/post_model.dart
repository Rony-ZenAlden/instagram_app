import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String description;
  final String uid;
  final String fullName;
  final String postId;
  final datPublished;
  final String postUrl;
  final String profileImage;
  final likes;

  Posts({
    required this.description,
    required this.uid,
    required this.fullName,
    required this.postId,
    required this.datPublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'fullName': fullName,
        'postId': postId,
        'datPublished': datPublished,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes,
      };

  static Posts formSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Posts(
      fullName: snapshot['fullName'],
      description: snapshot['description'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datPublished: snapshot['datPublished'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
