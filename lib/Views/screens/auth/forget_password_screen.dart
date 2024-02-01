import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/app_name_text.dart';
import '../../../global_widgets/subtitle_text.dart';
import '../../../global_widgets/title_text.dart';
import '../../../utils/global_variables.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  late final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      Get.snackbar('Notice', 'Password Reset');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Warning', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppNameTextWidget(
          text: 'forgotPassword'.tr,
          fontSize: 28,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            padding:
                MediaQuery.of(context).size.width > AppDimensions.webScreenSize
                    ? EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 3)
                    : const EdgeInsets.symmetric(horizontal: 32),
            child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Section 1 - Header
                const SizedBox(
                  height: 10,
                ),
                MediaQuery.of(context).size.width > AppDimensions.webScreenSize
                    ? Image.asset(
                        'assets/forgot_password.jpg',
                        width: size.width * 0.25,
                        height: size.width * 0.25,
                      )
                    : Image.asset(
                        'assets/forgot_password.jpg',
                        // width: size.width * 0.6,
                        // height: size.width * 0.6,
                      ),
                const SizedBox(
                  height: 10,
                ),
                TitlesTextWidget(
                  label: 'forgotPassword'.tr,
                  fontSize: 22,
                ),
                SubtitleTextWidget(
                  label: 'pleaseEnter'.tr,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 40,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'enterEmail'.tr,
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(Icons.email),
                          ),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Email Address Must Not Be Empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      // backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.send),
                    label: Text(
                      'resetPassword'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () async {
                      passwordReset();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
