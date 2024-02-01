import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/Views/screens/add_post_screen.dart';

import '../Views/screens/home_screen.dart';
import '../Views/screens/notification_screen.dart';
import '../Views/screens/profile_screen.dart';
import '../Views/screens/search_screen.dart';

class AppDimensions {
  static const webScreenSize = 600;

  static List<Widget> homeScreenItems = [
    const HomeScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const NotificationScreen(),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
}
