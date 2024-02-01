import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/Models/user_model.dart' as model;
import 'package:instagram_app/Provider/user_provider.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/global_variables.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
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
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  // MobileController mobileController = Get.put(MobileController());

  // @override
  // void initState() {
  //   super.initState();
  //   getUserName();
  // }
  //
  // void getUserName() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //
  //   setState(() {
  //     username = (snap.data() as Map<String, dynamic>)['fullName'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        physics:const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChange, // Move between screens
        children: AppDimensions.homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
            backgroundColor: AppColors.mobileBackgroundColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _page == 0 ? AppColors.primaryColor : AppColors.secondaryColor,
                ),
                label: '',
                backgroundColor: AppColors.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _page == 1 ? AppColors.primaryColor : AppColors.secondaryColor,
                ),
                label: '',
                backgroundColor: AppColors.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: _page == 2 ? AppColors.primaryColor : AppColors.secondaryColor,
                ),
                label: '',
                backgroundColor: AppColors.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: _page == 3 ? AppColors.primaryColor : AppColors.secondaryColor,
                ),
                label: '',
                backgroundColor: AppColors.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _page == 4 ? AppColors.primaryColor : AppColors.secondaryColor,
                ),
                label: '',
                backgroundColor: AppColors.primaryColor,
              ),
            ],
        onTap: navigationTapped,
      ),
    );
  }
}
