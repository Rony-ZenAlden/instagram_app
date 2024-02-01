import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_app/Controllers/auth_controller.dart';
import 'package:instagram_app/Models/post_model.dart';
import 'package:uuid/uuid.dart';

class FireStoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController authController = AuthController();

  // Upload Post
  Future<String> uploadPost(String description, Uint8List image, String uid,
      String fullName, String profImage) async {
    String res = 'Some Error Occurred';
    try {
      String photoUrl =
          await authController.uploadImageToStorage('Posts', image, true);
      String postId = const Uuid().v4();
      Posts post = Posts(
        description: description,
        uid: uid,
        fullName: fullName,
        postId: postId,
        datPublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String userUid, List likes) async {
    try {
      if (likes.contains(userUid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([userUid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([userUid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> likeComment(
      String postId, String userUid, List likess, String commentId) async {
    try {
      if (likess.contains(userUid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likess': FieldValue.arrayRemove([userUid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likess': FieldValue.arrayUnion([userUid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profImage) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profImage': profImage,
          'name': name,
          'text': text,
          'uid': uid,
          'likess': [],
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is Empty');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      Get.snackbar(
        'Warning',
        e.toString(),
      );
    }
  }

  Future<void> followUser(String uid, String followId) async{
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    }catch(error) {
      print(error.toString());
    }
  }
}
