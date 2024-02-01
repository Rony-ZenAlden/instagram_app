import 'package:flutter/material.dart';
import 'package:instagram_app/Views/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Controllers/firestore_controller.dart';
import '../../Models/user_model.dart';
import '../../Provider/user_provider.dart';

class CommentCardWidget extends StatefulWidget {
  const CommentCardWidget({
    Key? key,
    this.snap,
  }) : super(key: key);

  final snap;

  @override
  State<CommentCardWidget> createState() => _CommentCardWidgetState();
}

class _CommentCardWidgetState extends State<CommentCardWidget> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profImage'],
            ),
            radius: 28,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        TextSpan(
                          text: '\n  ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          LikeAnimationWidget(
            isAnimating: widget.snap['likess'].contains(user?.userId),
            smallLike: true,
            child: IconButton(
              onPressed: () async {
                await FireStoreController().likeComment(
                  widget.snap['postId'].toString(),
                  user!.userId,
                  widget.snap['likess'],
                  widget.snap['commentId'].toString(),
                );
              },
              icon: widget.snap['likess'].contains(user?.userId)
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
        ],
      ),
    );
  }
}
