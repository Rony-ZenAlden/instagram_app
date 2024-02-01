import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/Models/user_model.dart' as model;
import 'package:uuid/uuid.dart';

class AuthController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return print('No Image Select');
    }
  }

  uploadImageToStorage(String name ,Uint8List? image, bool isPost) async {
    Reference ref =
        _storage.ref().child(name).child(_auth.currentUser!.uid);

    if(isPost) {
      String id = const Uuid().v1();
      ref.child(id);
    }

    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> createNewUser(String fullName, String email, String password,
      String bio, Uint8List? image) async {
    String res = 'Some Error Occurred';
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String downloadUrl = await uploadImageToStorage('profileImages',image, false);

      model.User user = model.User(
        fullName: fullName,
        profileImage: downloadUrl,
        email: email,
        bio: bio,
        userId: userCredential.user!.uid,
        followers: [],
        following: [],
      );

      await _fireStore.collection('users').doc(userCredential.user!.uid).set(
            user.toJson(),
          );

      // await _fireStore.collection('users').add({
      //   'fullName': fullName,
      //   'profileImage': downloadUrl,
      //   'email': email,
      //   'bio': bio,
      //   'userId': userCredential.user!.uid,
      //   'followers': [],
      //   'following': [],
      // });

      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    // on FirebaseAuthException catch(err) {
    //   if(err.code == 'invalid-email'){
    //    res = 'The Email is badly formatted';
    //   }else if(err.code == 'weak-password'){
    //     res = 'Password should be at least 6 characters';
    //   }
    // }
    return res;
  }

  Future<String> loginUser(String email, String password) async {
    String res = 'Some Error Occurred';
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
