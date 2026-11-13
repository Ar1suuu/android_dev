import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:flutter/material.dart";

class CommentWidget extends StatelessWidget {
  final CommentModel comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: NetworkImage(comment.avatarUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Expanded(child: Text(comment.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
