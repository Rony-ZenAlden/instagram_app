import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/global_variables.dart';
import '../widgets/loading_widgets.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: width > AppDimensions.webScreenSize
          ? AppColors.webBackgroundColor
          : AppColors.mobileBackgroundColor,
      appBar: width > AppDimensions.webScreenSize
          ? null
          : AppBar(
        centerTitle: true,
              title: Get.isDarkMode
                  ? SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: Colors.white,
                      height: 44,
                    )
                  : SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: Colors.black,
                      height: 44,
                    ),
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal:
                      width > AppDimensions.webScreenSize ? width * 0.3 : 0,
                  vertical: width > AppDimensions.webScreenSize ? 15 : 0,
                ),
                child: PostCardWidget(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
