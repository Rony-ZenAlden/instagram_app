import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:instagram_app/Views/screens/profile_screen.dart';
import 'package:instagram_app/Views/widgets/loading_widgets.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  bool isShow = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackgroundColor,
        title: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: 'search'.tr),
          onFieldSubmitted: (String _) {
            setState(() {
              isShow = true;
            });
          },
        ),
      ),
      body: isShow
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('fullName', isGreaterThanOrEqualTo: controller.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingScreen();
                }
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(
                            ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['userId'],
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['profileImage'],
                            ),
                          ),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['fullName'],
                          ),
                        ),
                      );
                    });
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl']);
                  },
                  staggeredTileBuilder: (int index) {
                    return width > AppDimensions.webScreenSize ? StaggeredTile.count(
                      (index % 7 == 0) ? 1 : 1,
                      (index % 7 == 0) ? 1 : 1,
                    ) : StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1,
                      (index % 7 == 0) ? 2 : 1,
                    );
                  },
                );
              },
            ),
    );
  }
}
