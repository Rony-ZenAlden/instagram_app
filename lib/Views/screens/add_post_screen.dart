import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/Controllers/firestore_controller.dart';
import 'package:instagram_app/Provider/user_provider.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../Controllers/auth_controller.dart';
import '../../Controllers/theme_controller.dart';
import '../../Models/user_model.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final AuthController _authController = AuthController();
  Uint8List? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  selectProfileImage() async {
    Uint8List? im = await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List? im = await _authController.pickProfileImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  void postImage(String uid, String fullName, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreController().uploadPost(
        _descriptionController.text,
        _image!,
        uid,
        fullName,
        profImage,
      );

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Posted',
          'The Post Has Been Uploaded',
          backgroundColor: Colors.blue,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
          margin: const EdgeInsets.all(15),
        );
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Error Occurred',
          res.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
          margin: const EdgeInsets.all(15),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error Occurred',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _image == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        backgroundColor: Colors.white,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Create a Post',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                selectProfileImage();
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: Colors.pink,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Pick Image From Gallery',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextButton(
                              onPressed: () {
                                selectCameraImage();
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    'Take Photo',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.upload,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Upload Posts'.tr),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              // backgroundColor: AppColors.mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              title: const Text('Post'),
              actions: [
                TextButton(
                  onPressed: () {
                    return postImage(
                      user!.userId,
                      user.fullName,
                      user.profileImage,
                    );
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                const SizedBox(height: 10),
                _isLoading
                    ? const LinearProgressIndicator(
                        color: Colors.blue,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        user!.profileImage,
                      ),
                      backgroundColor: Colors.white38,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_image!),
                              fit: BoxFit.fill,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
