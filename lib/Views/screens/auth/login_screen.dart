import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram_app/Controllers/auth_controller.dart';
import 'package:instagram_app/Controllers/theme_controller.dart';
import 'package:instagram_app/Views/screens/auth/forget_password_screen.dart';
import 'package:instagram_app/Views/screens/auth/signin_screen.dart';
import 'package:instagram_app/utils/global_variables.dart';
import '../../../global_widgets/subtitle_text.dart';
import '../../../locale/locale_controller.dart';
import '../../../responsive/mobile_screen.dart';
import '../../../responsive/responsive.dart';
import '../../../responsive/web_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool obscureText = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String res = await _authController.loginUser(
        _emailController.text,
        _passwordController.text,
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
          'loginSuccess'.tr,
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
                    const SizedBox(height: 64),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(
                            () => const ForgetPasswordScreen(),
                          );
                        },
                        child: SubtitleTextWidget(
                          label: 'forgotPassword'.tr,
                          fontStyle: FontStyle.italic,
                          textDecoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        login();
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
                                'login'.tr,
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
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'do not have'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAll(
                              () => const SignInScreen(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Sign in'.tr,
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
