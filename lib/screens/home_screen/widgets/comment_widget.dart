import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/providers/post_providers.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_ui/material_ui.dart";

class CommentWidget extends ConsumerWidget {
  final int postId;
  final CommentModel comment;

  const CommentWidget({
    super.key,
    required this.postId,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: AssetImage(comment.avatarPath),
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
          SizedBox(
            width: 36,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    ref
                        .read(postsProvider.notifier)
                        .toggleCommentLike(postId, comment.id);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    comment.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 18,
                    color: comment.isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                Text(
                  "${comment.likeCount}",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
