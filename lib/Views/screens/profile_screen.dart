import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/Controllers/auth_controller.dart';
import 'package:instagram_app/Controllers/firestore_controller.dart';
import 'package:instagram_app/Views/screens/auth/login_screen.dart';
import 'package:instagram_app/Views/widgets/loading_widgets.dart';
import 'package:instagram_app/utils/colors.dart';
import '../../Controllers/theme_controller.dart';
import '../../locale/locale_controller.dart';
import '../widgets/follow_button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;
      followers = snap.data()!['followers'].length;
      following = snap.data()!['following'].length;
      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postSnap.docs.length;
      isFollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (error) {
      Get.snackbar('Warning', error.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyLocaleController controllerLang = Get.find();
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                userData['fullName'],
              ),
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
                          CupertinoIcons.moon_stars_fill,
                        )
                      : const Icon(
                          CupertinoIcons.sun_min_fill,
                        ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(userData['profileImage']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLength, 'posts'.tr),
                                    buildStatColumn(followers, 'followers'.tr),
                                    buildStatColumn(following, 'following'.tr),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? Container(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: TextButton(
                                              onPressed: () async {
                                                await AuthController()
                                                    .signOut();
                                                if (context.mounted) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen(),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .mobileBackgroundColor,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                alignment: Alignment.center,
                                                width: 250,
                                                height: 27,
                                                child: Text(
                                                  'signOut'.tr,
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : isFollowing
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await FireStoreController()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['userId'],
                                                    );
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      border: Border.all(
                                                        color: Colors.blue,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    alignment: Alignment.center,
                                                    width: 250,
                                                    height: 27,
                                                    child: const Text(
                                                      'Unfollow',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await FireStoreController()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['userId'],
                                                    );

                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      border: Border.all(
                                                        color: Colors.blue,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    alignment: Alignment.center,
                                                    width: 250,
                                                    height: 27,
                                                    child: const Text(
                                                      'Follow',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['fullName'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return SizedBox(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                // Center(
                //   child: ElevatedButton.icon(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blue,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(
                //           30.0,
                //         ),
                //       ),
                //     ),
                //     icon: Icon(
                //       user == null ? Icons.login : Icons.logout,
                //       color: Colors.white,
                //     ),
                //     label: Text(
                //       user == null ? "Login" : "Logout",
                //       style: const TextStyle(
                //           color: Colors.white, fontWeight: FontWeight.w500),
                //     ),
                //     onPressed: () async {
                //       if (user == null) {
                //         Get.to(const LoginScreen());
                //       } else {
                //         showDialog(
                //           context: context,
                //           builder: (context) => AlertDialog(
                //             content: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 const SizedBox(
                //                   height: 16.0,
                //                 ),
                //                 const Text(
                //                   'Warning',
                //                   style: TextStyle(
                //                       fontWeight: FontWeight.w600,
                //                       fontSize: 22),
                //                 ),
                //                 const SizedBox(
                //                   height: 16.0,
                //                 ),
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     TextButton(
                //                       onPressed: () {
                //                         Navigator.pop(context);
                //                       },
                //                       child: const Text(
                //                         'Cancel',
                //                         style: TextStyle(
                //                             fontWeight: FontWeight.w600,
                //                             color: Colors.green),
                //                       ),
                //                     ),
                //                     TextButton(
                //                       onPressed: () async {
                //                         await FirebaseAuth.instance.signOut();
                //                         if (!mounted) return;
                //                         Get.offAll(const LoginScreen());
                //                       },
                //                       child: const Text(
                //                         'Ok',
                //                         style: TextStyle(
                //                             fontWeight: FontWeight.w600,
                //                             color: Colors.red),
                //                       ),
                //                     ),
                //                   ],
                //                 )
                //               ],
                //             ),
                //           ),
                //         );
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
