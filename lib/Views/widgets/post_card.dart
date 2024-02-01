import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/Controllers/firestore_controller.dart';
import 'package:instagram_app/Models/user_model.dart';
import 'package:instagram_app/Provider/user_provider.dart';
import 'package:instagram_app/Views/widgets/like_animation.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/global_variables.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../screens/comment_screen.dart';

class PostCardWidget extends StatefulWidget {
  const PostCardWidget({
    Key? key,
    required this.snap,
  }) : super(key: key);

  final snap;

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  final FireStoreController fireStoreController = FireStoreController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLength = snap.docs.length;
    } catch (error) {
      Get.snackbar(
        'Warning',
        error.toString(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > AppDimensions.webScreenSize
              ? AppColors.secondaryColor
              : AppColors.mobileBackgroundColor,
        ),
        color: AppColors.mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.snap['profileImage'],
                  ),
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(40),
                //   child: CachedNetworkImage(
                //     imageUrl: widget.snap['profileImage'],
                //     placeholder: (context, url) => const CircularProgressIndicator(),
                //     errorWidget: (context, url, error) => const Icon(Icons.error),
                //     height: 40,
                //     width: 40,
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['fullName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                            TextButton(
                              onPressed: () async {
                                fireStoreController
                                    .deletePost(widget.snap['postId']);
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Delete Post',
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
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 7,
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
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          //Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreController().likePost(
                widget.snap['postId'].toString(),
                user!.userId,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimationWidget(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Like Comment Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LikeAnimationWidget(
                isAnimating: widget.snap['likes'].contains(user?.userId),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreController().likePost(
                      widget.snap['postId'],
                      user!.userId,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user?.userId)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(CommentScreen(
                    snap: widget.snap,
                  ));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Share.share(widget.snap['postUrl']);
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //Description And Number OF Comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes'.tr,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: AppColors.primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['fullName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLength comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datPublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
