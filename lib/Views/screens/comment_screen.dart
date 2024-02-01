import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/Controllers/firestore_controller.dart';
import 'package:instagram_app/Models/user_model.dart';
import 'package:instagram_app/Provider/user_provider.dart';
import 'package:instagram_app/Views/widgets/loading_widgets.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:provider/provider.dart';

import '../widgets/comment_card_widget.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    Key? key,
    this.snap,
  }) : super(key: key);

  final snap;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final FireStoreController fireStoreController = FireStoreController();
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackgroundColor,
        title: const Text(
          'Comments',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CommentCardWidget(
                  snap: snapshot.data!.docs[index].data(),
                );
              });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user!.profileImage,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Write as ${user.fullName}...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await fireStoreController.postComment(
                    widget.snap['postId'],
                    controller.text,
                    user.userId,
                    user.fullName,
                    user.profileImage,
                  );
                  setState(() {
                    controller.text = '';
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
