import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/Views/screens/auth/login_screen.dart';
import '../../../Controllers/auth_controller.dart';
import '../../../Controllers/theme_controller.dart';
import '../../../locale/locale_controller.dart';
import '../../../responsive/mobile_screen.dart';
import '../../../responsive/responsive.dart';
import '../../../responsive/web_screen.dart';
import '../../../utils/global_variables.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool obscureText = true;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

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

  registerUser() async {
    if (_image != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String res = await _authController.createNewUser(
          _userNameController.text,
          _emailController.text,
          _passwordController.text,
          _bioController.text,
          _image,
        );
        setState(() {
          _isLoading = false;
        });
        if (res == 'success') {
          setState(() {
            _isLoading = false;
          });
          Get.offAll(
            const Responsive(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          );
          _isLoading = false;
          Get.snackbar(
            'success'.tr,
            'Account has been created'.tr,
            backgroundColor: Colors.blue,
            colorText: Get.isDarkMode ? Colors.white : Colors.black,
            margin: const EdgeInsets.all(15),
          );
        } else {
          Get.snackbar(
            'Error Occurred',
            res.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Get.isDarkMode ? Colors.white : Colors.black,
            margin: const EdgeInsets.all(15),
          );
        }
      } else {
        Get.snackbar(
          'Form',
          'Form field is not valid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
          margin: const EdgeInsets.all(15),
          icon: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
      }
    } else {
      Get.snackbar(
        'WARNING',
        'You Must Pick An Image',
        backgroundColor: Colors.red,
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
        icon: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MyLocaleController controllerLang = Get.find();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          controllerLang.changeLang('ar');
                          Navigator.pop(context);
                        },
                        child: Text('1'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          controllerLang.changeLang('en');
                          Navigator.pop(context);
                        },
                        child: Text('2'.tr),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.message_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              ThemeController().changeTheme();
              setState(() {
                Get.isDarkMode;
              });
            },
            icon: Get.isDarkMode
                ? const Icon(
                    CupertinoIcons.sun_max_fill,
                  )
                : const Icon(
                    CupertinoIcons.moon_stars_fill,
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding:
              MediaQuery.of(context).size.width > AppDimensions.webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3)
                  : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flexible(
                    //   child: Container(),
                    //   flex: 2,
                    // ),
                    Get.isDarkMode
                        ? SvgPicture.asset(
                            'assets/ic_instagram.svg',
                            color: Colors.white,
                            height: 64,
                          )
                        : SvgPicture.asset(
                            'assets/ic_instagram.svg',
                            color: Colors.black,
                            height: 64,
                          ),
                    const SizedBox(height: 24),
                    Stack(
                      children: [
                        Get.isDarkMode
                            ? _image == null
                                ? const CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.white38,
                                    child: Icon(
                                      Icons.person,
                                      size: 65,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 65,
                                    backgroundImage: MemoryImage(_image!),
                                    backgroundColor: Colors.white38,
                                  )
                            : _image == null
                                ? const CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: 65,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 65,
                                    backgroundImage: MemoryImage(_image!),
                                    backgroundColor: Colors.white38,
                                  ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: IconButton(
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
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Full Name Must Not Be Empty';
                        } else {
                          return null;
                        }
                      },
                      controller: _userNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'enterFullName'.tr,
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Email Address Must Not Be Empty';
                        } else {
                          return null;
                        }
                      },
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'enterEmail'.tr,
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Password Must Not Be Empty';
                        } else {
                          return null;
                        }
                      },
                      controller: _passwordController,
                      obscureText: obscureText,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        hintText: 'enterPassword'.tr,
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Bio Not Be Empty';
                        } else {
                          return null;
                        }
                      },
                      controller: _bioController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.account_circle_sharp),
                        hintText: 'enterBio'.tr,
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        registerUser();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Sign in'.tr,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Flexible(
                    //   child: Container(),
                    //   flex: 2,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.offAll(
                              const LoginScreen(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Already have an'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
