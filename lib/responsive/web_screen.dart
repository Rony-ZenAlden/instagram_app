import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          IconButton(
            onPressed: () {
              navigationTapped(0);
            },
            icon: Icon(
              Icons.home,
              color: _page == 0
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(1);
            },
            icon: Icon(
              Icons.search,
              color: _page == 1
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(2);
            },
            icon: Icon(
              Icons.add_circle,
              color: _page == 2
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(3);
            },
            icon: Icon(
              Icons.favorite,
              color: _page == 3
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(4);
            },
            icon: Icon(
              Icons.person,
              color: _page == 4
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChange,
        children: AppDimensions.homeScreenItems,
      ),
    );
  }
}
